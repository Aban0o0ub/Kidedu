import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.label,
    this.icon,
    required this.hintText,
    this.isPasswordField = false,
    required this.controller,
    this.validator,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16),
    this.width = 360,
  });

  final String label;
  final IconData? icon;
  final String hintText;
  final bool isPasswordField;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry contentPadding;
  final double width;

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: Color(0xFF02457A),
              fontSize: 24,
            ),
          ),
          TextField(
            controller: widget.controller,
            obscureText: widget.isPasswordField ? _obscureText : false,
            onTap: () {
              widget.controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: widget.controller.text.length,
              );
            },
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              prefixIcon: widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: const Color(0xFF9D9D9D),
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF9D9D9D),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF02457A),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF02457A),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              suffixIcon: widget.isPasswordField
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF9D9D9D),
                      ),
                      onPressed: _toggleObscureText,
                    )
                  : widget.suffixIcon,
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}