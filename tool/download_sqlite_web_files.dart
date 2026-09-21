import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

Future<void> main() async {
  print('Manually downloading SQLite web worker files...');

  final webAssetsDir = Directory('web/assets/packages/sqflite_common_ffi_web');
  if (!webAssetsDir.existsSync()) {
    webAssetsDir.createSync(recursive: true);
    print('Created directory: ${webAssetsDir.path}');
  }

  // Updated URLs for SQLite web worker files
  final fileUrls = [
    'https://raw.githubusercontent.com/tekartik/sqflite/develop/packages_web/sqflite_common_ffi_web/src/worker/sqflite_sw.js',
    'https://raw.githubusercontent.com/tekartik/sqflite/develop/packages_web/sqflite_common_ffi_web/src/worker/sqflite_sw.wasm',
  ];

  for (final url in fileUrls) {
    final filename = path.basename(url);
    final savePath = path.join(webAssetsDir.path, filename);

    try {
      print('Downloading $filename from $url...');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await File(savePath).writeAsBytes(response.bodyBytes);
        print('Successfully downloaded $filename to $savePath');
      } else {
        print('Failed to download $filename: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading $filename: $e');
    }
  }

  print('Done! SQLite web worker files have been downloaded.');
}
