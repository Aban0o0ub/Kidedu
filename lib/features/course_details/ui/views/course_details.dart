import 'package:flutter/material.dart';
import 'package:loginpage/features/add_course/ui/widgets/header_image.dart';
import 'package:loginpage/features/instructor_profile/ui/views/instructor_profile_page.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/info_container.dart';
import 'package:loginpage/features/instructor_profile/ui/widgets/review_card.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../../core/widgets/arrow_back.dart';
import '../widgets/pair_page.dart';
import '../widgets/section_tile.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const HeaderImage(),
                  const Positioned(
                    top: 20,
                    left: 10,
                    child: ArrowBack(),
                  ),
                  Positioned(
                    top: 40,
                    right: 10,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.monetization_on,
                            size: 24,
                            color: Color(0xFF02457A),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // الأيقونة الثانية
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.share,
                            size: 24,
                            color: Color(0xFF02457A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        "Course Name",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF02457A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const InstructorProfilePage()),
                        ).then((_) {
                          FocusScope.of(context).unfocus();
                        });
                      },
                      child: const Center(
                        child: Text(
                          "Instructor Page",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xff1877F2),
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1877F2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF02457A), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Wrap(
                        runSpacing: 16,
                        children: [
                          BuildPairPage(
                            icon1: Icons.stairs,
                            text1: "Beginners",
                            icon2: Icons.access_time,
                            text2: "10h",
                          ),
                          BuildPairPage(
                            icon1: Icons.category,
                            text1: "Mathematics",
                            icon2: Icons.location_on,
                            text2: "Online",
                          ),
                          BuildPairPage(
                            icon1: Icons.people,
                            text1: "+1000",
                            icon2: Icons.star,
                            text2: "4.5",
                          ),
                          BuildPairPage(
                            icon1: Icons.monetization_on,
                            text1: "800",
                            icon2: Icons.discount,
                            text2: "20%",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    buildInfoContainer(
                        header: "Description", text: "Description body"),
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Content",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF02457A),
                          ),
                        ),
                        Icon(Icons.add_outlined,
                            color: Color(0xFF02457A), size: 24),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return BuildSectionTile("Section title ${index + 1}");
                      },
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF02457A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 142,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildHorizontalReviewCard(
                            name: "Mirna Hanna",
                            review: "Good course for my kid !",
                            rating: 4,
                          ),
                          const SizedBox(width: 10),
                          buildHorizontalReviewCard(
                            name: "Mirna Hanna",
                            review: "excellent content.",
                            rating: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    CustomButton(
                      onPressed: () {},
                      text: "Edit course",
                      width: 384,
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
