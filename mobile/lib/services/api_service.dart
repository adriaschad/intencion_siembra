import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/planting_form.dart';
import '../models/sampling_form.dart';
import '../models/replanting_form.dart';
import '../models/variety.dart';

class ApiService {
  // Update this URL to match your backend
  static const String baseUrl = 'http://10.0.2.2:5000/api'; // Android emulator
  // For iOS simulator: 'http://localhost:5000/api'
  // For real device: 'http://YOUR_IP:5000/api'

  // Get all varieties
  Future<List<Variety>> getVarieties() async {
    final response = await http.get(Uri.parse('$baseUrl/varieties'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Variety.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load varieties');
    }
  }

  // Get planting forms
  Future<List<PlantingForm>> getPlantingForms({String? producerId}) async {
    var uri = Uri.parse('$baseUrl/planting-forms');
    if (producerId != null) {
      uri = uri.replace(queryParameters: {'producerId': producerId});
    }
    
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PlantingForm.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load planting forms');
    }
  }

  // Confirm harvest date
  Future<PlantingForm> confirmHarvestDate(String formId, DateTime date) async {
    final response = await http.put(
      Uri.parse('$baseUrl/planting-forms/$formId/confirm-harvest'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'confirmedHarvestDate': date.toIso8601String(),
      }),
    );
    
    if (response.statusCode == 200) {
      return PlantingForm.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to confirm harvest date');
    }
  }

  // Create sampling form with photos
  Future<SamplingForm> createSamplingForm(SamplingForm form, List<String> photoPaths) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/sampling-forms'),
    );

    // Add form fields
    request.fields['plantingForm'] = form.plantingForm;
    request.fields['farmName'] = form.farmName;
    request.fields['lotNumber'] = form.lotNumber;
    request.fields['valveNumber'] = form.valveNumber ?? '';
    request.fields['variety'] = form.variety;
    request.fields['producerId'] = form.producerId;
    request.fields['observations'] = form.observations ?? '';
    request.fields['brixReadings'] = json.encode(
      form.brixReadings.map((r) => {'value': r.value, 'location': r.location}).toList()
    );

    // Add photos
    for (var path in photoPaths) {
      request.files.add(await http.MultipartFile.fromPath('photos', path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 201) {
      return SamplingForm.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create sampling form: ${response.body}');
    }
  }

  // Get sampling forms
  Future<List<SamplingForm>> getSamplingForms({String? producerId}) async {
    var uri = Uri.parse('$baseUrl/sampling-forms');
    if (producerId != null) {
      uri = uri.replace(queryParameters: {'producerId': producerId});
    }
    
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SamplingForm.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sampling forms');
    }
  }

  // Create replanting form
  Future<ReplantingForm> createReplantingForm(ReplantingForm form) async {
    final response = await http.post(
      Uri.parse('$baseUrl/replanting-forms'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(form.toJson()),
    );
    
    if (response.statusCode == 201) {
      return ReplantingForm.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create replanting form: ${response.body}');
    }
  }

  // Get replanting forms
  Future<List<ReplantingForm>> getReplantingForms({String? producerId}) async {
    var uri = Uri.parse('$baseUrl/replanting-forms');
    if (producerId != null) {
      uri = uri.replace(queryParameters: {'producerId': producerId});
    }
    
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ReplantingForm.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load replanting forms');
    }
  }
}
