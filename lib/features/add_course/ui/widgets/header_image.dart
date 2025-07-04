import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HeaderImage extends StatefulWidget {
  final Function(List<File>)? onImagesSelected;
  final List<String>? initialImages; // For editing existing courses
  
  const HeaderImage({
    super.key, 
    this.onImagesSelected,
    this.initialImages,
  });

  @override
  State<HeaderImage> createState() => _HeaderImageState();
}

class _HeaderImageState extends State<HeaderImage> {
  List<File> _pickedImages = [];
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // If editing and has initial images, we'll show them as network images
  }

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _pickedImages = pickedFiles.map((xFile) => File(xFile.path)).toList();
        _currentIndex = 0;
      });
      
      // Notify parent widget about selected images
      if (widget.onImagesSelected != null) {
        widget.onImagesSelected!(_pickedImages);
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
      if (_currentIndex >= _pickedImages.length && _pickedImages.isNotEmpty) {
        _currentIndex = _pickedImages.length - 1;
      } else if (_pickedImages.isEmpty) {
        _currentIndex = 0;
      }
    });
    
    // Notify parent widget about updated images
    if (widget.onImagesSelected != null) {
      widget.onImagesSelected!(_pickedImages);
    }
  }

  Widget _buildImageContainer() {
    bool hasImages = _pickedImages.isNotEmpty;
    bool hasInitialImages = widget.initialImages != null && widget.initialImages!.isNotEmpty;
    
    if (!hasImages && !hasInitialImages) {
      // Show default image when no images selected
      return Container(
        height: 330,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: Stack(
            children: [
              // Default background image
              Image.asset(
                'assets/images/CourseDefaultPhoto.jpeg',
                height: 330,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 330,
                    width: double.infinity,
                    color: const Color(0xffB7B7B7),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Color(0xFF02457A),
                      ),
                    ),
                  );
                },
              ),
              // Overlay with instructions
              Container(
                height: 330,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'أضف صور الكورس',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'يمكنك اختيار أكثر من صورة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show selected images or initial images in carousel
    List<Widget> imageWidgets = [];
    
    if (hasImages) {
      // Show selected local images
      imageWidgets = _pickedImages.map((file) => 
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: Image.file(
            file,
            height: 330,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ).toList();
    } else if (hasInitialImages) {
      // Show initial network images (for editing)
      imageWidgets = widget.initialImages!.map((imageUrl) => 
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: Image.network(
            imageUrl,
            height: 330,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 330,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              );
            },
          ),
        ),
      ).toList();
    }

    return Stack(
      children: [
        Container(
          height: 330,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: imageWidgets,
          ),
        ),
        
        // Dots indicator
        if (imageWidgets.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageWidgets.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index 
                        ? const Color(0xFF02457A)
                        : Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
        
        // Remove button for selected images
        if (hasImages && imageWidgets.isNotEmpty)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => _removeImage(_currentIndex),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(50),
      child: _buildImageContainer(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
