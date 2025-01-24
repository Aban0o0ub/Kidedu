import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/networking/web_services.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/kid_profile/data/Repo/kid_profile_repo.dart';
import 'package:loginpage/features/kid_profile/logic/cubit/kid_profile_cubit.dart';
import 'package:loginpage/features/sign_up/data/models/kid.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/select_gender.dart';

class EditProfile extends StatefulWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? age;
  final String? governorate;

  EditProfile({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.age,
    this.governorate,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController governorateController = TextEditingController();
  final TextEditingController _selectedGenderController =
      TextEditingController();
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

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with the values passed from the previous page
    nameController.text = widget.name ?? '';
    emailController.text = widget.email ?? '';
    phoneController.text = widget.phone ?? '';
    ageController.text = widget.age ?? '';
    governorateController.text = widget.governorate ?? '';
  }

  @override
  Widget build(BuildContext context) {
    //.....................................................................
    return Scaffold(
      body: BlocListener<KidProfileCubit, KidProfileState>(
        bloc: KidProfileCubit(KidProfileRepo(WebServices(Dio()))),
        listener: (context, state) {
          if (state is MyLoading) {
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The profile has been updated'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is MyFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('There is an error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 27, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const ArrowBack(),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage('assets/images/kidprofile.jpeg'),
                      ),
                      GestureDetector(
                        //onTap: () {},
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
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF02457A),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: nameController,
                  label: 'Name',
                  hintText: "Enter your new name",
                  keyboardType: TextInputType.name,
                  contentPadding: const EdgeInsets.only(left: 20),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  hintText: "Enter your new email",
                  keyboardType: TextInputType.emailAddress,
                  contentPadding: const EdgeInsets.only(left: 20),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomDropdownField(
                  label: "Governorate",
                  controller: governorateController,
                  items: egyptianGovernorates,
                  hintText: "Choose your new governorate",
                  icon: Icons.location_on_outlined,
                  width: double.infinity,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: phoneController,
                  label: 'Phone Number',
                  hintText: '+20| Enter your new phone number',
                  keyboardType: TextInputType.phone,
                  contentPadding: const EdgeInsets.only(left: 20),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: ageController,
                  label: 'Age',
                  hintText: 'Enter your new age between 0 and 15',
                  keyboardType: TextInputType.number,
                  contentPadding: const EdgeInsets.only(left: 20),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                SelectGender(
                  onGenderSelected: (String gender) {
                    setState(() {
                      _selectedGenderController.text = gender;
                    });
                  },
                ),
                const SizedBox(height: 20),
                //---------------------------------------------------------------------------
                Center(
                  child: CustomButton(
                    text: "Confirm changes",
                    onPressed: () {
                      Kid updatedKid = Kid(
                        name: nameController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        age: int.tryParse(ageController.text),
                        governorate: governorateController.text,
                      );
                      context
                          .read<KidProfileCubit>()
                          .emitUpdateKidProfile(updatedKid);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
