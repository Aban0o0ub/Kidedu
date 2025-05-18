import 'package:flutter/material.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import '../widgets/caption.dart';
import '../widgets/links.dart';
import '../widgets/my_button.dart';
import '../widgets/quiz.dart';
import '../widgets/video_screen.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  int selectedIndex = 0; // 0: Caption, 1: Quiz, 2: Links
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ArrowBack(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 63.0, left: 104),
                child: Row(
                  children: [
                    ImageIcon(
                      AssetImage("assets/images/Group 583.png"),
                      color: Color(0xff02457A),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Lesson: Fractions",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff02457A),
                        )),
                  ],
                ),
              ),
              VideoLesson(
                videoLink:
                    "https://www.youtube.com/watch?v=pSc6RGEBLAQ&list=PLknwEmKsW8OvMsFbU9zo8oJCprAsgc4LO",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    imagePath: "assets/images/Group 582.png",
                    text: "Caption",
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  MyButton(
                    imagePath: "assets/images/quiz.jpg",
                    text: "Quiz",
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                  MyButton(
                    imagePath: "assets/images/Group 580.png",
                    text: "Links",
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                  ),
                ],
              ),
              Expanded(child: _buildSelectedContent()),
            ],
          ),
        ],
      ),
    );
  }

  List<String> captions = [
    "In today’s lesson, we are focusing on fractions understanding what they are, how to compare them, and how to add and subtract them with like denominators.",
    "We will begin by identifying the parts of a fraction: the numerator and the denominator.",
    "Next, we will use visual models such as number lines and shapes to represent fractions and understand their values.",
    "Students will then practice comparing fractions and performing basic operations like addition and subtraction with the same denominators.",
    "By the end of the lesson, students will be able to recognize, compare, and solve problems involving basic fractions with confidence.",
  ];
  Widget _buildSelectedContent() {
    switch (selectedIndex) {
      case 0:
        return CaptionView(
          captions: captions,
        );
      case 1:
        return const QuizView();
      case 2:
        return const LinksView();
      default:
        return const SizedBox.shrink();
    }
  }
}
