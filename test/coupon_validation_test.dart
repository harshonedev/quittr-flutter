import 'package:flutter_test/flutter_test.dart';

// Coupon validation logic extracted for testing
bool validateCoupon(String coupon) {
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

void main() {
  group('Coupon Validation Tests', () {
    test('validates correct coupon G-5218943999867', () {
      expect(validateCoupon('G-5218943999867'), true);
    });

    test('validates coupon with different format', () {
      expect(validateCoupon('SAVE5218943999867'), true);
    });

    test('validates coupon with only numbers', () {
      expect(validateCoupon('5218943999867'), true);
    });

    test('rejects coupon with wrong sum', () {
      expect(validateCoupon('1234567890'), false);
    });

    test('rejects empty coupon', () {
      expect(validateCoupon(''), false);
    });

    test('rejects coupon with no numbers', () {
      expect(validateCoupon('ABCDEF'), false);
    });

    test('validates coupon with sum exactly 80', () {
      // 9+9+9+9+9+9+9+9+8 = 72 + 8 = 80
      expect(validateCoupon('999999998'), true);

      // 8+8+8+8+8+8+8+8+8+8 = 80
      expect(validateCoupon('8888888888'), true);

      // Wrong sums should fail
      expect(validateCoupon('1234567890'), false); // Sum = 45
      expect(validateCoupon('9999999999'), false); // Sum = 90
    });

    test('verifies the example coupon calculation', () {
      final coupon = 'G-5218943999867';
      final numbers = coupon.replaceAll(RegExp(r'[^0-9]'), '');
      print('Numbers: $numbers'); // Should be: 5218943999867

      int sum = 0;
      for (int i = 0; i < numbers.length; i++) {
        sum += int.parse(numbers[i]);
      }
      print('Sum: $sum'); // Let's see what this actually sums to

      // 5+2+1+8+9+4+3+9+9+9+8+6+7 = ?
      // Let me calculate: 5+2+1+8+9+4+3+9+9+9+8+6+7 = 80
      expect(sum, 80);
    });
  });
}
