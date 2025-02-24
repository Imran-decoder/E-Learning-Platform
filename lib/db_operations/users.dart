import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class to represent our user data structure
class User {
  final String userID;
  final String userName;
  final UserProfile Profile;
  final bool isAdmin;

  User({
    required this.userID,
    required this.userName,
    required this.Profile,
    required this.isAdmin, required bool isSuperAdmin,
  });

  // Convert User object to a map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'Profile': Profile.toMap(),  // renamed key to lowercase for consistency
      'isAdmin': isAdmin,
    };
  }

  // Create a User object from a Firestore document.
  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      userID: data['userID'],
      userName: data['userName'],
      Profile: UserProfile.fromMap(data['Profile']['main']),
      isAdmin: data['isAdmin'],
      isSuperAdmin: data['isSuperAdmin'],
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

  /// CREATE: Add a new user to Firestore.
  Future<void> createUser(User user) async {
    try {
      await _firestore.collection(_collection).doc(user.userID).set(user.toMap());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  /// READ: Get a single user by ID.
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

  /// READ: Get all users.
  Stream<List<User>> getAllUsers() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromDocument(doc)).toList();
    });
  }

  /// UPDATE: Update user information.
  Future<void> updateUser(String userID, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collection).doc(userID).update(updates);
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  /// The document stores a "tasks" map where each key is a task identifier and the value is a bool.
  Future<void> enrollInCourse(String userID, String courseId, {Map<String, bool>? tasks}) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(userID)
          .collection('enrolledCourses')
          .doc(courseId)
          .set({
        'tasks': tasks ?? {}, // Initialize with an empty map if no tasks provided.
      });
    } catch (e) {
      throw 'Failed to enroll in course: $e';
    }
  }

  /// UPDATE: Update the completion status of a specific task for a course.
  Future<void> updateTaskStatus({
    required String userID,
    required String courseId,
    required String taskId,
    required bool isCompleted,
  }) async {
    try {
      // Update the specific task's value in the "tasks" map.
      await _firestore
          .collection(_collection)
          .doc(userID)
          .collection('enrolledCourses')
          .doc(courseId)
          .update({
        'tasks.$taskId': isCompleted,
      });
    } catch (e) {
      throw 'Failed to update task status: $e';
    }
  }

  /// DELETE: Remove a user.
  Future<void> deleteUser(String userID) async {
    try {
      // Optionally, you might want to delete the subcollections as well.
      await _firestore.collection(_collection).doc(userID).delete();
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
}
