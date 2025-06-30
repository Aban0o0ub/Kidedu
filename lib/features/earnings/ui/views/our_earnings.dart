import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection.dart';
import '../../../../core/widgets/appbar.dart';
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
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<EarningsCubit, EarningsState>(
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
      ),
    );
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
            Text(
              "Total Profit",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "\$${totalProfit.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "$totalPayments Payments",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
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