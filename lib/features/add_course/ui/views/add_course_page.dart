import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/core/routing/routes.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../data/models/Course_Model.dart';
import '../../logic/cubit/add_course_cubit.dart';
import '../widgets/header_image.dart';

class AddCoursePage extends StatefulWidget {
  final CourseData? courseToEdit;
  const AddCoursePage({super.key, this.courseToEdit});

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

  @override
  void initState() {
    super.initState();
    if (widget.courseToEdit != null) {
      final course = widget.courseToEdit!;
      addcourseController.text = course.courseName ?? '';
      levelcontroller.text = course.level ?? '';
      pricecontroller.text = course.price?.toString() ?? '';
      availabilitycontroller.text = course.availability ?? '';
      offercontroller.text = course.offer?.toString() ?? '';
      categorycontroller.text = course.category ?? '';
      descriptioncontroller.text = course.description ?? '';
      startcontroller.text =
          course.startDate?.toIso8601String().split('T').first ?? '';
      endcontroller.text =
          course.endDate?.toIso8601String().split('T').first ?? '';
      selectedAges =
          course.suitableAges?.map((e) => e.toString()).toList() ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddCourseCubit>(),
      child: BlocConsumer<AddCourseCubit, AddCourseState>(
        listener: (context, state) {
          if (state is AddCourseSuccess) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.white,
                title: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Success'),
                  ],
                ),
                content: Text(widget.courseToEdit != null
                    ? 'Course updated successfully!'
                    : 'Course created successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(Routes.instructorProfilePage);
                    },
                    child:
                        const Text('OK', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            );
          } else if (state is AddCourseFailure) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.white,
                title: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Error', style: TextStyle(color: Colors.red)),
                  ],
                ),
                content: const Text(
                  'Something went wrong while updating the course.',
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
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
                          ),
                          const SizedBox(height: 15),
                          CustomDropdownField(
                            label: 'Level:',
                            hintText: 'Select level',
                            controller: levelcontroller,
                            items: courseitems,
                            width: double.infinity,
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
                                          .map((e) =>
                                              MultiSelectItem<String>(e, e))
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
                            hintText: 'Tell us about your course ...',
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
                                  suffixIcon:
                                      const Icon(Icons.date_range_outlined),
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      startcontroller.text = picked
                                          .toIso8601String()
                                          .split('T')
                                          .first;
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
                                  suffixIcon:
                                      const Icon(Icons.date_range_outlined),
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      endcontroller.text = picked
                                          .toIso8601String()
                                          .split('T')
                                          .first;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Align(
                            alignment: Alignment.center,
                            child: CustomButton(
                              onPressed: () {
                                final price =
                                    num.tryParse(pricecontroller.text) ?? 0;
                                final offer =
                                    num.tryParse(offercontroller.text) ?? 0;
                                final startDate =
                                    DateTime.tryParse(startcontroller.text);
                                final endDate =
                                    DateTime.tryParse(endcontroller.text);
                                final suitableAgesParsed = selectedAges
                                    .map((e) => int.tryParse(e) ?? 0)
                                    .toList();

                                final courseRequest = CourseRequest(
                                  courseName: addcourseController.text,
                                  level: levelcontroller.text,
                                  availability: availabilitycontroller.text,
                                  category: categorycontroller.text,
                                  description: descriptioncontroller.text,
                                  price: price,
                                  offer: offer,
                                  startDate: startDate,
                                  endDate: endDate,
                                  suitableAges: suitableAgesParsed,
                                );

                                final cubit =
                                    BlocProvider.of<AddCourseCubit>(context);
                                if (widget.courseToEdit != null) {
                                  cubit.emitUpdateCourse(
                                    context,
                                    widget.courseToEdit!.id!,
                                    courseRequest.toJson()
                                      ..removeWhere((k, v) => v == null),
                                  );
                                } else {
                                  cubit.emitAddCourse(context, courseRequest);
                                }
                              },
                              text: widget.courseToEdit != null
                                  ? "Save Changes"
                                  : "Save and Continue",
                              width: 320,
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
          );
        },
      ),
    );
  }
}
