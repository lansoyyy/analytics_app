import 'dart:convert';

import 'package:analytics_app/models/sales_model.dart';
import 'package:analytics_app/models/trend_model.dart';
import 'package:analytics_app/screens/chat_page.dart';
import 'package:analytics_app/screens/login_screen.dart';
import 'package:analytics_app/screens/messages_page.dart';
import 'package:analytics_app/utils/colors.dart';
import 'package:analytics_app/utils/const.dart';
import 'package:analytics_app/widgets/logout_widget.dart';
import 'package:analytics_app/widgets/text_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var dio = Dio();

  List<TrendModel> trends = [];

  bool hasLoaded = false;

  String title = '';
  getTrend(String topic) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          ],
        ));
      },
    );
    var response = await dio.request(
      'https://serpapi.com/search.json?engine=google_trends&q=$topic&data_type=TIMESERIES&api_key=$apiKey',
      options: Options(
        method: 'GET',
      ),
    );

    if (response.statusCode == 200) {
      var timelineData = response.data['interest_over_time']['timeline_data'];

      setState(() {
        trends = List<TrendModel>.from(
          timelineData.map((item) => TrendModel.fromJson(item)),
        );

        chartData.clear();
      });

      for (int i = 0; i < trends.length; i++) {
        setState(() {
          chartData.add(SalesData(
              DateTime.fromMicrosecondsSinceEpoch(
                  int.parse(trends[i].timestamp!)),
              double.parse(trends[i].values!.first.value!)));
        });
      }

      print(trends);
    } else {
      print(response.statusMessage);
    }
    Navigator.pop(context);
  }

  final search = TextEditingController();

  final List<SalesData> chartData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primary,
        title: TextWidget(
          text: 'HOME',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatPage()));
            },
            icon: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              logout(context, const LoginScreen());
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      // Clear the search field
                      search.clear();
                    },
                  ),
                ),
                onSubmitted: (value) {
                  getTrend(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
              ),
              child: TextWidget(
                text: 'Topic: ${search.text}',
                fontSize: 32,
                fontFamily: 'Bold',
                color: Colors.black,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
              ),
              child: TextWidget(
                text: DateFormat('EEE, d MMM').format(DateTime.now()),
                fontSize: 18,
                fontFamily: 'Bold',
                color: Colors.blue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Card(
                elevation: 3,
                child: SizedBox(
                  width: double.infinity,
                  height: 350,
                  child: SfCartesianChart(
                      primaryXAxis: const DateTimeAxis(),
                      series: <CartesianSeries>[
                        // Renders line chart
                        LineSeries<SalesData, DateTime>(
                            dataSource: chartData,
                            xValueMapper: (SalesData sales, _) => sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales)
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
