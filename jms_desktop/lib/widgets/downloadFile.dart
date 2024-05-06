import 'package:url_launcher/url_launcher.dart';

class DownloadFile {
  DownloadFile();

  void downloadFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
