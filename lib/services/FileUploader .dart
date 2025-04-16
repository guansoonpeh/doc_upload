
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

class FileUploader  {

  static Future <Map<String, dynamic>> uploadFile({
    required File file,
    required String fName,
    required String directory,
  }) async {

    final uri = Uri.parse('https://focsonmyfinger.com/MyInsurApi/api/FileServices/upload');


    final request = http.MultipartRequest('POST', uri);

    // Attach file
    request.files.add( await http.MultipartFile.fromPath( 'file', file.path, filename: fName )  );
    request.fields['fName'] = fName;
    request.fields['directory'] = directory;

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        return {
          'success': response.statusCode == 200,
          'statusCode': response.statusCode,
          'message': "Upload successful",
        };
      } else {
        return {
          'success': response.statusCode == 200,
          'statusCode': response.statusCode,
          'message': "Failed to upload",
        };
      }
    } catch (e) {
        log('Error uploading file: $e');
        return {
          'success': false,
          'statusCode': 400,
          'message':  e,
        };
    }
  }

}