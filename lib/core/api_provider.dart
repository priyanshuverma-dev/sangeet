import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangeet_api/sangeet_api.dart';

final sangeetAPIProvider = Provider<SangeetAPI>((ref) {
  return SangeetAPI();
});