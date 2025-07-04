import 'package:flutter/material.dart';
import '../../data/models/lesson.dart';

class CaptionContent extends StatelessWidget {
  final LessonModel lesson;

  const CaptionContent({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildPlayfulContentContainer(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayfulContentContainer() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.3), 
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xff02457A),    
        width: 1,
      ),
    ),
    child: SingleChildScrollView(
      child: _buildContent(),
    ),
  );
}

  Widget _buildContent() {
    final hasDescription =
        lesson.description != null && lesson.description!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lesson.name.isNotEmpty) _buildPlayfulLessonTitle(),
        if (lesson.name.isNotEmpty && hasDescription) _buildPlayfulDivider(),
        hasDescription
            ? _buildPlayfulDescription()
            : _buildPlayfulNoDescriptionMessage(),
      ],
    );
  }

  Widget _buildPlayfulLessonTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ Colors.grey.withOpacity(0.8),Color(0xff02457A).withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('✨', style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              lesson.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff02457A)
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildPlayfulDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff02457A),Colors.grey.withOpacity(0.8),],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('🌟', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.withOpacity(0.8),Color(0xff02457A),],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayfulDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xff02457A)),
      ),
      child: Text(
        lesson.description!,
        style: TextStyle(
          fontSize: 15,
          color: Color(0xff02457A),
          height: 1.6,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildPlayfulNoDescriptionMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.withOpacity(0.8),Color(0xff02457A).withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('📝', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "No description available",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff02457A),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "This lesson doesn't have a description yet",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xff02457A)
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
