import 'package:cloud_firestore/cloud_firestore.dart';

// Data models for courses and tasks
class Course {
  final String id;
  final String title;
  final String logo;
  final List<Task> tasks;

  Course({
    required this.id,
    required this.title,
    required this.logo,
    required this.tasks,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'logo': logo,
      // We don't include tasks here as they'll be in a subcollection
    };
  }

  // Create from Firestore document
  factory Course.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Course(
      id: snapshot.id,
      title: data['title'],
      logo: data['logo'],
      tasks: [], // Tasks are loaded separately from subcollection
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final int number;
  final String duration;
  final String video;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.number,
    required this.duration,
    required this.video,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory Task.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return Task(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      number: data['number'],
      duration: data['duration'],
      video: data['video'],
    );
  }
}

// Repository to handle Firestore operations
class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to the courses collection
  CollectionReference<Map<String, dynamic>> get _coursesRef =>
      _firestore.collection('Courses');

  // Get tasks subcollection reference for a specific course
  CollectionReference<Map<String, dynamic>> _tasksRef(String courseId) =>
      _coursesRef.doc(courseId).collection('tasks');

  // CREATE operations
  Future<String> createCourse(Course course) async {
    try {
      // Create the course document
      final docRef = await _coursesRef.add(course.toFirestore());
      
      // Create tasks in the subcollection
      for (var task in course.tasks) {
        await _tasksRef(docRef.id)
            .add(task.toFirestore());
      }
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  Future<String> addTaskToCourse(String courseId, Task task) async {
    try {
      final docRef = await _tasksRef(courseId).add(task.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // READ operations
  Stream<List<Course>> getAllCourses() {
    return _coursesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Course.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>, null))
          .toList();
    });
  }

  Future<Course?> getCourseWithTasks(String courseId) async {
    try {
      final courseDoc = await _coursesRef.doc(courseId).get();
      if (!courseDoc.exists) return null;

      final course = Course.fromFirestore(
          // ignore: unnecessary_cast
          courseDoc as DocumentSnapshot<Map<String, dynamic>>, null);

      // Get tasks from subcollection
      final tasksSnapshot = await _tasksRef(courseId).get();
      final tasks = tasksSnapshot.docs
          .map((doc) => Task.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>, null))
          .toList();

      return Course(
        id: course.id,
        title: course.title,
        logo: course.logo,
        tasks: tasks,
      );
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }

  // UPDATE operations
  Future<void> updateCourse(Course course) async {
    try {
      await _coursesRef.doc(course.id).update(course.toFirestore());
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  Future<void> updateTask(String courseId, Task task) async {
    try {
      await _tasksRef(courseId).doc(task.id).update(task.toFirestore());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // DELETE operations
  Future<void> deleteCourse(String courseId) async {
    try {
      // Delete all tasks in the subcollection first
      final tasksSnapshot = await _tasksRef(courseId).get();
      for (var doc in tasksSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Then delete the course document
      await _coursesRef.doc(courseId).delete();
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }

  Future<void> deleteTask(String courseId, String taskId) async {
    try {
      await _tasksRef(courseId).doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}