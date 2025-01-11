import 'package:cloud_firestore/cloud_firestore.dart';

// Model class to represent our user data structure
class User {
  final String userId;
  final String username;
  final List<String> enrolledCourses;
  final UserProfile profile;

  User({
    required this.userId,
    required this.username,
    required this.enrolledCourses,
    required this.profile,
  });

  // Convert User object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'enrolledCourses': enrolledCourses,
      'profile': profile.toMap(),
    };
  }

  // Create User object from Firestore document
  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      userId: data['userId'],
      username: data['username'],
      enrolledCourses: List<String>.from(data['enrolledCourses']),
      profile: UserProfile.fromMap(data['profile']['main']),
    );
  }
}

class UserProfile {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String profilePic;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'main': {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'address': address,
        'profilePic': profilePic,
      }
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      profilePic: map['profilePic'],
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // CREATE: Add a new user to Firestore
  Future<void> createUser(User user) async {
    try {
      await _firestore.collection(_collection).doc(user.userId).set(user.toMap());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  // READ: Get a single user by ID
  Future<User?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(userId).get();
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
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collection).doc(userId).update(updates);
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  // UPDATE: Add a course to user's enrolled courses
  Future<void> enrollInCourse(String userId, String courseId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'enrolledCourses': FieldValue.arrayUnion([courseId])
      });
    } catch (e) {
      throw 'Failed to enroll in course: $e';
    }
  }

  // UPDATE: Update user profile information
  Future<void> updateUserProfile(String userId, UserProfile newProfile) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'profile': newProfile.toMap()
      });
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  // DELETE: Remove a user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
}