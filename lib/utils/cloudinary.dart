//! KEY Cs0WPfON4Zq0cY4im1AjTfh1uNk
// !CLOUDINARY_URL=cloudinary://<your_api_key>:<your_api_secret>@dqcziznrd

import 'dart:developer';

import 'package:cloudinary_url_gen/cloudinary.dart';

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

final API_KEY = "888368919533969";
final API_SECRET = "Cs0WPfON4Zq0cY4im1AjTfh1uNk";
final CLOUD_NAME = "dqcziznrd";

var cloudinary = Cloudinary.fromStringUrl(
  'cloudinary://$API_KEY:$API_SECRET@$CLOUD_NAME',
);

class CloudinaryService {
  Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$CLOUD_NAME/image/upload',
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = 'restockly';

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );
    final response = await request.send();

    final body = await response.stream.bytesToString();

    log(response.statusCode.toString());
    log(body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(body);

      return responseData['secure_url'];
    }

    return null;
  }
}
