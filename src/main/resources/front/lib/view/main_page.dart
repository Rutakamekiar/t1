import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:servelyzer/bloc/main_bloc.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/model/hosts_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/base_text_field.dart';
import 'package:servelyzer/widget/my_dialog.dart';

const double maxWight = 1010;
const double listWight = 600;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final mainBloc = MainBloc();
  bool isLoadingData = false;

  @override
  void initState() {
    super.initState();
    mainBloc.data.listen((data) {
      setLoading(false);
    }, onError: (e) {
      setLoading(false);
    });
    mainBloc.getServers();
    // mainBloc.dataFetcher(
    //     "gor-tss",
    //     DateTime.now().subtract(Duration(hours: 1)).toUtc().toString(),
    //     DateTime.now().toUtc().toString());
  }

  setLoading(bool value) {
    if (isLoadingData != value)
      setState(() {
        isLoadingData = value;
      });
  }

  openAuthorizationPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        content: "Ви впевнені, що хочите вийти",
        negativeButton: "Ні",
        positiveButton: "Так",
        onPositive: () {
          Modular.to.pushReplacementNamed('/');
        },
      ),
    );
  }

  @override
  void dispose() {
    mainBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      body: Column(
        children: [
          Container(
            height: 75,
            alignment: Alignment.center,
            width: double.infinity,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              alignment: MediaQuery.of(context).size.width <= listWight
                  ? null
                  : Alignment.centerRight,
              constraints: BoxConstraints(maxWidth: maxWight),
              child: BaseButton(
                onPressed: openAuthorizationPage,
                height: 45,
                width: 175,
                title: "Вийти",
              ),
            ),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(232, 228, 228, 0.5),
                  offset: Offset(0, 14),
                  blurRadius: 23)
            ]),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: maxWight),
              child: ListView(
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    height: 240,
                    child: StreamBuilder<HostsModel>(
                        stream: mainBloc.servers,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            HostsModel hostsModel = snapshot.data;
                            return buildHostList(hostsModel);
                          } else if (snapshot.hasError) {
                            final exception = snapshot.error;
                            return buildError(exception);
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                  StreamBuilder<DataListModel>(
                      stream: mainBloc.data,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          DataListModel dataModel = snapshot.data;
                          return MediaQuery.of(context).size.width <= listWight
                              ? buildList(dataModel.data)
                              : buildRow(dataModel.data);
                        } else if (snapshot.hasError) {
                          final exception = snapshot.error;
                          return buildError(exception);
                        } else {
                          return isLoadingData ? Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Center(child: CircularProgressIndicator()),
                          ) : Container();
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildHostList(HostsModel hostsModel) {
    if (hostsModel.hosts != null && hostsModel.hosts.isNotEmpty) {
      setLoading(true);
      mainBloc.dataFetcher(
          hostsModel.hosts.first.host,
          DateTime.now().subtract(Duration(hours: 1)).toUtc().toString(),
          DateTime.now().toUtc().toString());
    }
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: MyColors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: hostsModel.hosts == null || hostsModel.hosts.isEmpty
                  ? Center(child: Text("Список хостів порожній"))
                  : ListView(
                      children: [],
                    ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: BaseTextField(
                    enable: !isLoadingData, label: "", errorText: "Введіть хост"),
              ),
              SizedBox(
                width: 30,
              ),
              BaseButton(
                isLoading: isLoadingData,
                width: 150,
                height: 37,
                title: "Додати",
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }

  Column buildError(Object exception) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          size: 50,
          color: MyColors.grey,
        ),
        SizedBox(
          height: 20,
        ),
        AutoSizeText("Помилка: $exception",
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500)),
        SizedBox(
          height: 20,
        ),
        BaseButton(
          onPressed: () {
            setLoading(true);
            mainBloc.dataFetcher("potapuff.example.com", "2020-09-29 18:45:52",
                "2020-10-29 20:45:52");
          },
          height: 35,
          width: 175,
          isLoading: isLoadingData,
          title: "Повторити",
        ),
      ],
    );
  }

  Widget buildList(List<DataModel> dataModels) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        MainPageItem(
          title: "Поточне використання CPU",
          child: LineChart(
            chartData(linesCpuData(dataModels)),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
        MainPageItem(
          title: "Поточне використання пам’яті",
          child: LineChart(
            chartData(linesMemoryData(dataModels)),
            swapAnimationDuration: const Duration(milliseconds: 250),
          ),
        ),
      ],
    );
  }

  LineChartData chartData(List<LineChartBarData> data) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (value) {
            String time = DateTime.fromMillisecondsSinceEpoch(value.floor())
                    .hour
                    .toString() +
                ":" +
                DateTime.fromMillisecondsSinceEpoch(value.floor())
                    .minute
                    .toString()
                    .padLeft(2, "0");
            return time;
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      lineBarsData: data,
    );
  }

  List<LineChartBarData> linesCpuData(List<DataModel> dataModels) {
    List<FlSpot> spots = List<FlSpot>();
    dataModels.forEach((dataModel) {
      Cpu cpu = dataModel.cpu.first;
      DateTime date = DateTime.parse(dataModel.at);
      double cpuTotal = cpu.system + cpu.user;
      spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), cpuTotal));
    });

    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
    ];
  }

  List<LineChartBarData> linesMemoryData(List<DataModel> dataModels) {
    List<FlSpot> spots = List<FlSpot>();
    dataModels.forEach((dataModel) {
      Memory memory = dataModel.memory;
      double memoryTotal = (memory.active / 1024 / 1024).floorToDouble();
      DateTime date = DateTime.parse(dataModel.at);
      spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), memoryTotal));
    });

    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
    ];
  }

  Container buildRow(List<DataModel> dataModels) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: maxWight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MainPageItem(
              title: "Поточне використання CPU",
              child: LineChart(
                chartData(linesCpuData(dataModels)),
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: MainPageItem(
              title: "Поточне використання пам’яті",
              child: LineChart(
                chartData(linesMemoryData(dataModels)),
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainPageItem extends StatelessWidget {
  final String title;
  final String content;
  final Widget child;

  const MainPageItem({
    Key key,
    this.title,
    this.content,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      height: 240,
      child: child,
    );
  }
}
