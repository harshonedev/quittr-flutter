import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quittr/features/paywall/presentation/bloc/paywall_bloc.dart';

class QuizNameAgeScreen extends StatefulWidget {
  final Map quizAnswers;

  const QuizNameAgeScreen({
    super.key,
    required this.quizAnswers,
  });

  @override
  State<QuizNameAgeScreen> createState() => _QuizNameAgeScreenState();
}

class _QuizNameAgeScreenState extends State<QuizNameAgeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _couponController = TextEditingController();
  bool _isValidatingCoupon = false;
  bool _couponApplied = false;

  bool _validateCoupon(String coupon) {
    // Remove any non-digit characters and extract only numbers
    final numbers = coupon.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbers.isEmpty) return false;

    // Sum all digits
    int sum = 0;
    for (int i = 0; i < numbers.length; i++) {
      sum += int.parse(numbers[i]);
    }

    return sum == 80;
  }

  Future<void> _applyCoupon() async {
    final couponCode = _couponController.text.trim();
    if (couponCode.isEmpty) return;

    setState(() {
      _isValidatingCoupon = true;
    });

    try {
      if (_validateCoupon(couponCode)) {
        // Valid coupon - create annual subscription
        _createAnnualSubscription(couponCode);
      } else {
        setState(() {
          _isValidatingCoupon = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid coupon code. Please check and try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isValidatingCoupon = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error applying coupon. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _createAnnualSubscription(String couponCode) {
    context.read<SubscriptionBloc>().add(PurchaseByCouponEvent(couponCode));
  }

  void _onContinue() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userInfo = {
        ...widget.quizAnswers,
        'name': _nameController.text,
        'age': _ageController.text,
        'couponApplied': _couponApplied,
        'couponCode': _couponApplied ? _couponController.text.trim() : null,
      };

      if (_isValidatingCoupon) return;

      if (_couponController.text.isNotEmpty && !_couponApplied) {
        // If there's a coupon code entered but not yet applied, prompt user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please apply the coupon code before continuing.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      context.push('/onboard-quiz/calculating-quiz-result', extra: userInfo);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<SubscriptionBloc, IAPState>(
          listener: (context, state) {
            if (state is SubscribedState) {
              // Navigate to home or next screen after successful subscription
              setState(() {
                _couponApplied = true;
                _isValidatingCoupon = false;
              });

              // Show success message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Coupon applied! You now have free access to the annual plan!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            } else if (state is IAPErrorState) {
              setState(() {
                _isValidatingCoupon = false;
              });
              // Show error message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error applying coupon. Please try again.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LinearProgressIndicator(value: 1.0),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Almost there!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tell us about yourself',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          filled: true,
                          prefixIcon: const Icon(CupertinoIcons.person),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 55,
                            minHeight: 24,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Your Age',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          filled: true,
                          prefixIcon: const Icon(CupertinoIcons.calendar),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 55,
                            minHeight: 24,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 13 || age > 120) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Coupon Code Field
                      TextFormField(
                        controller: _couponController,
                        decoration: InputDecoration(
                          labelText: 'Coupon Code (Optional)',
                          hintText: 'Enter coupon code for free annual access',
                          helperText:
                              'Valid coupons unlock free annual subscription',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            _couponApplied
                                ? CupertinoIcons.checkmark_circle_fill
                                : CupertinoIcons.tag,
                            color: _couponApplied ? Colors.green : null,
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 55,
                            minHeight: 24,
                          ),
                          suffixIcon: _couponController.text.isNotEmpty &&
                                  !_couponApplied
                              ? IconButton(
                                  icon: _isValidatingCoupon
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : Icon(CupertinoIcons.arrow_right_circle),
                                  onPressed:
                                      _isValidatingCoupon ? null : _applyCoupon,
                                )
                              : null,
                        ),
                        enabled: !_couponApplied,
                        onChanged: (value) {
                          setState(() {}); // Rebuild to show/hide apply button
                        },
                      ),
                      if (_couponApplied)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Coupon applied! Free annual access unlocked',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _onContinue,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Continue'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SvgPicture.asset(
                  'assets/illustrations/quiz_screen.svg',
                  width: MediaQuery.sizeOf(context).width,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
