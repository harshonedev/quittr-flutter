import 'package:web/web.dart' as web;

void launchPaymentUrl(String url) {
  web.window.location.href = url;
}
