// import 'package:flutter/material.dart';

// class AppFormTextFiled extends StatelessWidget {
//   final String hintText;
//   final bool? isObscured;
//   final Widget? suffixIcon;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;

//   final String? Function(String?)? validator;
//   const AppFormTextFiled(
//       {super.key,
//       required this.hintText,
//       this.isObscured,
//       this.suffixIcon,
//       this.controller,
//       this.validator,
//       this.keyboardType});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: Colors.grey,
//         isDense: true,
//         contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.grey, width: 1.3),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.grey, width: 1.3),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.red, width: 1.3),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(color: Colors.red, width: 1.3),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         hintText: hintText,
//         hintStyle: TextStyle(fontSize: 14),
//         suffixIcon: suffixIcon,
//       ),
//       obscureText: isObscured ?? false,
//       controller: controller,
//       validator: validator != null ? (value) => validator!(value) : null,
//       keyboardType: keyboardType,
//     );
//   }
// }
