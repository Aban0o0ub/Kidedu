import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.items,
    this.icon,
    this.width = 180,
    this.height = 56,
    this.isRequired = true,
    this.validator,
    this.onChanged,
    String? errorText,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final List<String> items;
  final IconData? icon;
  final double width;
  final double height;
  final bool isRequired;
  final String? Function(String?)? validator;
   final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: Color(0xFF02457A),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              children: [
                if (isRequired)
                  const TextSpan(
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
          SizedBox(
            height: height,
            child: DropdownButtonFormField<String>(
              value: controller.text.isEmpty ? null : controller.text,
              items: items
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
                  
              onChanged: (String? newValue) {
                controller.text = newValue ?? '';
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  color: const Color(0xFF9D9D9D),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF9D9D9D),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF02457A),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF02457A),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              dropdownColor: Colors.white,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF02457A),
              ),
              isExpanded: true,
              iconSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
