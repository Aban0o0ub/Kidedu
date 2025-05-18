import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/clickable_container.dart';

class AddLessonPage extends StatefulWidget {
  const AddLessonPage({super.key});

  @override
  State<AddLessonPage> createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  String? selectedSection;
  final List<String> sections = ['Section A', 'Section B', 'Section C'];
  String? selectedAnswer;
  final List<String> Answers = ['Answer 1', 'Answer 2', 'Answer 3', 'Answer 4'];

  final TextEditingController lessonNameController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController quizQuestionController = TextEditingController();
  final TextEditingController answer1Controller = TextEditingController();
  final TextEditingController answer2Controller = TextEditingController();
  final TextEditingController answer3Controller = TextEditingController();
  final TextEditingController answer4Controller = TextEditingController();

  late final List<TextEditingController> answerControllers;

  bool showOptions1 = false;
  bool showOptions2 = false;
  bool showOptions3 = false;
  bool showOptions4 = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    answerControllers = [
      answer1Controller,
      answer2Controller,
      answer3Controller,
      answer4Controller,
    ];
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF02457A),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Upload Lesson",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                    value: selectedSection,
                    hint: const Text('Select a section'),
                    items: sections.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedSection = newValue;
                      });
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
                  const SizedBox(height: 24),
                  const Text(
                    'Attachment :-',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF02457A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClickableContainer(title: 'Photos', index: 1, isActive: showOptions1, onTap: () {
                        setState(() {
                          showOptions1 = !showOptions1;
                          showOptions2 = false;
                          showOptions3 = false;
                          showOptions4 = false;
                        });
                      }, icon: Icons.photo),
                      ClickableContainer(title: 'Text', index: 2, isActive: showOptions2, onTap: () {
                        setState(() {
                          showOptions2 = !showOptions2;
                          showOptions1 = false;
                          showOptions3 = false;
                          showOptions4 = false;
                        });
                      }, icon: Icons.text_fields),
                      ClickableContainer(title: 'Quiz', index: 3, isActive: showOptions3, onTap: () {
                        setState(() {
                          showOptions3 = !showOptions3;
                          showOptions1 = false;
                          showOptions2 = false;
                          showOptions4 = false;
                        });
                      }, icon: Icons.quiz),
                      ClickableContainer(title: 'Link', index: 4, isActive: showOptions4, onTap: () {
                        setState(() {
                          showOptions4 = !showOptions4;
                          showOptions1 = false;
                          showOptions2 = false;
                          showOptions3 = false;
                        });
                      }, icon: Icons.link),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (showOptions1) _buildOptionContent(1),
                  if (showOptions2) _buildOptionContent(2),
                  if (showOptions3) _buildOptionContent(3),
                  if (showOptions4) _buildOptionContent(4),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Upload',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionContent(int option) {
    switch (option) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Photo:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload Photo'),
            ),
            const SizedBox(height: 10),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Caption:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: captionController,
              decoration: InputDecoration(
                hintText: 'Enter caption',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: quizQuestionController,
              decoration: InputDecoration(
                hintText: 'Enter question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Text(
              'Answers :-',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            const SizedBox(height: 15),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TextField(
                  controller: answerControllers[i],
                  decoration: InputDecoration(
                    hintText: 'answer ${i + 1}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            const Text(
              'Correct Answer :-',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedAnswer,
              hint: const Text('Select an answer'),
              items: Answers.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedAnswer = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: linkController,
              decoration: InputDecoration(
                hintText: 'add link',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}


