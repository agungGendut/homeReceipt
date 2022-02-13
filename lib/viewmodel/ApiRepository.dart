import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resepkita/model/CategoryData.dart';
import 'package:resepkita/model/NewReceiptData.dart';
import 'package:resepkita/utils/ApiRoute.dart';

class ApiRepository{

  static Future<CategoryReceipt> getCategoryData() async {
    var client = http.Client();
    try {
      http.Response result = await client
          .get(Uri.parse(ApiRoutes.main + "api/categorys/recipes"), headers: {
        'Accept': 'application/json',
      });
      print("Category data: ${result.body}");
      client.close();
      return CategoryReceipt.fromJson(json.decode(result.body));
    } catch (e) {
      print(e);
      client.close();
      return CategoryReceipt(status: false, method: e.toString());
    }
  }

  static Future<NewReceipt> getNewReceiptData() async {
    var client = http.Client();
    try {
      http.Response result = await client
          .get(Uri.parse(ApiRoutes.main + "api/recipes"), headers: {
        'Accept': 'application/json',
      });
      print("Home main data: ${result.body}");
      client.close();
      return NewReceipt.fromJson(json.decode(result.body));
    } catch (e) {
      print(e);
      client.close();
      return NewReceipt(status: false, method: e.toString());
    }
  }


}