import 'package:flutter/material.dart';
import '../../data/models/section.dart';

class SectionInput extends StatelessWidget {
  final String? selectedSection;
  final List<SectionModel> sections;
  final ValueChanged<String?> onSectionChanged;
  final TextEditingController lessonNameController;
  final Function(String)? onAddNewSection;

  const SectionInput({
    super.key,
    required this.selectedSection,
    required this.sections,
    required this.onSectionChanged,
    required this.lessonNameController,
    this.onAddNewSection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add to section:-',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: sections.any((section) => section.id == selectedSection)
              ? selectedSection
              : null,
          //value: selectedSection,
          hint: const Text('Select a section'),
          items: [
            ...sections.map((SectionModel section) {
              return DropdownMenuItem<String>(
                value: section.id,
                child: Text(section.title),
              );
            }).toList(),
            const DropdownMenuItem<String>(
              value: 'Add new section',
              child: Text(
                'Add new section',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
          onChanged: (String? value) {
            if (value == 'Add new section') {
              _showAddSectionDialog(context);
            } else {
              onSectionChanged(value);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Lesson Name :-',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: lessonNameController,
          decoration: InputDecoration(
            hintText: 'Enter lesson name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddSectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newSectionTitle = '';
        return AlertDialog(
          title: const Text('Add New Section'),
          content: TextField(
            onChanged: (value) {
              newSectionTitle = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter section title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newSectionTitle.isNotEmpty && onAddNewSection != null) {
                  Navigator.of(context).pop();
                  onAddNewSection!(newSectionTitle);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
