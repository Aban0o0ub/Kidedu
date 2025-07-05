import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loginpage/features/sign_up/ui/widgets/custom_button.dart';
import '../../../../core/injection/injection.dart';
import '../../../add_course/data/models/Course_Model.dart';
import '../../../home/logic/cubit/course_category_cubit.dart';
import '../../../login/logic/cubit/my_cubit.dart';
import '../../../../core/routing/routes.dart';
import '../../../cart/logic/cubit/cart_cubit.dart';
import '../../../home/ui/views/home_page.dart'; 

class CourseActionButtons extends StatefulWidget {
  final VoidCallback onUpdateCourse;
  final VoidCallback onDeleteCourse;
  final String courseId;
  final CourseData courseData;

  const CourseActionButtons({
    super.key,
    required this.onUpdateCourse,
    required this.onDeleteCourse,
    required this.courseId,
    required this.courseData,
  });

  @override
  State<CourseActionButtons> createState() => _CourseActionButtonsState();
}

class _CourseActionButtonsState extends State<CourseActionButtons> {
  bool isLoading = true;
  bool isPurchased = false;
  bool _isLocalLoading = false;
  late CourseCategoryCubit courseCategoryCubit;

  @override
  void initState() {
    super.initState();
    courseCategoryCubit = getIt<CourseCategoryCubit>();
    _checkPurchaseStatus();
  }

  Future<void> _checkPurchaseStatus() async {
    try {
      // استخدم الدالة الجديدة التي ترجع البيانات
      final List<CourseData> purchasedCourses =
          await courseCategoryCubit.getKidCoursesData();

      // فحص إذا كان الكورس الحالي موجود في القائمة
      final isCoursePurchased =
          purchasedCourses.any((course) => course.id == widget.courseId);

      if (mounted) {
        setState(() {
          isPurchased = isCoursePurchased;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error checking purchase status: $e');
      if (mounted) {
        setState(() {
          isPurchased = false;
          isLoading = false;
        });
      }
    }
  }

  // دالة لإعادة فحص حالة الشراء
  Future<void> _refreshPurchaseStatus() async {
    await _checkPurchaseStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoleCubit, String?>(
      builder: (context, userRole) {
        if (userRole == 'instructor') {
          // Show Update and Delete buttons for instructor
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    context.push(Routes.addCoursePage,
                        extra: widget.courseData);
                  },
                  text: "Update Course",
                  width: double.infinity,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: widget.onDeleteCourse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (userRole == 'kid') {
          // إذا كان الكورس متشري، لا تظهر أي زرار أو اظهر رسالة
          if (isPurchased) {
            return Container(
              width: 384,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Already Purchased",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // إذا كان جاري التحميل، اظهر loading
          if (isLoading) {
            return Container(
              width: 384,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Show Add to cart button with cart logic for kid
          return BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              // إيقاف الـ loading عند انتهاء العملية
              if (state is AddCartSuccess || state is AddCartFailure) {
                if (mounted) {
                  setState(() {
                    _isLocalLoading = false;
                  });

                  // إعادة فحص حالة الشراء بعد إضافة ناجحة للسلة
                  if (state is AddCartSuccess) {
                    _refreshPurchaseStatus();
                  }
                }
              }

              // عرض رسالة خطأ إذا كان الكورس متضاف مسبقاً
              if (state is AddCartFailure && state.error.contains('already')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Course already in cart or purchased'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
                // إعادة فحص حالة الشراء في حالة الخطأ أيضاً
                _refreshPurchaseStatus();
              }
            },
            buildWhen: (previous, current) =>
                current is CartStatusChanged || current is CartInitial,
            builder: (context, state) {
              final cartCubit = context.read<CartCubit>();
              final isAddedToCart =
                  cartCubit.isCourseAddedToCart(widget.courseId);

              return SizedBox(
                width: 384,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLocalLoading
                      ? null
                      : () async {
                          if (isAddedToCart) {
                            TabControllerHelper.selectedIndexNotifier.value = 4;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            });
                          } else {
                            setState(() {
                              _isLocalLoading = true;
                            });

                            context
                                .read<CartCubit>()
                                .emitAddNewCart(widget.courseId);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isAddedToCart ? Colors.white : Colors.blue,
                    side: isAddedToCart
                        ? const BorderSide(color: Colors.blue)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: _isLocalLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          isAddedToCart ? "Go to cart" : "Add to cart",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: isAddedToCart ? Colors.blue : Colors.white,
                          ),
                        ),
                ),
              );
            },
          );
        }

        return CustomButton(
          onPressed: () {},
          text: "Add to cart",
          width: 384,
        );
      },
    );
  }
}
