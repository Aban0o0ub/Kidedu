import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/injection/injection.dart';
import '../../../../core/widgets/appbar.dart';
import '../../../../core/routing/routes.dart';
import '../../../login/logic/cubit/my_cubit.dart';
import '../../logic/cubit/earnings_cubit.dart';

class AdminEarningsScreen extends StatefulWidget {
  const AdminEarningsScreen({super.key});

  @override
  State<AdminEarningsScreen> createState() => _AdminEarningsScreenState();
}

class _AdminEarningsScreenState extends State<AdminEarningsScreen> {
  late EarningsCubit earningsCubit;

  @override
  void initState() {
    super.initState();
    earningsCubit = getIt<EarningsCubit>();
    earningsCubit.emitGetOurEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: earningsCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Our Earnings",
        ),
        body: Stack(
          children: [
            BlocBuilder<EarningsCubit, EarningsState>(
              builder: (context, state) {
            if (state is KidEduEarningsLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF02457A),
                ),
              );
            } else if (state is KidEduEarningsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Failed to load earnings data",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "There seems to be an issue with earnings calculation",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<EarningsCubit>()
                            .emitGetOurEarnings();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF02457A),
                      ),
                      child:
                          Text("Retry", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            } else if (state is KidEduEarningsSuccess) {
              final earningsData = state.ourEarnings.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: AdminBalanceCard(
                          totalProfit: earningsData.totalProfit.toDouble(),
                          totalPayments: earningsData.totalPayments,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: UsersStatsCard(
                        kids: earningsData.users.kids,
                        instructors: earningsData.users.instructors,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AdminStatsCard(
                        lastUpdated: earningsData.lastUpdated,
                        totalPayments: earningsData.totalPayments,
                        totalProfit: earningsData.totalProfit.toDouble(),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
        // Logout Icon positioned at top right
        Positioned(
          top: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            child: IconButton(
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
              icon: Icon(Icons.logout),
              color: Colors.white,
              tooltip: "Logout".tr(),
            ),
          ),
        ),
      ],
    ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _performLogout(context);
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      // استخدام RoleCubit للخروج (سيقوم بمسح AuthService أيضاً)
      await context.read<RoleCubit>().logout();

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success".tr()),
              content: Text("Logout successfully".tr()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // العودة إلى صفحة الـ onboarding كما طلب المستخدم
                    context.go(Routes.welcomePage);
                  },
                  child: Text("Okay".tr()),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during logout: $e')),
        );
      }
    }
  }
}

class AdminBalanceCard extends StatelessWidget {
  final double totalProfit;
  final int totalPayments;

  const AdminBalanceCard({
    super.key,
    required this.totalProfit,
    required this.totalPayments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF02457A), Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Total Profit",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "\$${totalProfit.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "$totalPayments Payments",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsersStatsCard extends StatelessWidget {
  final int kids;
  final int instructors;

  const UsersStatsCard({
    super.key,
    required this.kids,
    required this.instructors,
  });

  @override
  Widget build(BuildContext context) {
    final int totalUsers = kids + instructors;
    final double kidsPercentage = totalUsers > 0 ? (kids / totalUsers) * 100 : 0;
    final double instructorsPercentage = totalUsers > 0 ? (instructors / totalUsers) * 100 : 0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Color(0xFF02457A),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.people,
                  color: Color(0xFF02457A),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "Users Statistics",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF02457A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Cards for visual representation
            Row(
              children: [
                // Kids Card
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.child_care, color: Colors.blue, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "Kids",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "$kids",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${kidsPercentage.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Instructors Card
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.school, color: Colors.orange, size: 32),
                        SizedBox(height: 8),
                        Text(
                          "Instructors",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "$instructors",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${instructorsPercentage.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 8),
            
            // Total users summary
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF02457A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Users",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF02457A),
                    ),
                  ),
                  Text(
                    "$totalUsers",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF02457A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminStatsCard extends StatelessWidget {
  final DateTime lastUpdated;
  final int totalPayments;
  final double totalProfit;

  const AdminStatsCard({
    super.key,
    required this.lastUpdated,
    required this.totalPayments,
    required this.totalProfit,
  });

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Color(0xFF02457A),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Color(0xFF02457A),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "Statistics Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF02457A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Payments",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "$totalPayments",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF02457A),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Average per Payment",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      totalPayments > 0 
                          ? "\$${(totalProfit / totalPayments).toStringAsFixed(2)}"
                          : "\$0.00",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.update,
                  color: Colors.grey[600],
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  "Last updated: ${_formatDateTime(lastUpdated)}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}