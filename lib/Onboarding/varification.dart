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
          _showErrorSnackBar("Verification failed: ${e.message}");
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
      _showErrorSnackBar("Authentication failed: ${e.toString()}");
    }
  }

  void _verifyOtp(String otp) async {
    if (otp.length != 6) {
      _showErrorSnackBar("Please enter a valid 6-digit OTP");
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
      _showErrorSnackBar("Invalid OTP: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
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
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Enter the OTP sent to ${widget.phoneNumber}",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OtpForm(onSubmitOtp: _verifyOtp),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : TextButton(
              onPressed: () => _sendOtp(widget.phoneNumber),
              child: const Text("Resend OTP"),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpForm extends StatelessWidget {
  final ValueChanged<String> onSubmitOtp;

  const OtpForm({Key? key, required this.onSubmitOtp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _otpController = TextEditingController();

    return Column(
      children: [
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: "OTP",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => onSubmitOtp(_otpController.text),
          child: const Text("Verify"),
        ),
      ],
    );
  }
}
