import 'package:elearning/db_operations/courses.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screen to display list of tasks for a course
class TaskListScreen extends StatefulWidget {
  final String courseId;
  final List<Task> tasks;

  const TaskListScreen({
    required this.courseId,
    required this.tasks,
    super.key,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final CourseRepository _repository = CourseRepository();
  bool _isLoading = false;

  // Refresh tasks list after modifications
  Future<void> _refreshTasks() async {
    setState(() => _isLoading = true);
    try {
      final updatedCourse = await _repository.getCourseWithTasks(widget.courseId);
      if (mounted && updatedCourse != null) {
        setState(() {
          widget.tasks.clear();
          widget.tasks.addAll(updatedCourse.tasks);
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Tasks'),
        backgroundColor: Colors.deepOrange,
        actions: [
          // Add sort/filter options if needed
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Implement sorting logic
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  // Allow deleting tasks by swiping
                  onDismissed: (direction) async {
                    try {
                      await _repository.deleteTask(widget.courseId, task.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${task.title} deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () async {
                              // Implement undo logic
                              await _refreshTasks();
                            },
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete task: $e')),
                      );
                      await _refreshTasks();
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(task.title),
                    subtitle: Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      final wasModified = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(
                            courseId: widget.courseId,
                            task: task,
                          ),
                        ),
                      );
                      
                      if (wasModified == true) {
                        await _refreshTasks();
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final wasAdded = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(courseId: widget.courseId),
            ),
          );
          
          if (wasAdded == true) {
            await _refreshTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Screen to add a new task
class AddTaskScreen extends StatefulWidget {
  final String courseId;

  const AddTaskScreen({
    required this.courseId,
    super.key,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isSubmitting = true);
                        try {
                          final repository = CourseRepository();
                          final newTask = Task(
                            id: '', // ID will be assigned by Firestore
                            title: _titleController.text,
                            description: _descriptionController.text, number: 0, duration: '', video: '',
                          );
                          
                          await repository.addTaskToCourse(
                            widget.courseId,
                            newTask,
                          );
                          
                          Navigator.pop(context, true);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add task: $e'),
                            ),
                          );
                          setState(() => _isSubmitting = false);
                        }
                      }
                    },
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen to view and edit task details
class TaskDetailScreen extends StatefulWidget {
  final String courseId;
  final Task task;

  const TaskDetailScreen({
    required this.courseId,
    required this.task,
    super.key,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final repository = CourseRepository();
      final updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text, number: 0, duration: '', video: '',
      );
      
      await repository.updateTask(widget.courseId, updatedTask);
      
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Task Details'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isSaving
                ? null
                : () {
                    if (_isEditing) {
                      _saveChanges();
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              enabled: _isEditing,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}