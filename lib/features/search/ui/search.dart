import 'package:flutter/material.dart';

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
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Filter by", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Color(0xFF02457A))),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: "Availability"),
                    value: selectedMode,
                    items: modes.map((mode) => DropdownMenuItem(value: mode, child: Text(mode))).toList(),
                    onChanged: (value) => setSheetState(() => selectedMode = value),
                  ),
                  SizedBox(height: 10),
                  Text("Age"),
                  Slider(
                    value: selectedAge.toDouble(),
                    min: 1,
                    max: 15,
                    divisions: 14,
                    label: "$selectedAge",
                    onChanged: (value) => setSheetState(() => selectedAge = value.toInt()),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: "Category"),
                    value: selectedCategory,
                    items: categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                    onChanged: (value) => setSheetState(() => selectedCategory = value ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: "Governorate"),
                    value: selectedGovernorate,
                    items: governorates.map((gov) => DropdownMenuItem(value: gov, child: Text(gov))).toList(),
                    onChanged: (value) => setSheetState(() => selectedGovernorate = value),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedMode = null;
                            selectedAge = 1;
                            selectedCategory = null;
                            selectedGovernorate = null;
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Clear", style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          applyFilters();
                          Navigator.pop(context);
                        },
                        child: Text("Apply",style: TextStyle(color: Color(0xFF02457A))),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Color(0xFF02457A),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 3), 
            ),
          ],
        ),
      ),
          toolbarHeight: 80,
          //backgroundColor: Color(0xFF02457A),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) => applyFilters(),
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search, color: Colors.black54),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.black54),
                  onPressed: () {
                    searchController.clear();
                    applyFilters();
                  },
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.tune, color: Colors.white),
              onPressed: showFilterSheet,
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: searchResults.isEmpty
              ? Center(child: Text("No results found", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(searchResults[index]),
                      leading: Icon(Icons.school, color: Colors.blue[900]),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

