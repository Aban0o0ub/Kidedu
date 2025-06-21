import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../data/models/Course_Model.dart';
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
  final List<String> availabilityitems = ['Online', 'Offline'];
  final List<String> offeritems = ['10%', '20%', '30%', '50%'];
  final List<String> categoryitems = [
    'Sports',
    'Arts',
    'Education',
    'Skills',
    'Games'
  ];
  final List<String> ageitems =
      List.generate(15, (index) => (index + 1).toString());

  List<String> selectedAges = [];
  AddCourseCubit addCourseCubit = getIt<AddCourseCubit>();
  @override
  void initState() {
    super.initState();
    availabilitycontroller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addCourseCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        label: 'Level:',
                        hintText: 'Select level',
                        controller: levelcontroller,
                        items: courseitems,
                        width: double.infinity,
                        isRequired: false,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdownField(
                              label: "Availability:",
                              hintText: 'Select',
                              controller: availabilitycontroller,
                              items: availabilityitems,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Age:',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF02457A),
                                  ),
                                ),
                                MultiSelectDialogField(
                                  items: ageitems
                                      .map((e) => MultiSelectItem<String>(e, e))
                                      .toList(),
                                  title: const Text("Select Ages"),
                                  selectedColor: const Color(0xFF02457A),
                                  buttonText: const Text("Select age(s)"),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF02457A),
                                      width: 1.5,
                                    ),
                                  ),
                                  onConfirm: (results) {
                                    setState(() {
                                      selectedAges = results.cast<String>();
                                    });
                                  },
                                  chipDisplay: MultiSelectChipDisplay(
                                    onTap: (value) {
                                      setState(() {
                                        selectedAges.remove(value);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                              label: 'Offer:',
                              hintText: 'Enter percent',
                              controller: offercontroller,
                              keyboardType: TextInputType.number,
                              isRequired: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: CustomDropdownField(
                              label: 'Till:',
                              hintText: 'Select',
                              controller: tillcontroller,
                              items: offeritems,
                              width: double.infinity,
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
                              hintText: 'Pick a date',
                              controller: startcontroller,
                              readOnly: true,
                              suffixIcon: const Icon(Icons.date_range_outlined),
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  startcontroller.text =
                                      picked.toIso8601String().split('T').first;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              label: 'End date',
                              hintText: 'Pick a date',
                              controller: endcontroller,
                              readOnly: true,
                              suffixIcon: const Icon(Icons.date_range_outlined),
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  endcontroller.text =
                                      picked.toIso8601String().split('T').first;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      BlocListener<AddCourseCubit, AddCourseState>(
                        listener: (context, state) {},
                        child: Align(
                          alignment: Alignment.center,
                          child: availabilitycontroller.text == "Offline"
                              ? CustomButton(
                                  onPressed: () {
                                    final price =
                                        num.tryParse(pricecontroller.text) ?? 0;
                                    final startDate =
                                        DateTime.tryParse(startcontroller.text);
                                    final endDate =
                                        DateTime.tryParse(endcontroller.text);
                                    final offer =
                                        num.tryParse(offercontroller.text) ?? 0;

                                    context
                                        .read<AddCourseCubit>()
                                        .emitAddCourse(
                                          goToLessons: false,
                                          context,
                                          CourseRequest(
                                            courseName:
                                                addcourseController.text,
                                            level: levelcontroller.text,
                                            availability:
                                                availabilitycontroller.text,
                                            category: categorycontroller.text,
                                            description:
                                                descriptioncontroller.text,
                                            price: price,
                                            offer: offer,
                                            firstSection:
                                                sectioncontroller.text,
                                            startDate: startDate,
                                            endDate: endDate,
                                          ),
                                        );
                                  },
                                  text: "Save",
                                  width: 320,
                                )
                              : CustomButton(
                                  onPressed: () {
                                    final price =
                                        num.tryParse(pricecontroller.text) ?? 0;
                                    final offer =
                                        num.tryParse(offercontroller.text) ?? 0;
                                    final startDate =
                                        DateTime.tryParse(startcontroller.text);
                                    final endDate =
                                        DateTime.tryParse(endcontroller.text);

                                    context
                                        .read<AddCourseCubit>()
                                        .emitAddCourse(
                                          goToLessons: true,
                                          context,
                                          CourseRequest(
                                            courseName:
                                                addcourseController.text,
                                            level: levelcontroller.text,
                                            availability:
                                                availabilitycontroller.text,
                                            category: categorycontroller.text,
                                            description:
                                                descriptioncontroller.text,
                                            price: price,
                                            offer: offer,
                                            firstSection:
                                                sectioncontroller.text,
                                            startDate: startDate,
                                            endDate: endDate,
                                          ),
                                        );
                                  },
                                  text: "Save and Continue",
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
