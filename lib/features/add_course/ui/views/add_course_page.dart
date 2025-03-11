import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../data/models/add_course.dart';
import '../../logic/cubit/add_course_cubit.dart';
import '../widgets/header_image.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final TextEditingController addcourseController = TextEditingController();
  final TextEditingController levelcontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController availabilitycontroller = TextEditingController();
  final TextEditingController offercontroller = TextEditingController();
  final TextEditingController tillcontroller = TextEditingController();
  final TextEditingController categorycontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  final TextEditingController startcontroller = TextEditingController();
  final TextEditingController endcontroller = TextEditingController();
  final TextEditingController sectioncontroller = TextEditingController();
  final List<String> courseitems = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> availabilityitems = ['Online', 'Offline', 'Both'];
  final List<String> offeritems = ['10%', '20%', '30%', '50%'];
  final List<String> categoryitems = [
    'Sports',
    'Arts',
    'Education',
    'Skills',
    'Games'
  ];
  AddCourseCubit addCourseCubit = getIt<AddCourseCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addCourseCubit,
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderImage(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: addcourseController,
                        label: 'Course Name:-',
                        hintText: 'Add course name',
                        keyboardType: TextInputType.name,
                        contentPadding: const EdgeInsets.only(left: 20),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter course name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomDropdownField(
                        label: 'Level:-  (optional)',
                        hintText: 'Select level',
                        controller: levelcontroller,
                        items: courseitems,
                        //icon: Icons.school_outlined,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 15),
                      CustomDropdownField(
                        label: "Availability:-",
                        hintText: 'Select',
                        controller: availabilitycontroller,
                        items: availabilityitems,
                        //icon: Icons.event_available_outlined,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        label: 'Price:-',
                        hintText: 'Enter price',
                        controller: pricecontroller,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              label: 'Offer:- (optional)',
                              hintText: 'Enter percent',
                              controller: offercontroller,
                              keyboardType: TextInputType.number,
                              //icon: Icons.percent_outlined,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Till",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF02457A),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomDropdownField(
                                    label: '',
                                    hintText: '',
                                    controller: tillcontroller,
                                    items: offeritems,
                                    //icon: Icons.discount_outlined,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      CustomDropdownField(
                        label: 'Category',
                        hintText: 'select category',
                        controller: categorycontroller,
                        items: categoryitems,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        label: 'Description:-',
                        hintText: 'Till us about your course ...',
                        controller: descriptioncontroller,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Schedule:-",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF02457A),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              label: 'Start date',
                              hintText: '',
                              controller: startcontroller,
                              keyboardType: TextInputType.number,
                              suffixIcon: const Icon(Icons.date_range_outlined),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              label: 'End date',
                              hintText: '',
                              controller: endcontroller,
                              suffixIcon: const Icon(Icons.date_range_outlined),
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Visibility(
                        visible: availabilitycontroller.text == 'Online' ||
                            availabilitycontroller.text == 'Both',
                        child: CustomTextField(
                          label: "Section Name:-",
                          hintText: 'Add Section Name',
                          controller: sectioncontroller,
                        ),
                      ),
                      const SizedBox(height: 25),
                     BlocListener<AddCourseCubit, AddCourseState>(
  listener: (context, state) {
    print("Current state: $state");
  },
  child: Align(
    alignment: Alignment.center,
    child: CustomButton(
      onPressed: () {
        final price = num.tryParse(pricecontroller.text) ?? 0;
        final startDate = DateTime.tryParse(startcontroller.text);
        final endDate = DateTime.tryParse(endcontroller.text);

        context.read<AddCourseCubit>().emitAddCourse(
              context, // ✅ تمرير `context` إلى `emitAddCourse`
              CourseRequest(
                courseName: addcourseController.text,
                level: levelcontroller.text,
                availability: availabilitycontroller.text,
                category: categorycontroller.text,
                description: descriptioncontroller.text,
                price: price,
                offer: offercontroller.text,
                firstSection: sectioncontroller.text,
                startDate: startDate,
                endDate: endDate,
              ),
            );
      },
      text: "Save",
      width: 320,
    ),
  ),
),


                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
