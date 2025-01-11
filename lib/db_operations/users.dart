import 'package:cloud_firestore/cloud_firestore.dart';

// Model class to represent our user data structure
class User {
  final String userID;
  final String userName;
  final List<String> enrolledCourses;
  final UserProfile Profile;

  User({
    required this.userID,
    required this.userName,
    required this.enrolledCourses,
    required this.Profile,
  });

  // Convert User object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'enrolledCourses': enrolledCourses,
      'Profile': Profile.toMap(),
    };
  }

  // Create User object from Firestore document
  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      userID: data['userID'],
      userName: data['userName'],
      enrolledCourses: List<String>.from(data['enrolledCourses']),
      Profile: UserProfile.fromMap(data['Profile']['main']),
    );
  }
}

class UserProfile {
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String profilePicture;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.profilePicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'main': {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'address': address,
        'profilePicture': profilePicture,
      }
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      address: map['address'],
      profilePicture: map['profilePicture'],
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'Users';

  // CREATE: Add a new user to Firestore
  Future<void> createUser(User user) async {
    try {
      await _firestore.collection(_collection).doc(user.userID).set(user.toMap());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  // READ: Get a single user by ID
  Future<User?> getUser(String userID) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(userID).get();
      if (doc.exists) {
        return User.fromDocument(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user: $e';
    }
  }

  // READ: Get all users
  Stream<List<User>> getAllUsers() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
    });
  }

  // UPDATE: Update user information
  Future<void> updateUser(String userID, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collection).doc(userID).update(updates);
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  // UPDATE: Add a course to user's enrolled courses
  Future<void> enrollInCourse(String userID, String courseId) async {
    try {
      await _firestore.collection(_collection).doc(userID).update({
        'enrolledCourses': FieldValue.arrayUnion([courseId])
      });
    } catch (e) {
      throw 'Failed to enroll in course: $e';
    }
  }

  // UPDATE: Update user profile information
  Future<void> updateUserProfile(String userID, UserProfile newProfile) async {
    try {
      await _firestore.collection(_collection).doc(userID).update({
        'profile': newProfile.toMap()
      });
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  // DELETE: Remove a user
  Future<void> deleteUser(String userID) async {
    try {
      await _firestore.collection(_collection).doc(userID).delete();
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
}