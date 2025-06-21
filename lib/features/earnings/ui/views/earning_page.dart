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
                            .emitGetInstructorEarnings();
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
