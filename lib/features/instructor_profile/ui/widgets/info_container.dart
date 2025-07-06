import 'package:easy_localization/easy_localization.dart';
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
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
    );
  }

  if (name != null && name.isNotEmpty) {
    widgetList.add(
      Text("Name: $name",
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
    );
  }

  if (phone != null && phone.isNotEmpty) {
    widgetList.add(
      Text("Phone: $phone",
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
    );
  }

  if (email != null && email.isNotEmpty) {
    widgetList.add(
      Text("Email: $email",
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
    );
  }

  // Add 'governorate' if it is not null or empty
  if (governorate != null && governorate.isNotEmpty) {
    widgetList.add(
      Text("Governorate: $governorate",
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
    );
  }

  if (title != null && title.isNotEmpty) {
    widgetList.add(
      Text("Title: $title",
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor)),
    );
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Theme.of(context).primaryColor, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              header,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
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
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
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
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: instructorProfileCubit,
        child: BlocListener<InstructorProfileCubit, InstructorProfileState>(
          listener: (context, state) {
            if (state is UpdateInstructorSuccess) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Bio updated successfully!".tr()),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is UpdateInstructorFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${"Error:".tr()} ${state.error}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AlertDialog(
            title: Text(
              "Edit Bio".tr(),
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: TextField(
                controller: bioController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter your bio...".tr(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                            bio: bioController.text.trim(),
                          );
                    },
                    child: Text("Save".tr()),
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

  final instructorProfileCubit = context.read<InstructorProfileCubit>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: instructorProfileCubit,
        child: BlocListener<InstructorProfileCubit, InstructorProfileState>(
          listener: (context, state) {
            if (state is UpdateInstructorSuccess) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Experience updated successfully!".tr()),
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
            title: Text(
              "Edit Experience".tr(),
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: TextField(
                controller: experienceController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter your experience...".tr(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                    child: Text("Save".tr()),
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

// Personal Info Edit Dialog
void _showPersonalInfoEditDialog({
  required BuildContext context,
  required String name,
  required String phone,
  required String email,
  required String governorate,
  required String title,
}) {
  final TextEditingController nameController = TextEditingController(text: name);
  final TextEditingController phoneController = TextEditingController(text: phone);
  final TextEditingController emailController = TextEditingController(text: email);
  final TextEditingController governorateController = TextEditingController(text: governorate);
  final TextEditingController titleController = TextEditingController(text: title);

  final instructorProfileCubit = context.read<InstructorProfileCubit>();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: instructorProfileCubit,
        child: BlocListener<InstructorProfileCubit, InstructorProfileState>(
          listener: (context, state) {
            if (state is UpdateInstructorSuccess) {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Personal information updated successfully!".tr()),
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
            title: Text(
              "Edit Personal Information".tr(),
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name".tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone".tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email".tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: governorateController,
                    decoration: InputDecoration(
                      labelText: "Governorate".tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title".tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
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
                    child: Text("Save".tr()),
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
