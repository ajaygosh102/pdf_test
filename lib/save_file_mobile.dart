///Dart import
import 'dart:io';

///Package imports
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

///To save the pdf file in the device
class FileSaveHelper {
  static const MethodChannel _platformCall = MethodChannel('launchFile');

  ///To save the pdf file in the device
  static Future<String> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    Map<String, String> argument;
    String path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final Directory directory = await getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    final File file =
        File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      print('1');
       argument = <String, String>{
        'file_path': '$path/$fileName'
      };
      try {
        //ignore: unused_local_variable
        final Future<Map<String, String>> result =
            _platformCall.invokeMethod('viewPdf', argument);
      } catch (e) {
        throw Exception(e);
      }

    } else if (Platform.isWindows) {
      await Process.run('start', ['$path\\$fileName'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', ['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', ['$path/$fileName'], runInShell: true);
    }
    print('2');
    return argument['file_path'];
  }
}
