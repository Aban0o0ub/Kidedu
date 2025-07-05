import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/core/routing/routes.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../../kid_profile/ui/widgets/notification_helper.dart';
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

  List<File> _selectedImages = [];
  List<String>? _editingCourseImages;

  final List<String> courseitems = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> availabilityitems = ['Online', 'Offline'];
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
      
      // Set existing course images for editing
      _editingCourseImages = course.courseImages;
    }
  }

  String _getButtonText() {
    if (availabilitycontroller.text.toLowerCase() == 'online') {
      return "Save and Continue";
    } else if (availabilitycontroller.text.toLowerCase() == 'offline') {
      return "Save";
    } else {
      return "Save and Continue"; // Default text
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddCourseCubit>(),
      child: BlocConsumer<AddCourseCubit, AddCourseState>(
        listener: (context, state) {
          if (state is AddCourseSuccess) {
            NotificationHelper.showCourseAddedNotification();
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
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    //  ArrowBack(),
                      HeaderImage(
                        onImagesSelected: (images) {
                          setState(() {
                            _selectedImages = images;
                          });
                        },
                        initialImages: _editingCourseImages,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            CustomTextField(
                              controller: addcourseController,
                              label: 'Course Name:',
                              hintText: 'Add course name',
                              keyboardType: TextInputType.name,
                              width: double.infinity,
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
                            CustomDropdownField(
                              label: "Availability:",
                              hintText: 'Select',
                              controller: availabilitycontroller,
                              items: availabilityitems,
                              width: double.infinity,
                              onChanged: (value) {
                                setState(() {
                                  availabilitycontroller.text = value ?? '';
                                  // Clear date fields when switching to online
                                  if (value?.toLowerCase() == 'online') {
                                    startcontroller.clear();
                                    endcontroller.clear();
                                    tillcontroller.clear();
                                    // Show helpful message about removing location info
                                    if (descriptioncontroller.text.toLowerCase().contains('location') ||
                                        descriptioncontroller.text.toLowerCase().contains('موقع') ||
                                        descriptioncontroller.text.toLowerCase().contains('مكان') ||
                                        descriptioncontroller.text.toLowerCase().contains('عنوان')) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please note: You may want to remove location information from description for online courses'),
                                          backgroundColor: Colors.blue,
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    text: 'Age:',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF02457A),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                MultiSelectDialogField(
                                  items: ageitems
                                      .map((e) =>
                                          MultiSelectItem<String>(e, e))
                                      .toList(),
                                  title: const Text("Select Ages"),
                                  selectedColor: const Color(0xFF02457A),
                                  buttonText: const Text(
                                    "Select age(s)",
                                    style: TextStyle(
                                      color: Color(0xFF9D9D9D),
                                      fontSize: 16,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF02457A),
                                      width: 1.0,
                                    ),
                                  ),
                                  buttonIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF02457A),
                                  ),
                                  dialogHeight: 300,
                                  dialogWidth: 300,
                                  onConfirm: (results) {
                                    setState(() {
                                      selectedAges = results.cast<String>();
                                    });
                                    // Force a rebuild to ensure proper layout
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    });
                                  },
                                  chipDisplay: MultiSelectChipDisplay(
                                    onTap: (value) {
                                      setState(() {
                                        selectedAges.remove(value);
                                      });
                                    },
                                    chipColor: const Color(0xFF02457A).withOpacity(0.1),
                                    textStyle: const TextStyle(
                                      color: Color(0xFF02457A),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              label: 'Price:',
                              hintText: 'Enter price',
                              controller: pricecontroller,
                              keyboardType: TextInputType.number,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CustomTextField(
                                    label: 'Offer:',
                                    hintText: 'Enter percent',
                                    controller: offercontroller,
                                    keyboardType: TextInputType.number,
                                    isRequired: false,
                                    width: double.infinity,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 1,
                                  child: CustomTextField(
                                    label: 'Till:',
                                    hintText: 'Pick a date',
                                    controller: tillcontroller,
                                    readOnly: true,
                                    width: double.infinity,
                                    isRequired: false,
                                    suffixIcon: const Icon(Icons.date_range_outlined),
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != null) {
                                        tillcontroller.text = picked
                                            .toIso8601String()
                                            .split('T')
                                            .first;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            CustomDropdownField(
                              label: 'Category:',
                              hintText: 'select category',
                              controller: categorycontroller,
                              items: categoryitems,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Show location instruction for offline courses
                                if (availabilitycontroller.text.toLowerCase() == 'offline') ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF02457A).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFF02457A).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: const Color(0xFF02457A),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            "For offline courses: Please add the course location with the description",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: const Color(0xFF02457A),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                                
                                CustomTextField(
                                  label: availabilitycontroller.text.toLowerCase() == 'offline' 
                                      ? 'Description & Location:' 
                                      : 'Description:',
                                  hintText: availabilitycontroller.text.toLowerCase() == 'offline'
                                      ? 'Add the course location with description'
                                      : 'Add course description...',
                                  controller: descriptioncontroller,
                                  width: double.infinity,
                                  maxLines: availabilitycontroller.text.toLowerCase() == 'offline' ? 6 : 4,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            
                            // Only show Schedule section for Offline courses
                            if (availabilitycontroller.text.toLowerCase() == 'offline') ...[
                              RichText(
                                text: const TextSpan(
                                  text: "Schedule:",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF02457A),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CustomTextField(
                                      label: 'Start date',
                                      hintText: 'Pick a date',
                                      controller: startcontroller,
                                      readOnly: true,
                                      width: double.infinity,
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
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: 1,
                                    child: CustomTextField(
                                      label: 'End date',
                                      hintText: 'Pick a date',
                                      controller: endcontroller,
                                      readOnly: true,
                                      width: double.infinity,
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
                              const SizedBox(height: 15),
                            ],
                            
                            // Add more spacing before the button to prevent overflow
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: CustomButton(
                                onPressed: () {
                                  // Validate that ages are selected
                                  if (selectedAges.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please select at least one age'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  
                                  // Validate description is not empty
                                  if (descriptioncontroller.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          availabilitycontroller.text.toLowerCase() == 'offline'
                                              ? 'Please add course description and location'
                                              : 'Please add course description'
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  
                                  // Additional validation for offline courses to ensure location is mentioned
                                  if (availabilitycontroller.text.toLowerCase() == 'offline') {
                                    String description = descriptioncontroller.text.toLowerCase();
                                    bool hasLocationKeywords = description.contains('location') || 
                                                               description.contains('موقع') ||
                                                               description.contains('مكان') ||
                                                               description.contains('عنوان') ||
                                                               description.contains('address') ||
                                                               description.contains('cairo') ||
                                                               description.contains('القاهرة') ||
                                                               description.contains('alexandria') ||
                                                               description.contains('الاسكندرية') ||
                                                               description.contains('street') ||
                                                               description.contains('شارع');
                                    
                                    if (!hasLocationKeywords) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please make sure to include the location information in the description for offline courses'),
                                          backgroundColor: Colors.orange,
                                          duration: Duration(seconds: 4),
                                        ),
                                      );
                                      return;
                                    }
                                  }
                                  
                                  final price =
                                      num.tryParse(pricecontroller.text) ?? 0;
                                  final offer =
                                      num.tryParse(offercontroller.text) ?? 0;
                                  final startDate =
                                      DateTime.tryParse(startcontroller.text);
                                  final endDate =
                                      DateTime.tryParse(endcontroller.text);
                                  final tillDate =
                                      DateTime.tryParse(tillcontroller.text);
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
                                    tillDate: tillDate,
                                    suitableAges: suitableAgesParsed,
                                    courseImages: _selectedImages.isNotEmpty 
                                        ? _selectedImages.map((file) => file.path).toList()
                                        : _editingCourseImages,
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
                                    : _getButtonText(),
                                width: 320,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}