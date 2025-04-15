import 'dart:convert';

import 'package:ristey/common/api_routes.dart';
import 'package:ristey/screens/audio_clip/model/audio_clip_model.dart';
import 'package:http/http.dart' as http;
class AudioClipService {

  Future<PaginatedAudioClip?> fetchAudioClips(String email,{int page = 1}) async {
  try {
    final response = await http.get(
      Uri.parse('$postAudioClipUrl?email=$email&page=$page&limit=10'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final paginatedClips = PaginatedAudioClip.fromJson(jsonData);

      return paginatedClips;
    } else {
      print('Failed to fetch audio clips. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching audio clips: $e');
    return null;
  }
}
}