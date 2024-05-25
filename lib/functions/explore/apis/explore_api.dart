import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:savaan/core/constants.dart';
import 'package:savaan/core/core.dart';
import 'package:savaan/models/song_model.dart';
import 'package:http/http.dart' as http;

final exploreAPIProvider = Provider((ref) {
  return ExploreAPI();
});

abstract class IExploreAPI {
  FutureEither<List<SongModel>> fetchInitData();
  FutureEither<List<SongModel>> fetchSearchData({required String query});
}

class ExploreAPI extends IExploreAPI {
  @override
  FutureEither<List<SongModel>> fetchInitData() async {
    try {
      final uri = Uri.https(
          Constants.serverUrl, 'api/search/songs', {"query": "Bollywood"});
      final res = await http.get(uri);
      if (res.statusCode != 200) throw Error();

      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      // Extract the list of songs from the Map
      List<dynamic> songsObj = jsonMap['data']['songs']['results'];
      log(songsObj.toString());
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
  FutureEither<List<SongModel>> fetchSearchData({required String query}) async {
    try {
      final uri =
          Uri.https(Constants.serverUrl, 'api/search/songs', {"query": query});
      final res = await http.get(uri);
      if (res.statusCode != 200) throw Error();

      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      // Extract the list of songs from the Map
      List<dynamic> songsObj = jsonMap['data']['songs']['results'];
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
