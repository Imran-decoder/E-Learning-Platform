import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final Function(String) onVerificationSuccess;

  const VerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.onVerificationSuccess,
  }) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  String _verificationId = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sendOtp(widget.phoneNumber);
  }

  void _sendOtp(String phoneNumber) async {
    setState(() => _isLoading = true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (auth.PhoneAuthCredential credential) async {
          await _handleCredential(credential);
        },
        verificationFailed: (auth.FirebaseAuthException e) {
          _showErrorSnackBar("Verification failed: ${_getReadableErrorMessage(e)}");
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() => _verificationId = verificationId);
          _showSuccessSnackBar("OTP sent to your phone.");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() => _verificationId = verificationId);
        },
      );
    } catch (e) {
      _showErrorSnackBar("Error sending OTP: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCredential(auth.PhoneAuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        _showSuccessSnackBar("Phone number verified successfully!");
        widget.onVerificationSuccess(widget.phoneNumber);
      }
    } catch (e) {
      _showErrorSnackBar("Authentication failed: ${_getReadableErrorMessage(e)}");
    }
  }

  void _verifyOtp(String otp) async {
    if (otp.length != 4) {
      _showErrorSnackBar("Please enter a valid 4-digit OTP");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = auth.PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _handleCredential(credential);
    } catch (e) {
      _showErrorSnackBar("Invalid OTP: ${_getReadableErrorMessage(e)}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getReadableErrorMessage(dynamic error) {
    if (error is auth.FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-verification-code':
          return 'The OTP you entered is invalid';
        case 'code-expired':
          return 'The OTP has expired. Please request a new one';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        default:
          return error.message ?? 'An unknown error occurred';
      }
    }
    return error.toString();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LogoWithTitle(
        title: 'Verification',
        subText: "SMS Verification code has been sent",
        children: [
          Text(widget.phoneNumber),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            OtpForm(onSubmitOtp: _verifyOtp),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _isLoading ? null : () => _sendOtp(widget.phoneNumber),
            child: const Text("Resend OTP"),
          ),
        ],
      ),
    );
  }
}

class OtpForm extends StatefulWidget {
  final ValueChanged<String> onSubmitOtp;

  const OtpForm({Key? key, required this.onSubmitOtp}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _otp = List.generate(4, (index) => "");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: OtpTextFormField(
                    onChanged: (value) {
                      _otp[index] = value;
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmitOtp(_otp.join());
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFF00BF6D),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const StadiumBorder(),
            ),
            child: const Text("Verify OTP"),
          ),
        ],
      ),
    );
  }
}
const InputDecoration otpInputDecoration = InputDecoration(
  filled: false,
  border: UnderlineInputBorder(),
  hintText: "0",
);

class OtpTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final bool autofocus;

  const OtpTextFormField(
      {Key? key,
      this.focusNode,
      this.onChanged,
      this.onSaved,
      this.autofocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      onChanged: onChanged,
      onSaved: onSaved,
      autofocus: autofocus,
      obscureText: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: otpInputDecoration,
    );
  }
}

class LogoWithTitle extends StatelessWidget {
  final String title, subText;
  final List<Widget> children;

  const LogoWithTitle(
      {Key? key,
      required this.title,
      this.subText = '',
      required this.children})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.1),
              Image.asset('assets/images/splash.png', height: 146),
              SizedBox(
                height: constraints.maxHeight * 0.1,
                width: double.infinity,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  subText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.64),
                  ),
                ),
              ),
              ...children,
            ],
          ),
        );
      }),
    );
  }
}
