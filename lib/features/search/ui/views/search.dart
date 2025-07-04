import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/add_course/data/models/Course_Model.dart';
import 'package:loginpage/features/home/ui/widgets/course_card.dart';
import '../../../../core/injection/injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../course_details/logic/cubit/course_details_cubit.dart';
import '../../../home/logic/cubit/course_category_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  List<CourseData> allCourses = [];
  List<CourseData> displayedCourses = [];

  late CourseCategoryCubit courseCategoryCubit;
  late CourseDetailsCubit courseDetailsCubit;

  String? selectedAvailability;
  RangeValues selectedAgeRange = RangeValues(0, 15);
  String? selectedCategory;
  String? selectedGovernorate;

  @override
  void initState() {
    super.initState();
    courseCategoryCubit = getIt<CourseCategoryCubit>();
    courseDetailsCubit = getIt<CourseDetailsCubit>();
    courseCategoryCubit.emitGetAllCourses();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  bool _isValidNetworkImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }

    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  void _performSearch(String query) {
    final results = allCourses.where((course) {
      final name = course.courseName?.toLowerCase() ?? '';
      final matchesQuery =
          query.isEmpty || name.startsWith(query.toLowerCase());

      final matchesAvailability = selectedAvailability == null ||
          course.availability?.toLowerCase() ==
              selectedAvailability?.toLowerCase();

      final matchesAge = selectedAgeRange == RangeValues(1, 15) ||
          (course.suitableAges?.any((age) =>
                  age >= selectedAgeRange.start &&
                  age <= selectedAgeRange.end) ??
              false);

      final matchesCategory = selectedCategory == null ||
          course.category?.toLowerCase() == selectedCategory?.toLowerCase();

      final matchesGovernorate = selectedGovernorate == null ||
          course.instructor?['Governorate']?.toString().toLowerCase() ==
              selectedGovernorate?.toLowerCase();

      return matchesQuery &&
          matchesAvailability &&
          matchesAge &&
          matchesCategory &&
          matchesGovernorate;
    }).toList();

    setState(() {
      displayedCourses = results;
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter by',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF02457A),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedAvailability,
                      decoration: InputDecoration(labelText: 'Availability'),
                      items: ['All', 'Online', 'Offline']
                          .map((value) => DropdownMenuItem<String>(
                                value: value == 'All' ? null : value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedAvailability = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                        'Age Range: ${selectedAgeRange.start.round()} - ${selectedAgeRange.end.round()}'),
                    RangeSlider(
                      values: selectedAgeRange,
                      min: 0,
                      max: 18,
                      divisions: 12,
                      labels: RangeLabels(
                        selectedAgeRange.start.round().toString(),
                        selectedAgeRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          selectedAgeRange = values;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(labelText: 'Category'),
                      items: [
                        'All',
                        'Sports',
                        'Arts',
                        'Education',
                        'Skills',
                        'Games'
                      ]
                          .map((value) => DropdownMenuItem<String>(
                                value: value == 'All' ? null : value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    // Commented out Governorate since it's not in the model
                    DropdownButtonFormField<String>(
                      value: selectedGovernorate,
                      decoration: InputDecoration(labelText: 'Governorate'),
                      items: [
                        'All',
                        'Alexandria',
                        'Aswan',
                        'Asyut',
                        'Beheira',
                        'Beni Suef',
                        'Cairo',
                        'Dakahlia',
                        'Damietta',
                        'Faiyum',
                        'Gharbia',
                        'Giza',
                        'Ismailia',
                        'Kafr El Sheikh',
                        'Luxor',
                        'Matruh',
                        'Minya',
                        'Monufia',
                        'New Valley',
                        'North Sinai',
                        'Port Said',
                        'Qalyubia',
                        'Qena',
                        'Red Sea',
                        'Sharqia',
                        'Sohag',
                        'South Sinai',
                        'Suez',
                      ]
                          .map((value) => DropdownMenuItem<String>(
                                value: value == 'All' ? null : value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedGovernorate = value;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF02457A),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 17),
                        ),
                        onPressed: () {
                          setState(() {}); // Update main state
                          _performSearch(searchController.text);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: courseCategoryCubit),
        BlocProvider.value(value: courseDetailsCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true, // Allow content to resize but navigation bar stays fixed
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                searchFocusNode.unfocus();
                _performSearch(value);
              },
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          searchFocusNode.unfocus();
                          _performSearch('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          backgroundColor: const Color(0xFF02457A),
          actions: [
            IconButton(
              icon: Icon(Icons.tune, color: Colors.white),
              onPressed: _openFilterSheet,
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            // Hide keyboard when tapping outside search field
            if (searchFocusNode.hasFocus) {
              searchFocusNode.unfocus();
            }
          },
          child: BlocListener<CourseCategoryCubit, CourseCategoryState>(
            listener: (context, state) {
              if (state is GetAllCourseSuccess) {
                setState(() {
                  allCourses = state.allCourses;
                  displayedCourses = [];
                });
              }
            },
            child: BlocBuilder<CourseCategoryCubit, CourseCategoryState>(
            builder: (context, state) {
              if (state is AllCoursesLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is GetAllCourseFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: //${state.error}'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<CourseCategoryCubit>()
                              .emitGetAllCourses();
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is GetAllCourseSuccess) {
                final List<CourseData> coursesToShow =
                    searchController.text.isEmpty ? [] : displayedCourses;

                return coursesToShow.isEmpty && searchController.text.isNotEmpty
                    ? Center(child: Text('No courses found.'))
                    : searchController.text.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search,
                                    size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  'Start typing to search courses...',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: coursesToShow.length,
                            itemBuilder: (context, index) {
                              final course = coursesToShow[index];
                              return GestureDetector(
                                onTap: () {
                                  if (course.id != null &&
                                      course.id!.isNotEmpty) {
                                    context.push(
                                      Routes.courseDetails,
                                      extra: {
                                        '_id': course.id,
                                        'courseDetailsCubit':
                                            courseDetailsCubit,
                                      },
                                    );
                                  }
                                },
                                child: CourseCard(
                                  courseImages: course.courseImages != null && 
                                      course.courseImages!.isNotEmpty
                                          ? course.courseImages!
                                          : null,
                                  courseName: course.courseName ?? '',
                                  instructor: course.instructor?['Name'] ?? '',
                                  description: course.description ?? '',
                                  price: course.price?.toDouble() ?? 0.0,
                                  availability: course.availability ?? '',
                                  id: course.id ?? '',
                                ),
                              );
                            },
                          );
              }
              return Center(child: Text('Start searching for courses...'));
            },
          ),
        ),
        ),
      ),
    );
  }
}
