import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://db.ygoprodeck.com/api/v7/cardinfo.php';

  // Fetch all cards
  Future<List<dynamic>> fetchAllCards() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load cards');
    }
  }

  // Fetch card information by ID
  Future<Map<String, dynamic>> fetchCardById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl?id=$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'][0];
    } else {
      throw Exception('Failed to load card: $id');
    }
  }

  // Fetch card information by name
  Future<Map<String, dynamic>> fetchCardByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl?name=$name'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'][0];
    } else {
      throw Exception('Failed to load card: $name');
    }
  }

  // Fetch cards by archetype
  Future<List<dynamic>> fetchCardsByArchetype(String archetype) async {
    final response = await http.get(Uri.parse('$baseUrl?archetype=$archetype'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load archetype: $archetype');
    }
  }

  // Fetch cards with specific filters
  Future<List<dynamic>> fetchCardsWithFilters({String? level, String? attribute, String? sort}) async {
    String url = baseUrl;
    if (level != null) url += '?level=$level';
    if (attribute != null) url += '${url.contains('?') ? '&' : '?'}attribute=$attribute';
    if (sort != null) url += '${url.contains('?') ? '&' : '?'}sort=$sort';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load cards with filters');
    }
  }

  // Fetch cards by banlist and level
  Future<List<dynamic>> fetchCardsByBanlistAndLevel(String banlist, String level) async {
    final response = await http.get(Uri.parse('$baseUrl?banlist=$banlist&level=$level&sort=name'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load cards on $banlist banlist with level $level');
    }
  }
}
