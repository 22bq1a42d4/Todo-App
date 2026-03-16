import 'package:flutter/material.dart';
import '../models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? taskToEdit;
  const AddTaskScreen({super.key, this.taskToEdit});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = 'Low';
  String _selectedLabel = 'College';
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<String> _labels = ['College', 'Personal', 'Work', 'Other'];

  DateTime? _selectedDeadline; // 1. Variable to track the deadline

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
      _selectedPriority = widget.taskToEdit!.priority;
      _selectedLabel = widget.taskToEdit!.label;
      _selectedDeadline = widget.taskToEdit!.deadline; // Load existing deadline
    }
  }

  // Helper to format the date for the button text
  String _formatDate(DateTime date) {
    String pad(int n) => n.toString().padLeft(2, '0');
    return "${pad(date.day)}/${pad(date.month)}/${date.year} ${pad(date.hour)}:${pad(date.minute)}";
  }

  // 2. The function to open the Pickers
  Future<void> _pickDeadline() async {
    // Pick the Date first
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(), // Prevents picking past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // If date is selected, pick the Time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          _selectedDeadline ?? DateTime.now(),
        ),
      );

      if (pickedTime != null) {
        setState(() {
          // Combine Date and Time into one DateTime object
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskToEdit == null ? 'Add New Task' : 'Edit Task'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 3. The Deadline Picker Button
            OutlinedButton.icon(
              onPressed: _pickDeadline,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDeadline == null
                    ? 'Set Deadline'
                    : 'Deadline: ${_formatDate(_selectedDeadline!)}',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.centerLeft,
                foregroundColor: _selectedDeadline == null
                    ? Colors.grey.shade700
                    : Theme.of(context).primaryColor,
              ),
            ),
            if (_selectedDeadline != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _selectedDeadline = null),
                  child: const Text(
                    'Clear Deadline',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),

            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: _priorities
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedPriority = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLabel,
              decoration: const InputDecoration(
                labelText: 'Label',
                border: OutlineInputBorder(),
              ),
              items: _labels
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedLabel = val!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  Task savedTask = Task(
                    id: widget.taskToEdit?.id ?? DateTime.now().toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    priority: _selectedPriority,
                    label: _selectedLabel,
                    isCompleted: widget.taskToEdit?.isCompleted ?? false,
                    createdAt: widget.taskToEdit?.createdAt ?? DateTime.now(),
                    completedAt: widget.taskToEdit?.completedAt,
                    deadline: _selectedDeadline, // 4. Save the picked deadline
                  );
                  Navigator.pop(context, savedTask);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.taskToEdit == null ? 'Save Task' : 'Update Task',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
