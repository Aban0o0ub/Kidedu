import 'package:flutter/material.dart';
import '../widgets/pair_page.dart';

class CourseInfoCard extends StatelessWidget {
  final dynamic course;
  
  const CourseInfoCard({
    super.key,
    required this.course,
  });

  // Helper method to format date
  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }

  // Custom widget for displaying dates with labels
  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 20,
                color: Color(0xff02457A),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff02457A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatDate(course.startDate),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff02457A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event,
                size: 20,
                color: Color(0xff02457A),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'End Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff02457A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatDate(course.endDate),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff02457A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if course is offline and has dates
    bool isOffline = course.availability?.toLowerCase() == 'offline';
    bool hasDates = course.startDate != null || course.endDate != null;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF02457A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        runSpacing: 16,
        children: [
          BuildPairPage(
            icon1: Icons.stairs,
            text1: course.level ?? "course level",
            icon2: Icons.access_time,
            text2: "duration",
          ),
          BuildPairPage(
            icon1: Icons.category,
            text1: course.category ?? "Mathematics",
            icon2: Icons.location_on,
            text2: course.availability ?? "Online",
          ),
          BuildPairPage(
            icon1: Icons.people,
            text1: "Kids count",
            icon2: Icons.star,
            text2: "rating",
          ),
          BuildPairPage(
            icon1: Icons.monetization_on,
            text1: (course.price ?? "800").toString(),
            icon2: Icons.discount,
            text2: (course.offer ?? "20%").toString(),
          ),
          
          // Show start and end dates only for offline courses
          if (isOffline && hasDates) ...[
            _buildDateRow(),
          ],
        ],
      ),
    );
  }
}