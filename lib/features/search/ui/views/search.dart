import 'package:flutter/material.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_results_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  String? selectedMode;
  int selectedAge = 1;
  String? selectedGovernorate;
  String? selectedCategory;

  final List<String> modes = ["Online", "Offline"];
  final List<String> categories = ["Sports", "Arts", "Education", "Skills", "Games"];
  final List<String> governorates = ["Cairo", "Giza", "Alexandria"];

  List<String> searchResults = [];
  List<String> allItems = [];

  void applyFilters() {
    String query = searchController.text.toLowerCase();
    setState(() {
      searchResults = allItems.where((item) {
        bool matchesSearch = query.isEmpty || item.toLowerCase().contains(query);
        bool matchesMode = selectedMode == null || item.contains(selectedMode!);
        bool matchesAge = item.contains(selectedAge.toString());
        bool matchesGovernorate = selectedGovernorate == null || item.contains(selectedGovernorate!);
        bool matchesCategory = selectedCategory == null || item.contains(selectedCategory!);

        return matchesSearch && matchesMode && matchesAge && matchesGovernorate && matchesCategory;
      }).toList();
    });
  }

  void showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FilterBottomSheet(
          modes: modes,
          categories: categories,
          governorates: governorates,
          selectedMode: selectedMode,
          selectedAge: selectedAge,
          selectedCategory: selectedCategory,
          selectedGovernorate: selectedGovernorate,
          onModeChanged: (value) => selectedMode = value,
          onAgeChanged: (value) => selectedAge = value,
          onCategoryChanged: (value) => selectedCategory = value,
          onGovernorateChanged: (value) => selectedGovernorate = value,
          onClearFilters: () {
            setState(() {
              selectedMode = null;
              selectedAge = 1;
              selectedCategory = null;
              selectedGovernorate = null;
            });
          },
          onApplyFilters: applyFilters,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomSearchBar(
          searchController: searchController,
          onSearchChanged: (_) => applyFilters(),
          onFilterPressed: showFilterSheet,
          onClearSearch: () {
            searchController.clear();
            applyFilters();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchResultsList(results: searchResults),
        ),
      ),
    );
  }
}
