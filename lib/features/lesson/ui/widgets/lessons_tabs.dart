import 'package:flutter/material.dart';

class LessonTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  
  const LessonTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              index: 0,
              icon: '📝',
              title: 'Caption',
              subtitle: 'Learn & Read',
              isSelected: selectedIndex == 0,
              onTap: () => onTabSelected(0),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildTab(
              index: 1,
              icon: '🧩',
              title: 'Quiz',
              subtitle: 'Test Yourself',
              isSelected: selectedIndex == 1,
              onTap: () => onTabSelected(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected 
                ? [Colors.grey.withOpacity(0.8), Color(0xff02457A).withOpacity(0.8)]
                : [Colors.grey.shade100, Colors.grey.shade200],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: isSelected ? 8 : 4,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            
            SizedBox(height: 8),
            
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
            
            SizedBox(height: 2),
            
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected 
                    ? Colors.white.withOpacity(0.9)
                    : Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}