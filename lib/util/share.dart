import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class ShareAPI {
  // share to social media
  static Future<void> share(String url, String description) async {
    // read image
    final parseUrl = Uri.parse(url);
    final response = await http.get(parseUrl);
    final bytes = response.bodyBytes;

    // store image in temp folder
    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.png';
    File(path).writeAsBytesSync(bytes);

    // share file
    await Share.shareFiles([path], text: description);
  }

  // static Future download(String url) async {
  //   // read image
  //   final parseUrl = Uri.parse(url);
  //   final response = await http.get(parseUrl);
  //   final bytes = response.bodyBytes;

  //   // store image in temp folder
  //   final temp = await ExtStorage.getExternalStoragePublicDirectory(
  //     ExtStorage.DIRECTORY_DOWNLOADS,
  //   );

  //   final path = '${temp.path}/download.png';
  //   File(path).writeAsBytesSync(bytes);
  // }
}
