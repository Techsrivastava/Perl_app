import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FeeTemplateService {
  static const String _storageKey = 'fee_templates';

  /// Get all templates
  static Future<List<Map<String, dynamic>>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }

  /// Save a template
  static Future<void> saveTemplate(Map<String, dynamic> template) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> templates = await getTemplates();

    // Check if updating existing
    int index = templates.indexWhere((t) => t['id'] == template['id']);
    if (index >= 0) {
      templates[index] = template;
    } else {
      templates.add(template);
    }

    await prefs.setString(_storageKey, jsonEncode(templates));
  }

  /// Delete a template
  static Future<void> deleteTemplate(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> templates = await getTemplates();

    templates.removeWhere((t) => t['id'] == id);

    await prefs.setString(_storageKey, jsonEncode(templates));
  }
}
