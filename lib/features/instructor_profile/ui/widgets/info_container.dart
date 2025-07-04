import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/instructor_profile_cubit.dart';

Widget buildInfoContainer({
  required String header,
  required BuildContext context,
  String? text,
  String? name,
  String? phone,
  String? email,
  String? governorate,
  String? title,
   bool showEditButton = true,
}) {
  List<Widget> widgetList = [];

  if (text != null && text.isNotEmpty) {
    widgetList.add(
      Text(
        text,
        style: const TextStyle(fontSize: 16, color: Color(0xFF02457A)),
      ),
    );
  }

  if (name != null && name.isNotEmpty) {
    widgetList.add(
      Text("Name: $name",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  if (phone != null && phone.isNotEmpty) {
    widgetList.add(
      Text("Phone: $phone",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  if (email != null && email.isNotEmpty) {
    widgetList.add(
      Text("Email: $email",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  // Add 'governorate' if it is not null or empty
  if (governorate != null && governorate.isNotEmpty) {
    widgetList.add(
      Text("Governorate: $governorate",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  if (title != null && title.isNotEmpty) {
    widgetList.add(
      Text("Title: $title",
          style: const TextStyle(fontSize: 16, color: Color(0xFF02457A))),
    );
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFF02457A), width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              header,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF02457A),
              ),
            ),
            // أخفي إيقون التعديل لو showEditButton هو false
            if (showEditButton)
              IconButton(
                onPressed: () {
                  _showEditDialog(
                    context: context,
                    header: header,
                    text: text,
                    name: name,
                    phone: phone,
                    email: email,
                    governorate: governorate,
                    title: title,
                  );
                },
                icon: const Icon(Icons.edit, color: Color(0xFF02457A)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...widgetList,
      ],
    ),
  );
}

// Function to show edit dialog
void _showEditDialog({
  required BuildContext context,
  required String header,
  String? text,
  String? name,
  String? phone,
  String? email,
  String? governorate,
  String? title,
}) {
  if (header == "Bio") {
    _showBioEditDialog(context, text ?? "");
  } else if (header == "Experience") {
    _showExperienceEditDialog(context, text ?? "");
  } else if (header == "Personal Information") {
    _showPersonalInfoEditDialog(
      context: context,
      name: name ?? "",
      phone: phone ?? "",
      email: email ?? "",
      governorate: governorate ?? "",
      title: title ?? "",
    );
  }
}

// Bio Edit Dialog
void _showBioEditDialog(BuildContext context, String currentBio) {
  final TextEditingController bioController =
      TextEditingController(text: currentBio);

  final instructorProfileCubit = context.read<InstructorProfileCubit>();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: instructorProfileCubit, // مرر الـ Cubit للـ Dialog
        child: BlocListener<InstructorProfileCubit, InstructorProfileState>(
          listener: (context, state) {
            if (state is UpdateInstructorSuccess) {
              Navigator.of(dialogContext).pop();
              // تحديث البيانات في الـ UI
             // context.read<InstructorProfileCubit>().emitGetInstructorProfile();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bio updated successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is UpdateInstructorFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: ${state.error}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AlertDialog(
            title: const Text(
              "Edit Bio",
              style: TextStyle(
                  color: Color(0xFF02457A), fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: TextField(
                controller: bioController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Enter your bio...",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF02457A)),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              BlocBuilder<InstructorProfileCubit, InstructorProfileState>(
                builder: (context, state) {
                  if (state is UpdateInstructorLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      // استدعاء الـ update method
                      context
                          .read<InstructorProfileCubit>()
                          .emitUpdateInstructorProfile(
                            bio: bioController.text.trim(),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF02457A),
                    ),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Experience Edit Dialog
void _showExperienceEditDialog(BuildContext context, String currentExperience) {
  final TextEditingController experienceController =
      TextEditingController(text: currentExperience);

  // احصل على الـ Cubit من الـ context الحالي
  final instructorProfileCubit = context.read<InstructorProfileCubit>();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: instructorProfileCubit, // مرر الـ Cubit للـ Dialog
        child: BlocListener<InstructorProfileCubit, InstructorProfileState>(
          listener: (context, state) {
            if (state is UpdateInstructorSuccess) {
              Navigator.of(dialogContext).pop();
             // context.read<InstructorProfileCubit>().emitGetInstructorProfile();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Experience updated successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is UpdateInstructorFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: ${state.error}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AlertDialog(
            title: const Text(
              "Edit Experience",
              style: TextStyle(
                  color: Color(0xFF02457A), fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: TextField(
                controller: experienceController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Enter your experience...",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF02457A)),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              BlocBuilder<InstructorProfileCubit, InstructorProfileState>(
                builder: (context, state) {
                  if (state is UpdateInstructorLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context
                          .read<InstructorProfileCubit>()
                          .emitUpdateInstructorProfile(
                            experience: experienceController.text.trim(),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF02457A),
                    ),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Personal Information Edit Dialog
void _showPersonalInfoEditDialog({
  required BuildContext context,
  required String name,
  required String phone,
  required String email,
  required String governorate,
  required String title,
}) {
  final TextEditingController nameController =
      TextEditingController(text: name);
  final TextEditingController phoneController =
      TextEditingController(text: phone);
  final TextEditingController emailController =
      TextEditingController(text: email);
  final TextEditingController governorateController =
      TextEditingController(text: governorate);
  final TextEditingController titleController =
      TextEditingController(text: title);

  // احصل على الـ Cubit من الـ context الحالي
  final instructorProfileCubit = context.read<InstructorProfileCubit>();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: instructorProfileCubit, // مرر الـ Cubit للـ Dialog
        child: BlocListener<InstructorProfileCubit, InstructorProfileState>(
          listener: (context, state) {
            if (state is UpdateInstructorSuccess) {
              Navigator.of(dialogContext).pop();
              // تحديث البيانات في الـ UI
             // context.read<InstructorProfileCubit>().emitGetInstructorProfile();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Personal information updated successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is UpdateInstructorFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: ${state.error}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AlertDialog(
            title: const Text(
              "Edit Personal Information",
              style: TextStyle(
                  color: Color(0xFF02457A), fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF02457A)),
                        ),
                        labelStyle: TextStyle(color: Color(0xFF02457A)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF02457A)),
                        ),
                        labelStyle: TextStyle(color: Color(0xFF02457A)),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF02457A)),
                        ),
                        labelStyle: TextStyle(color: Color(0xFF02457A)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: governorateController,
                      decoration: const InputDecoration(
                        labelText: "Governorate",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF02457A)),
                        ),
                        labelStyle: TextStyle(color: Color(0xFF02457A)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF02457A)),
                        ),
                        labelStyle: TextStyle(color: Color(0xFF02457A)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
              BlocBuilder<InstructorProfileCubit, InstructorProfileState>(
                builder: (context, state) {
                  if (state is UpdateInstructorLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context
                          .read<InstructorProfileCubit>()
                          .emitUpdateInstructorProfile(
                            name: nameController.text.trim(),
                            phoneNumber: phoneController.text.trim(),
                            email: emailController.text.trim(),
                            governorate: governorateController.text.trim(),
                            title: titleController.text.trim(),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF02457A),
                    ),
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
