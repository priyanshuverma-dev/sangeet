import 'dart:io';

import 'package:saavn/models/song_model.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SongNotifications {
  final _winNotifyPlugin = WindowsNotification(applicationId: "Saavn Music");

  Future<String> getImageBytes(String url, String id) async {
    final supportDir = await getTemporaryDirectory();
    final file = Directory('${supportDir.path}/$id.png');
    if (file.existsSync()) {
      return file.path;
    }
    final cl = http.Client();
    final resp = await cl.get(Uri.parse(url));
    final bytes = resp.bodyBytes;
    final imageFile = File("${supportDir.path}/$id.png");
    await imageFile.create();
    await imageFile.writeAsBytes(bytes);
    return imageFile.path;
  }

  Future trackChangedNotify({
    required SongModel song,
  }) async {
    await _winNotifyPlugin.clearNotificationHistory();
    final imageDir = await getImageBytes(song.image[1].url, song.id);
    NotificationMessage message = NotificationMessage.fromPluginTemplate(
      "notify_song",
      "Playing Now ${song.name}",
      "${song.album.name} - ${song.label}",
      image: imageDir,
    );
    await _winNotifyPlugin.showNotificationPluginTemplate(message);
  }

  Future playPausekNotify({
    required SongModel song,
    required String state,
  }) async {
    await _winNotifyPlugin.clearNotificationHistory();
    final imageDir = await getImageBytes(song.image[1].url, song.id);
    NotificationMessage message = NotificationMessage.fromPluginTemplate(
      "play_pause_song",
      "$state ${song.name}",
      "${song.label} - ${song.album.name}",
      image: imageDir,
    );
    await _winNotifyPlugin.showNotificationPluginTemplate(message);
  }
}
