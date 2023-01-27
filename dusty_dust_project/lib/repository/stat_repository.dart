import 'package:dio/dio.dart';
import '../Model/step_model.dart';
import '../const/data.dart';

class StatRepository {
  static Future<List<StatModel>> fetchData() async {
    final response = await Dio().get(
        'http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst',
        queryParameters: {
          'serviceKey' : SERVICE_KEY,
          'returnType' : 'json',
          'numOfRows':30,
          'pageNo' : 1,
          'itemCode':'PM10',
          'dataGubun' : 'HOUR',
          'searchCondition':"WEEK",
        }
    );
    return response.data['response']['body']['items'].map<StatModel>(
          (item) => StatModel.fromJson(json: item),
    ).toList();
  }
}