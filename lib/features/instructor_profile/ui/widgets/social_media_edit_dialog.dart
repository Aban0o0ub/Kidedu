import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/helper/social_media_helper.dart';

class SocialMediaEditDialog extends StatefulWidget {
  final VoidCallback onSave;

  const SocialMediaEditDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<SocialMediaEditDialog> createState() => _SocialMediaEditDialogState();
}

class _SocialMediaEditDialogState extends State<SocialMediaEditDialog> {
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController behanceController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController githubController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentLinks();
  }

  void _loadCurrentLinks() {
   // whatsappController.text = SocialMediaHelper.getWhatsAppLink() ?? '';
    facebookController.text = SocialMediaHelper.getFacebookLink() ?? '';
    behanceController.text = SocialMediaHelper.getBehanceLink() ?? '';
    linkedinController.text = SocialMediaHelper.getLinkedInLink() ?? '';
    githubController.text = SocialMediaHelper.getGitHubLink() ?? '';
  }

  Future<void> _saveLinks() async {
    final links = <String, String>{};
    
    if (whatsappController.text.trim().isNotEmpty) {
      links['whatsapp'] = whatsappController.text.trim();
    }
    if (facebookController.text.trim().isNotEmpty) {
      links['facebook'] = facebookController.text.trim();
    }
    if (behanceController.text.trim().isNotEmpty) {
      links['behance'] = behanceController.text.trim();
    }
    if (linkedinController.text.trim().isNotEmpty) {
      links['linkedin'] = linkedinController.text.trim();
    }
    if (githubController.text.trim().isNotEmpty) {
      links['github'] = githubController.text.trim();
    }

    await SocialMediaHelper.saveAllLinks(links);
    widget.onSave();
    Navigator.of(context).pop();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF02457A)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF02457A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF02457A), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF02457A)),
        ),
        keyboardType: TextInputType.url,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.link,
                    color: const Color(0xFF02457A),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Edit Social Links".tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF02457A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Column(
                children: [
                  _buildTextField(
                    controller: facebookController,
                    label: "Facebook",
                    hint: "https://facebook.com/your-profile",
                    icon: Icons.facebook,
                  ),
                  _buildTextField(
                    controller: behanceController,
                    label: "Behance",
                    hint: "https://behance.net/your-profile",
                    icon: Icons.brush,
                  ),
                  _buildTextField(
                    controller: linkedinController,
                    label: "LinkedIn",
                    hint: "https://linkedin.com/in/your-profile",
                    icon: Icons.business,
                  ),
                  _buildTextField(
                    controller: githubController,
                    label: "GitHub",
                    hint: "https://github.com/your-username",
                    icon: Icons.code,
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Cancel".tr(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveLinks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF02457A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "Save".tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    whatsappController.dispose();
    facebookController.dispose();
    behanceController.dispose();
    linkedinController.dispose();
    githubController.dispose();
    super.dispose();
  }
} 