import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:savaan/core/constants.dart';
import 'package:savaan/core/core.dart';
import 'package:http/http.dart' as http;
import 'package:savaan/models/artists/sub_artist_model.dart';

final artistAPIProvider = Provider((ref) {
  return ArtistAPI();
});

abstract class IArtistAPI {
  FutureEither<List<SubArtistModel>> fetchInitArtists();
  FutureEither<List<SubArtistModel>> fetchSearchData({required String query});
}

class ArtistAPI extends IArtistAPI {
  @override
  FutureEither<List<SubArtistModel>> fetchInitArtists() async {
    try {
      final uri = Uri.https(Constants.serverUrl, 'api/search/artists',
          {"query": "Popular", "limit": "12"});

      final res = await http.get(uri);
      if (res.statusCode != 200) throw Error();

      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      // Extract the list of Artists from the Map
      List<dynamic> artistsObj = jsonMap['data']['results'];

      List<SubArtistModel> artists = artistsObj.map((artist) {
        return SubArtistModel.fromMap(artist);
      }).toList();

      return right(artists);
    } on http.ClientException catch (e, st) {
      log(e.toString());

      return left(Failure(e.message, st));
    } catch (e, st) {
      log(e.toString());

      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<List<SubArtistModel>> fetchSearchData(
      {required String query}) async {
    try {
      final uri = Uri.https(
          Constants.serverUrl, 'api/search/Artists', {"query": query});
      final res = await http.get(uri);
      if (res.statusCode != 200) throw Error();

      Map<String, dynamic> jsonMap = jsonDecode(res.body);
      // Extract the list of Artists from the Map
      List<dynamic> artistsObj = jsonMap['data']['artists']['results'];
      List<SubArtistModel> artists =
          artistsObj.map((artist) => SubArtistModel.fromMap(artist)).toList();
      return right(artists);
    } on http.ClientException catch (e, st) {
      log(e.toString());
      return left(Failure(e.message, st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
