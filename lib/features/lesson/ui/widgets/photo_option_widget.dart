import 'dart:io';
import 'package:flutter/material.dart';

class PhotoOptionWidget extends StatefulWidget {
  final List<File> selectedImages;
  final Function(List<File>) onImagesSelected;

  const PhotoOptionWidget({
    super.key,
    required this.selectedImages,
    required this.onImagesSelected,
  });

  @override
  State<PhotoOptionWidget> createState() => _PhotoOptionWidgetState();
}

class _PhotoOptionWidgetState extends State<PhotoOptionWidget> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _removeImage(int index) {
    setState(() {
      widget.selectedImages.removeAt(index);
      if (_currentIndex >= widget.selectedImages.length && widget.selectedImages.isNotEmpty) {
        _currentIndex = widget.selectedImages.length - 1;
      } else if (widget.selectedImages.isEmpty) {
        _currentIndex = 0;
      }
    });
    
    // Notify parent widget about updated images
    widget.onImagesSelected(widget.selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Photos:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF02457A),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => widget.onImagesSelected([]),  // This will trigger parent to open picker
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF02457A),
            foregroundColor: Colors.white,
          ),
          child: const Text('Upload Photos'),
        ),
        const SizedBox(height: 10),
        
        if (widget.selectedImages.isNotEmpty) ...[
          // Image carousel
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: widget.selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          widget.selectedImages[index],
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                
                // Remove button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _removeImage(_currentIndex),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Dots indicator (only show if more than 1 image)
          if (widget.selectedImages.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.selectedImages.length,
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
          
          const SizedBox(height: 10),
          Text(
            '${widget.selectedImages.length} image(s) selected',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}