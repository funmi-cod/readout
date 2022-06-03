import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'package:path/path.dart';

class PDFApi {
  static Future<File> loadFromNetwork(String? url) async {
    final response = await http.get(Uri.parse(url!));
    final bytes = response.bodyBytes;

    return _storeFile(url, bytes);
  }

  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // picks only pdf file
    );

    // If user don't pick a file
    if (result == null) return null;
    // file is converted to an object
    return File(result.paths.first!); // selects only a file
  }

  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    // file path
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}