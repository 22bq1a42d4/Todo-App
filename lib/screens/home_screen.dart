import 'package:flutter/material.dart';
import 'auth_screen.dart';
import '../models/task.dart';
import '../services/storage_service.dart'; // Using the new file-based storage
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  final String currentUser; // Requires the logged-in user's name

  const HomeScreen({super.key, required this.currentUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  final StorageService _storageService = StorageService();

  // Active filters
  String _filterStatus = 'All'; // 'All', 'Pending', 'Completed'
  String _filterPriority = 'All'; // 'All', 'Low', 'Medium', 'High'
  String _filterLabel = 'All'; // 'All', 'College', 'Personal', 'Work', 'Other'

  // Advanced getter for filtering
  List<Task> get filteredTasks {
    return tasks.where((task) {
      bool matchesStatus = true;
      if (_filterStatus == 'Pending') matchesStatus = !task.isCompleted;
      if (_filterStatus == 'Completed') matchesStatus = task.isCompleted;

      bool matchesPriority = true;
      if (_filterPriority != 'All')
        matchesPriority = task.priority == _filterPriority;

      bool matchesLabel = true;
      if (_filterLabel != 'All') matchesLabel = task.label == _filterLabel;

      return matchesStatus && matchesPriority && matchesLabel;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // LOAD tasks using StorageService
  Future<void> _loadTasks() async {
    final loadedTasks = await _storageService.loadTasksForUser(
      widget.currentUser,
    );
    setState(() {
      tasks = loadedTasks;
    });
  }

  // SAVE tasks using StorageService
  Future<void> _saveTasks() async {
    await _storageService.saveTasksForUser(widget.currentUser, tasks);
  }

  // Helper method to get color based on priority
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.amber.shade700;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Helper to format DateTimes
  String _formatDate(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return "${pad(date.day)}/${pad(date.month)}/${date.year} ${pad(date.hour)}:${pad(date.minute)}";
  }

  // The professional Filter UI BottomSheet
  void _showFilterSheet() {
    String tempStatus = _filterStatus;
    String tempPriority = _filterPriority;
    String tempLabel = _filterLabel;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Tasks',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 32),

                  const Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Pending', 'Completed'].map((s) {
                      return ChoiceChip(
                        label: Text(s),
                        selected: tempStatus == s,
                        onSelected: (selected) =>
                            setModalState(() => tempStatus = s),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Priority',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Low', 'Medium', 'High'].map((p) {
                      return ChoiceChip(
                        label: Text(p),
                        selected: tempPriority == p,
                        onSelected: (selected) =>
                            setModalState(() => tempPriority = p),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Label',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'College', 'Personal', 'Work', 'Other']
                        .map((l) {
                          return ChoiceChip(
                            label: Text(l),
                            selected: tempLabel == l,
                            onSelected: (selected) =>
                                setModalState(() => tempLabel = l),
                          );
                        })
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filterStatus = 'All';
                              _filterPriority = 'All';
                              _filterLabel = 'All';
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _filterStatus = tempStatus;
                              _filterPriority = tempPriority;
                              _filterLabel = tempLabel;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentUser}'s Tasks"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Advanced Filters',
                onPressed: _showFilterSheet,
              ),
              if (_filterStatus != 'All' ||
                  _filterPriority != 'All' ||
                  _filterLabel != 'All')
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),

      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet! Tap + to add one.'))
          : filteredTasks.isEmpty
          ? const Center(child: Text('No tasks match your filters.'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 80, top: 16),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];

                // --- NEW LOGIC: Check if it was completed late ---
                bool isCompletedLate = false;
                if (task.isCompleted &&
                    task.completedAt != null &&
                    task.deadline != null) {
                  // isAfter() compares the two DateTime objects perfectly
                  isCompletedLate = task.completedAt!.isAfter(task.deadline!);
                }

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  elevation: task.isCompleted ? 0 : 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      // 1. Dynamic Background: Red if late, Grey if on-time, White if pending
                      color: task.isCompleted
                          ? (isCompletedLate
                                ? Colors.red.shade50
                                : Colors.grey.shade100)
                          : Colors.white,
                      border: Border.all(
                        // 2. Dynamic Border: Red if late, Grey if on time, Priority color if pending
                        color: task.isCompleted
                            ? (isCompletedLate
                                  ? Colors.red.shade300
                                  : Colors.grey.shade300)
                            : _getPriorityColor(task.priority).withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                activeColor: _getPriorityColor(task.priority),
                                value: task.isCompleted,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    task.isCompleted = newValue!;
                                    task.completedAt = task.isCompleted
                                        ? DateTime.now()
                                        : null;
                                  });
                                  _saveTasks();
                                },
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Main Content (Title, Desc, Tags)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      // 3. Dynamic Title Color: Deep red if late, Grey if on time
                                      color: task.isCompleted
                                          ? (isCompletedLate
                                                ? Colors.red.shade400
                                                : Colors.grey.shade500)
                                          : Colors.black87,
                                    ),
                                  ),
                                  if (task.description.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      task.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: task.isCompleted
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),

                                  // Tags
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          task.label,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(
                                            task.priority,
                                          ).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          task.priority,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: _getPriorityColor(
                                              task.priority,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Edit & Delete Buttons
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.blueGrey,
                                  ),
                                  onPressed: () async {
                                    final Task? updatedTask =
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddTaskScreen(taskToEdit: task),
                                          ),
                                        );
                                    if (updatedTask != null) {
                                      setState(() {
                                        int mainIndex = tasks.indexWhere(
                                          (t) => t.id == updatedTask.id,
                                        );
                                        if (mainIndex != -1)
                                          tasks[mainIndex] = updatedTask;
                                      });
                                      _saveTasks();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      tasks.removeWhere((t) => t.id == task.id);
                                    });
                                    _saveTasks();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Timestamps & Deadline
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (task.deadline != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      size: 14,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Due: ${_formatDate(task.deadline!)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Created: ${_formatDate(task.createdAt)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                if (task.completedAt != null)
                                  Row(
                                    children: [
                                      // 4. Dynamic Done Status: Red error icon if late, Green check if on time
                                      Icon(
                                        isCompletedLate
                                            ? Icons.error_outline
                                            : Icons.check_circle_outline,
                                        size: 14,
                                        color: isCompletedLate
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Done: ${_formatDate(task.completedAt!)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isCompletedLate
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: isCompletedLate
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
            });
            _saveTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
