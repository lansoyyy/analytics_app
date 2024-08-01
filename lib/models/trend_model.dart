// To parse this JSON data, do
//
//     final trendModel = trendModelFromJson(jsonString);

import 'dart:convert';

TrendModel trendModelFromJson(String str) =>
    TrendModel.fromJson(json.decode(str));

String trendModelToJson(TrendModel data) => json.encode(data.toJson());

class TrendModel {
  String? date;
  String? timestamp;
  List<Value>? values;

  TrendModel({
    this.date,
    this.timestamp,
    this.values,
  });

  factory TrendModel.fromJson(Map<String, dynamic> json) => TrendModel(
        date: json["date"],
        timestamp: json["timestamp"],
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "timestamp": timestamp,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Value {
  String? query;
  String? value;
  int? extractedValue;

  Value({
    this.query,
    this.value,
    this.extractedValue,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        query: json["query"],
        value: json["value"],
        extractedValue: json["extracted_value"],
      );

  Map<String, dynamic> toJson() => {
        "query": query,
        "value": value,
        "extracted_value": extractedValue,
      };
}
