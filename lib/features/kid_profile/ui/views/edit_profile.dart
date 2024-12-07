import 'package:flutter/material.dart';
import 'package:loginpage/core/widgets/arrow_back.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_dropdown.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_text_field.dart';
import 'package:loginpage/features/sign_up/ui/widgets/select_gender.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController governorateController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                controller: nameController,
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
                controller: nameController,
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
                controller: nameController,
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
              const SelectGender(),
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: "Confirm changes",
                  onPressed: () {
                    //
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
