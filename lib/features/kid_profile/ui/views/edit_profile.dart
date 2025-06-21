import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/core/widgets/appbar.dart';
import 'package:loginpage/features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/select_gender.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../core/injection/injection.dart';
import 'package:image_picker/image_picker.dart';
import '../../../sign_up/data/models/kid.dart';
import '../widgets/bottom_sheet.dart';

class EditProfile extends StatefulWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? age;
  final String? governorate;
  final String? gender;
  final String? image;

  const EditProfile({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.age,
    this.governorate,
    this.gender,
    this.image,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late KidProfileCubit kidProfileCubit;
  KidData? kidData;
  XFile? _imageFile;
  final ImagePicker picker = ImagePicker();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController governorateController = TextEditingController();
  final TextEditingController _selectedGenderController =
      TextEditingController();

  // bool _controllersInitialized = false;

  final List<String> egyptianGovernorates = [
    'Alexandria',
    'Aswan',
    'Asyut',
    'Beheira',
    'Beni Suef',
    'Cairo',
    'Dakahlia',
    'Damietta',
    'Faiyum',
    'Gharbia',
    'Giza',
    'Ismailia',
    'Kafr El Sheikh',
    'Luxor',
    'Matruh',
    'Minya',
    'Monufia',
    'New Valley',
    'North Sinai',
    'Port Said',
    'Qalyubia',
    'Qena',
    'Red Sea',
    'Sharqia',
    'Sohag',
    'South Sinai',
    'Suez'
  ];

  Future<void> takePhoto(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    kidProfileCubit = getIt<KidProfileCubit>();

    nameController.text = widget.name ?? '';
    emailController.text = widget.email ?? '';
    phoneController.text = widget.phone ?? '';
    ageController.text = widget.age ?? '';
    governorateController.text = widget.governorate ?? '';
    _selectedGenderController.text = widget.gender ?? '';

    kidProfileCubit.emitGetKidProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    governorateController.dispose();
    _selectedGenderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: kidProfileCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Edit Profile",
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocListener<KidProfileCubit, KidProfileState>(
          bloc: kidProfileCubit,
          listener: (context, state) {
            if (state is UpdateKidLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            } else if (state is UpdateKidProfile) {
              Navigator.pop(context);

              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: 'Success',
                text: 'Profile updated successfully!',
                confirmBtnText: 'Okay',
                confirmBtnColor: Colors.green,
                onConfirmBtnTap: () {
                  context.pop();
                  context.pop(true);
                },
              );
            } else if (state is UpdateKidFailure) {
              Navigator.pop(context);

              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'Error',
                text: 'Failed to update profile. Please try again.',
                confirmBtnText: 'Okay',
                confirmBtnColor: Colors.red,
              );
            }
          },
          child: BlocBuilder<KidProfileCubit, KidProfileState>(
            bloc: kidProfileCubit,
            builder: (context, state) {
              if (state is KidProfileSuccess &&
                  widget.name == null &&
                  widget.email == null &&
                  widget.phone == null &&
                  widget.age == null &&
                  widget.governorate == null &&
                  widget.gender == null) {
                nameController.text = state.kid.name ?? '';
                emailController.text = state.kid.email ?? '';
                phoneController.text = state.kid.phoneNumber ?? '';
                ageController.text = state.kid.age?.toString() ?? '';
                governorateController.text = state.kid.governorate ?? '';
                _selectedGenderController.text = state.kid.gender ?? '';
              }
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 27, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _imageFile != null
                                  ? FileImage(File(_imageFile!.path))
                                  : (widget.image != null &&
                                          widget.image!.isNotEmpty)
                                      ? (widget.image!.startsWith('http')
                                          ? NetworkImage(widget.image!)
                                          : FileImage(File(widget.image!)))
                                      : const AssetImage(
                                              'assets/images/kidprofile.jpeg')
                                          as ImageProvider,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) =>
                                        bottomSheet(context, takePhoto)));
                              },
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: nameController,
                        label: 'Name',
                        hintText: "Enter your name",
                        keyboardType: TextInputType.name,
                        contentPadding: const EdgeInsets.only(left: 20),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: emailController,
                        label: 'Email',
                        hintText: "Enter your email",
                        keyboardType: TextInputType.emailAddress,
                        contentPadding: const EdgeInsets.only(left: 20),
                      ),
                      const SizedBox(height: 15),
                      CustomDropdownField(
                        label: "Governorate",
                        controller: governorateController,
                        items: egyptianGovernorates,
                        hintText: "Choose your governorate",
                        icon: Icons.location_on_outlined,
                        width: double.infinity,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        hintText: '+20| Enter your phone number',
                        keyboardType: TextInputType.phone,
                        contentPadding: const EdgeInsets.only(left: 20),
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: ageController,
                        label: 'Age',
                        hintText: 'Enter your age between 0 and 15',
                        keyboardType: TextInputType.number,
                        contentPadding: const EdgeInsets.only(left: 20),
                      ),
                      const SizedBox(height: 15),
                      SelectGender(
                        initialGender: _selectedGenderController.text,
                        onGenderSelected: (String gender) {
                          setState(() {
                            _selectedGenderController.text = gender;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomButton(
                          text: "Confirm changes",
                          onPressed: () {
                            KidData updatedKid = KidData(
                              image: _imageFile?.path ?? widget.image ?? "",
                              name: nameController.text.trim().isNotEmpty
                                  ? nameController.text.trim()
                                  : null,
                              email: emailController.text.trim().isNotEmpty
                                  ? emailController.text.trim()
                                  : null,
                              phoneNumber:
                                  phoneController.text.trim().isNotEmpty
                                      ? phoneController.text.trim()
                                      : null,
                              age: ageController.text.trim().isNotEmpty
                                  ? int.tryParse(ageController.text.trim())
                                  : null,
                              governorate:
                                  governorateController.text.trim().isNotEmpty
                                      ? governorateController.text.trim()
                                      : null,
                              gender: _selectedGenderController.text
                                      .trim()
                                      .isNotEmpty
                                  ? _selectedGenderController.text.trim()
                                  : null,
                            );

                            kidProfileCubit.emitUpdateKidProfile(updatedKid);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
