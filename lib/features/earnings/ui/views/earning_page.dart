import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/core/injection/injection.dart';
import 'package:loginpage/core/widgets/appbar.dart';
import '../../logic/cubit/earnings_cubit.dart';
import '../widgets/balance_Card.dart';
import '../widgets/earnings_course_card.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  late EarningsCubit earningsCubit;

  @override
  void initState() {
    super.initState();
    earningsCubit = getIt<EarningsCubit>();
    earningsCubit.emitGetInstructorEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: earningsCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Earnings",
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<EarningsCubit, EarningsState>(
          builder: (context, state) {
            if (state is InstructorEarningsLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF02457A),
                ),
              );
            } else if (state is InstructorEarningsFailure) {
              // فحص إذا كان الخطأ متعلق بعدم وجود earnings
              bool isNoEarnings = state.error.contains('NO_EARNINGS_YET') ||
                  state.error.contains('Cast to Number failed') ||
                  state.error.contains('NaN') ||
                  state.error.toLowerCase().contains('no earnings');

              if (isNoEarnings) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 80,
                        color: Color(0xFF02457A).withOpacity(0.7),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "No Earnings Yet",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF02457A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "You haven't earned anything yet.\nStart by creating and selling courses!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your earnings will appear here once students\npurchase your courses.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              context
                                  .read<EarningsCubit>()
                                  .emitGetInstructorEarnings();
                            },
                            icon: Icon(Icons.refresh,
                                color: Colors.white, size: 20),
                            label: Text("Refresh",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF02457A),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              // Navigate to add course page
                              // context.push(Routes.addCoursePage);
                            },
                            icon: Icon(Icons.add_circle_outline,
                                color: Color(0xFF02457A), size: 20),
                            label: Text(
                              "Create Course",
                              style: TextStyle(color: Color(0xFF02457A)),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0xFF02457A)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              // في حالة أخطاء أخرى
              bool isNetworkError =
                  state.error.toLowerCase().contains('network') ||
                      state.error.toLowerCase().contains('connection') ||
                      state.error.toLowerCase().contains('timeout');

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isNetworkError ? Icons.wifi_off : Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      isNetworkError
                          ? "Connection Problem"
                          : "Failed to Load Earnings",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      isNetworkError
                          ? "Please check your internet connection and try again"
                          : "There was an issue loading your earnings data",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<EarningsCubit>()
                            .emitGetInstructorEarnings();
                      },
                      icon: Icon(Icons.refresh, color: Colors.white, size: 20),
                      label: Text("Try Again",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF02457A),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is InstructorEarningsSuccess) {
              final earningsData = state.earningsData.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: BalanceCard(
                            balance: earningsData.totalEarnings.toDouble()),
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: earningsData.courses.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final course = earningsData.courses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CourseEarningsCard(course: course),
                        );
                      },
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
