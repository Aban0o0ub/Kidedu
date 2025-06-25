import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginpage/features/lesson/logic/cubit/section_cubit.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/appbar.dart';
import '../../data/models/lesson.dart';
import '../../data/models/section.dart';
import '../../logic/cubit/lesson_cubit.dart';
import '../widgets/action_buttons.dart';
import '../widgets/attachment_selector.dart';
import '../widgets/caption_option_widget.dart';
import '../widgets/link_option_widget.dart';
import '../widgets/photo_option_widget.dart';
import '../widgets/quiz_option_widget.dart';
import '../widgets/section_input.dart';

class AddLessonPage extends StatefulWidget {
  const AddLessonPage({super.key, required this.courseId});
  final String courseId;

  @override
  State<AddLessonPage> createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  late SectionCubit sectionCubit;
  late LessonCubit lessonCubit;
  String? selectedSection;
  List<SectionModel> sections = [];
  String? selectedAnswer;
  final List<String> answers = ['Answer 1', 'Answer 2', 'Answer 3', 'Answer 4'];

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
    sectionCubit = getIt<SectionCubit>();
    lessonCubit = getIt<LessonCubit>();

    sectionCubit.emitGetSection(widget.courseId);

    answerControllers = [
      answer1Controller,
      answer2Controller,
      answer3Controller,
      answer4Controller,
    ];
    _loadSections();
  }

  void _loadSections() {
    String courseId = widget.courseId;
    sectionCubit.emitGetSection(courseId);
  }

  void _createNewSection(String sectionName) async {
    String courseId = widget.courseId;
    final request = CreateSectionRequest(courseId, title: sectionName);

    try {
      await sectionCubit.emitAddSection(request);
      await Future.delayed(const Duration(milliseconds: 500));
      await sectionCubit.emitGetSection(courseId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error adding section $e')),
      );
      setState(() {
        selectedSection = null;
      });
    }
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

  void _clearForm() {
    setState(() {
      selectedSection = null;
      lessonNameController.clear();
      captionController.clear();
      linkController.clear();
      _selectedImage = null;
      showOptions1 = false;
      showOptions2 = false;
      showOptions3 = false;
      showOptions4 = false;
    });
  }

  void _handleUpload() {
    if (_validateInputs()) {
      final request = _buildLessonRequest();
      lessonCubit.emitAddLesson(request);
    }
  }

  bool _validateInputs() {
    if (selectedSection == null || selectedSection!.isEmpty) {
      _showErrorMessage('Please select a section');
      return false;
    }

    if (lessonNameController.text.trim().isEmpty) {
      _showErrorMessage('Please enter lesson name');
      return false;
    }

    bool hasYoutubeLink = linkController.text.trim().isNotEmpty;
    bool hasImage = _selectedImage != null;

    if (!hasYoutubeLink && !hasImage) {
      _showErrorMessage('Please add either a YouTube URL or upload an image');
      return false;
    }

    if (hasYoutubeLink) {
      String link = linkController.text.trim();
      if (!_isValidYouTubeUrl(link)) {
        _showErrorMessage('Please enter a valid YouTube URL');
        return false;
      }
    }

    return true;
  }

  bool _isValidYouTubeUrl(String url) {
    final youtubeRegex = RegExp(
      r'^https?://(www\.)?(youtube\.com/(watch\?v=|embed/)|youtu\.be/)',
      caseSensitive: false,
    );
    return youtubeRegex.hasMatch(url);
  }

  LessonCreateRequest _buildLessonRequest() {
    List<File> files = [];

    if (_selectedImage != null) {
      files.add(_selectedImage!);
    }

    return LessonCreateRequest(
      sectionId: selectedSection!,
      name: lessonNameController.text.trim(),
      description: captionController.text.trim().isEmpty 
          ? "" 
          : captionController.text.trim(),
      youtubeVideoUrl: linkController.text.trim().isEmpty 
          ? "" 
          : linkController.text.trim(),
      files: files,
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildOptionContent(int option) {
    switch (option) {
      case 2:
        return PhotoOptionWidget(
          selectedImage: _selectedImage,
          onPickImage: _pickImage,
        );
      case 4:
        return CaptionOptionWidget(controller: captionController);
      case 3:
        return QuizOptionWidget(
          questionController: quizQuestionController,
          answerControllers: answerControllers,
          answers: answers,
          selectedAnswer: selectedAnswer,
          onAnswerChanged: (newValue) {
            setState(() {
              selectedAnswer = newValue;
            });
          },
        );
      case 1:
        return LinkOptionWidget(
          controller: linkController,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  void dispose() {
    lessonNameController.dispose();
    captionController.dispose();
    linkController.dispose();
    quizQuestionController.dispose();
    answer1Controller.dispose();
    answer2Controller.dispose();
    answer3Controller.dispose();
    answer4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sectionCubit),
        BlocProvider.value(value: lessonCubit),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Upload Lesson",
          onBackPressed: () => Navigator.pop(context),
        ),
        body: MultiBlocListener(
          listeners: [
            // SectionCubit Listener
            BlocListener<SectionCubit, SectionState>(
              listener: (context, state) {
                if (state is AddSectionSuccess) {
                  _loadSections();
                  setState(() {
                    selectedSection = state.newSection.section.id;
                  });
                  _showSuccessMessage('Section added successfully!');
                } else if (state is AddSectionFailure) {
                  _showErrorMessage('Section Error: ${state.error}');
                }
              },
            ),
            // LessonCubit Listener
            BlocListener<LessonCubit, LessonState>(
              listener: (context, state) {
                if (state is AddLessonSuccess) {
                  _showSuccessMessage('Lesson uploaded successfully!');
                  _clearForm();
                  context.push(Routes.instructorProfilePage);
                } else if (state is AddLessonFailure) {
                  _showErrorMessage('Upload Error: ${state.error}');
                }
              },
            ),
          ],
          child: BlocBuilder<SectionCubit, SectionState>(
            builder: (context, state) {
              if (state is GetSectionLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetSectionSuccess) {
                sections = state.response.sections;

                return Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionInput(
                                selectedSection: selectedSection,
                                sections: sections,
                                lessonNameController: lessonNameController,
                                onSectionChanged: (value) {
                                  setState(() {
                                    selectedSection = value;
                                  });
                                },
                                onAddNewSection: (String sectionTitle) {
                                  _createNewSection(sectionTitle);
                                },
                              ),
                              const SizedBox(height: 24),
                              AttachmentSelector(
                                showOptions1: showOptions1,
                                showOptions2: showOptions2,
                                showOptions3: showOptions3,
                                showOptions4: showOptions4,
                                onOptionSelected: (index) {
                                  setState(() {
                                    showOptions1 =
                                        index == 1 ? !showOptions1 : false;
                                    showOptions2 =
                                        index == 2 ? !showOptions2 : false;
                                    showOptions3 =
                                        index == 3 ? !showOptions3 : false;
                                    showOptions4 =
                                        index == 4 ? !showOptions4 : false;
                                  });
                                },
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
                    ),
                    // Loading indicator للـ upload
                    BlocBuilder<LessonCubit, LessonState>(
                      builder: (context, lessonState) {
                        if (lessonState is AddLessonLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 8),
                                  Text('Uploading lesson...'),
                                ],
                              ),
                            ),
                          );
                        }
                        return ActionButtons(
                          onUpload: _handleUpload,
                          onCancel: () => Navigator.pop(context),
                        );
                      },
                    ),
                  ],
                );
              } else if (state is GetSectionFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.error}'),
                      ElevatedButton(
                        onPressed: _loadSections,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text('No data available'));
            },
          ),
        ),
      ),
    );
  }
}