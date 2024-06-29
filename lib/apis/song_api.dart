import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sangeet/core/constants.dart';
import 'package:sangeet/core/core.dart';
import 'package:sangeet/models/song_model.dart';
import 'package:http/http.dart' as http;

final songAPIProvider = Provider((ref) {
  return SongAPI();
});

abstract class ISongAPI {
  FutureEither<List<SongModel>> fetchInitData();
  FutureEither<List<SongModel>> fetchSearchData({required String query});

  FutureEither<List<SongModel>> fetchSongRecommedationData(
      {required String id});
}

class SongAPI extends ISongAPI {
  @override
  FutureEither<List<SongModel>> fetchInitData() async {
    try {
      final uri = Uri.https(Constants.serverUrl, 'api/search/songs',
          {"query": "Bollywood", "limit": "24"});

      final res = await http.get(uri);
      if (res.statusCode != 200) throw Error();

      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      // Extract the list of songs from the Map
      List<dynamic> songsObj = jsonMap['data']['results'];

      List<SongModel> songs = songsObj.map((song) {
        return SongModel.fromMap(song);
      }).toList();

      return right(songs);
    } on http.ClientException catch (e, st) {
      log(e.toString());

      return left(Failure(e.message, st));
    } catch (e, st) {
      log(e.toString());

      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<List<SongModel>> fetchSearchData({required String query}) async {
    try {
      final uri = Uri.https(Constants.serverUrl, 'api/search/songs', {
        "query": query,
        "limit": "24",
      });
      final res = await http.get(uri);
      if (res.statusCode != 200) throw Error();

      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      // Extract the list of songs from the Map
      List<dynamic> songsObj = jsonMap['data']['results'];
      List<SongModel> songs =
          songsObj.map((song) => SongModel.fromMap(song)).toList();
      return right(songs);
    } on http.ClientException catch (e, st) {
      log(e.toString());
      return left(Failure(e.message, st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<List<SongModel>> fetchSongRecommedationData(
      {required String id}) async {
    try {
      final uri = Uri.https(
          Constants.serverUrl, 'api/songs/$id/suggestions', {"limit": "32"});

      final res = await http.get(uri);
      if (res.statusCode != 200) throw Error();

      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      // Extract the list of songs from the Map
      List<dynamic> songsObj = jsonMap['data'];
      List<SongModel> songs =
          songsObj.map((song) => SongModel.fromMap(song)).toList();
      return right(songs);
    } on http.ClientException catch (e, st) {
      log(e.toString());
      return left(Failure(e.message, st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
