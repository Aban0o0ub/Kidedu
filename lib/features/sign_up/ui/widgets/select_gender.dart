import 'package:flutter/material.dart';

class SelectGender extends StatefulWidget {
  final Function(String) onGenderSelected;

  const SelectGender({super.key, required this.onGenderSelected, required String initialGender});

  @override
  State<SelectGender> createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  String? _selectedGender;

  void _selectGender(String value) {
    setState(() {
      _selectedGender = value;
    });
    widget.onGenderSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text(
        "Gender",
        style: TextStyle(
          color: Color(0xFF02457A),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _selectGender('Female'),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/femaleicon.png',
                  width: 50,
                  height: 50,
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Female',
                      groupValue: _selectedGender,
                      onChanged: (value) => _selectGender(value!),
                    ),
                    const Text(
                      "Female",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: () => _selectGender('Male'),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/maleicon.png',
                  width: 50,
                  height: 50,
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Male',
                      groupValue: _selectedGender,
                      onChanged: (value) => _selectGender(value!),
                    ),
                    const Text(
                      "Male",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    ]);
  }
}
