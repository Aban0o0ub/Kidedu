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
    this.maxLines,
    this.minLines,
    this.keyboardType = TextInputType.text,
    this.hasIcon = true,
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
  final int? maxLines;
  final int? minLines;
  final TextInputType keyboardType;
  final bool hasIcon;

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

  void _handleTap(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.globalToLocal(details.globalPosition);
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.controller.text,
        style: const TextStyle(fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    int index = textPainter.getPositionForOffset(offset).offset;

    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: index),
    );
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
          GestureDetector(
            onTapDown: _handleTap,
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPasswordField ? _obscureText : false,
              maxLines: widget.isPasswordField ? 1 : widget.maxLines,
              minLines: widget.isPasswordField ? 1 : widget.minLines,
              keyboardType: widget.isPasswordField
                  ? TextInputType.visiblePassword
                  : widget.keyboardType,
              decoration: InputDecoration(
                contentPadding: widget.hasIcon
                    ? widget.contentPadding
                    : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                prefixIcon: widget.hasIcon && widget.icon != null
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
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF02457A),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                suffixIcon: widget.isPasswordField
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF9D9D9D),
                        ),
                        onPressed: _toggleObscureText,
                      )
                    : widget.suffixIcon,
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
