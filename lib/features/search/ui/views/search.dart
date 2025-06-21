import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/networking/web_services.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../../home/ui/widgets/course_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_results_list.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   TextEditingController searchController = TextEditingController();
//   String? selectedMode;
//   int selectedAge = 1;
//   String? selectedGovernorate;
//   String? selectedCategory;

//   final List<String> modes = ["Online", "Offline"];
//   final List<String> categories = ["Sports", "Arts", "Education", "Skills", "Games"];
//   final List<String> governorates = ["Cairo", "Giza", "Alexandria"];

//   List<String> searchResults = [];
//   List<String> allItems = [];

//   void applyFilters() {
//     String query = searchController.text.toLowerCase();
//     setState(() {
//       searchResults = allItems.where((item) {
//         bool matchesSearch = query.isEmpty || item.toLowerCase().contains(query);
//         bool matchesMode = selectedMode == null || item.contains(selectedMode!);
//         bool matchesAge = item.contains(selectedAge.toString());
//         bool matchesGovernorate = selectedGovernorate == null || item.contains(selectedGovernorate!);
//         bool matchesCategory = selectedCategory == null || item.contains(selectedCategory!);

//         return matchesSearch && matchesMode && matchesAge && matchesGovernorate && matchesCategory;
//       }).toList();
//     });
//   }

//   void showFilterSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return FilterBottomSheet(
//           modes: modes,
//           categories: categories,
//           governorates: governorates,
//           selectedMode: selectedMode,
//           selectedAge: selectedAge,
//           selectedCategory: selectedCategory,
//           selectedGovernorate: selectedGovernorate,
//           onModeChanged: (value) => selectedMode = value,
//           onAgeChanged: (value) => selectedAge = value,
//           onCategoryChanged: (value) => selectedCategory = value,
//           onGovernorateChanged: (value) => selectedGovernorate = value,
//           onClearFilters: () {
//             setState(() {
//               selectedMode = null;
//               selectedAge = 1;
//               selectedCategory = null;
//               selectedGovernorate = null;
//             });
//           },
//           onApplyFilters: applyFilters,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: CustomSearchBar(
//           searchController: searchController,
//           onSearchChanged: (_) => applyFilters(),
//           onFilterPressed: showFilterSheet,
//           onClearSearch: () {
//             searchController.clear();
//             applyFilters();
//           },
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SearchResultsList(results: searchResults),
//         ),
//       ),
//     );
//   }
// }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  final WebServices _webService = WebServices(Dio());

  List<CourseData> allCourses = [];
  List<CourseData> displayedCourses = [];
  bool isLoading = false;

  String? selectedAvailability;
  RangeValues selectedAgeRange = RangeValues(1, 12);
  String? selectedCategory;
  String? selectedGovernorate;

  @override
  void initState() {
    super.initState();
    _loadAllCourses();
    // إضافة listener للـ search controller
    searchController.addListener(() {
      setState(() {}); // عشان الـ clear button يظهر ويختفي
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllCourses() async {
    setState(() => isLoading = true);
    try {
      List<CourseData> results = await _webService.getAllCourses();
      setState(() {
        allCourses = results;
        displayedCourses = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // يمكن تضيف error handling هنا
      print('Error loading courses: $e');
    }
  }

  void _performSearch(String query) {
    final results = allCourses.where((course) {
      // 1. البحث في اسم الكورس
      final name = course.courseName?.toLowerCase() ?? '';
      final matchesQuery = query.isEmpty || name.contains(query.toLowerCase());

      // 2. فلتر الـ availability
      final matchesAvailability = selectedAvailability == null ||
          course.availability?.toLowerCase() == selectedAvailability?.toLowerCase();

      // 3. فلتر العمر (مفعل دلوقتي)
      // final courseAge = course.age ?? 0;
      // final matchesAge = courseAge >= selectedAgeRange.start && courseAge <= selectedAgeRange.end;

      // 4. فلتر الفئة
      final matchesCategory = selectedCategory == null ||
          course.category?.toLowerCase() == selectedCategory?.toLowerCase();

      // 5. فلتر المحافظة (مفعل دلوقتي)
      // final matchesGovernorate = selectedGovernorate == null ||
      //     course.governorate?.toLowerCase() == selectedGovernorate?.toLowerCase();

      return matchesQuery &&
          matchesAvailability &&
          //matchesAge &&
          matchesCategory ;
         // matchesGovernorate;
    }).toList();

    setState(() {
      displayedCourses = results;
    });
  }

  void _clearSearch() {
    searchController.clear();
    _performSearch('');
  }

  void _resetFilters() {
    setState(() {
      selectedAvailability = null;
      selectedAgeRange = RangeValues(1, 12);
      selectedCategory = null;
      selectedGovernorate = null;
    });
    _performSearch(searchController.text);
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter by',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF02457A),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              selectedAvailability = null;
                              selectedAgeRange = RangeValues(1, 12);
                              selectedCategory = null;
                              selectedGovernorate = null;
                            });
                          },
                          child: Text('Reset', style: TextStyle(color: Color(0xFF02457A))),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Availability Filter
                    DropdownButtonFormField<String>(
                      value: selectedAvailability,
                      decoration: InputDecoration(
                        labelText: 'Availability',
                        border: OutlineInputBorder(),
                      ),
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
                    
                    // Age Range Filter
                    Text(
                      'Age Range: ${selectedAgeRange.start.round()} - ${selectedAgeRange.end.round()} years',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    RangeSlider(
                      values: selectedAgeRange,
                      min: 1,
                      max: 12,
                      divisions: 11,
                      activeColor: Color(0xFF02457A),
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
                    
                    // Category Filter
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['All', 'sports', 'arts', 'education', 'skills', 'games']
                          .map((value) => DropdownMenuItem<String>(
                                value: value == 'All' ? null : value,
                                child: Text(value.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    
                    // Governorate Filter
                    DropdownButtonFormField<String>(
                      value: selectedGovernorate,
                      decoration: InputDecoration(
                        labelText: 'Governorate',
                        border: OutlineInputBorder(),
                      ),
                      items: ['All', 'Alexandria', 'Cairo', 'Giza', 'Assiut', 'Luxor']
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
                    
                    // Apply Button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF02457A),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                // تحديث الـ state الرئيسي
                              });
                              _performSearch(searchController.text);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Apply Filters',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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
    final List<CourseData> coursesToShow =
        displayedCourses.isEmpty && searchController.text.isEmpty && 
        selectedAvailability == null && selectedCategory == null && selectedGovernorate == null
            ? allCourses
            : displayedCourses;

    return Scaffold(
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
            onChanged: _performSearch, // ✅ مش onSubmitted
            decoration: InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: Icon(Icons.search, color: Color(0xFF02457A)),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Color(0xFF02457A)),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF02457A),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.white), // filter icon أحسن
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Filters Display
          if (selectedAvailability != null || selectedCategory != null || selectedGovernorate != null)
            Container(
              padding: EdgeInsets.all(8),
              color: Colors.grey[100],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Active filters: ', style: TextStyle(fontWeight: FontWeight.w500)),
                    if (selectedAvailability != null)
                      _buildFilterChip('Availability: $selectedAvailability', () {
                        setState(() => selectedAvailability = null);
                        _performSearch(searchController.text);
                      }),
                    if (selectedCategory != null)
                      _buildFilterChip('Category: $selectedCategory', () {
                        setState(() => selectedCategory = null);
                        _performSearch(searchController.text);
                      }),
                    if (selectedGovernorate != null)
                      _buildFilterChip('Location: $selectedGovernorate', () {
                        setState(() => selectedGovernorate = null);
                        _performSearch(searchController.text);
                      }),
                    TextButton(
                      onPressed: _resetFilters,
                      child: Text('Clear All', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            ),
          
          // Results
          Expanded(
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF02457A)),
                        SizedBox(height: 16),
                        Text('Loading courses...'),
                      ],
                    ),
                  )
                : coursesToShow.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No courses found',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Found ${coursesToShow.length} course${coursesToShow.length == 1 ? '' : 's'}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF02457A),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: coursesToShow.length,
                              itemBuilder: (context, index) {
                                final course = coursesToShow[index];
                                return CourseCard(
                                  courseName: course.courseName ?? 'Unknown Course',
                                  instructor: 'By ${course.instructor ?? 'Unknown'}',
                                  description: course.description ?? 'No description available',
                                  price: course.price ?? 0.0,
                                  availability: course.availability ?? 'Unknown',
                                  id: course.id ?? '',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: TextStyle(fontSize: 12)),
        deleteIcon: Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: Color(0xFF02457A).withOpacity(0.1),
        deleteIconColor: Color(0xFF02457A),
      ),
    );
  }
}
