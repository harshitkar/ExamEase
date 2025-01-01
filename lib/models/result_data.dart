import 'dart:convert';
import 'package:ocr_app/Holders/data_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultData {
  int? resultId; // Nullable to allow it to be generated during save
  int userId;
  int testId;
  int result;
  DateTime submittedAt;

  ResultData({
    this.resultId,
    required this.userId,
    required this.testId,
    required this.result,
    DateTime? submittedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'resultId': resultId,
      'userId': userId,
      'testId': testId,
      'result': result,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      resultId: json['resultId'],
      userId: json['userId'],
      testId: json['testId'],
      result: json['result'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }

  Future<void> saveResult() async {
    final prefs = await SharedPreferences.getInstance();

    // Get all results
    List<String> allResults = prefs.getStringList('results') ?? [];

    // Determine the new sequential ID
    if (allResults.isEmpty) {
      resultId = 1; // Start from 1 if the list is empty
    } else {
      String lastResultIdStr = allResults.last;
      int lastResultId = int.tryParse(lastResultIdStr) ?? 0;
      resultId = lastResultId + 1; // Increment from the last ID
    }

    // Save the new result
    allResults.add(resultId.toString());
    prefs.setStringList('results', allResults);
    prefs.setString(resultId.toString(), jsonEncode(toJson()));
  }

  Future<int> getResult() async {
    final prefs = await SharedPreferences.getInstance();
    final resultsJson = prefs.getStringList('results') ?? [];
    for (var resultIdStr in resultsJson) {
      final resultJson = prefs.getString(resultIdStr);
      if (resultJson != null) {
        final result = ResultData.fromJson(jsonDecode(resultJson));
        if (result.testId == testId && result.userId == userId) {
          return result.result;
        }
      }
    }
    return -1;
  }

  Future<void> deleteResult() async {
    final prefs = await SharedPreferences.getInstance();
    final results = prefs.getStringList('results') ?? [];
    results.removeWhere((resultIdStr) {
      final resultJson = prefs.getString(resultIdStr);
      if (resultJson != null) {
        final result = ResultData.fromJson(jsonDecode(resultJson));
        return result.testId == testId && result.userId == userId;
      }
      return false;
    });
    await prefs.setStringList('results', results);
  }

  static Future<List<ResultData>> getAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    final resultsJson = prefs.getStringList('results') ?? [];
    return resultsJson.map((resultIdStr) {
      final resultJson = prefs.getString(resultIdStr);
      if (resultJson != null) {
        return ResultData.fromJson(jsonDecode(resultJson));
      }
      throw Exception("Invalid result data");
    }).toList();
  }
}