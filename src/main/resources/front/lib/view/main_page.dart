import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:servelyzer/bloc/main_bloc.dart';
import 'package:servelyzer/model/data_model.dart';
import 'package:servelyzer/style/my_colors.dart';
import 'package:servelyzer/style/route_transition_styles.dart';
import 'package:servelyzer/view/authorization_page.dart';
import 'package:servelyzer/widget/base_button.dart';
import 'package:servelyzer/widget/my_dialog.dart';

const double maxWight = 1010;
const double listWight = 600;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final mainBloc = MainBloc();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    mainBloc.data.listen((data) {
      setLoading(false);
    }, onError: (e) {
      setLoading(false);
    });
    mainBloc.dataFetcher("potapuff.example.com");
  }

  setLoading(bool value) {
    if (isLoading != value)
      setState(() {
        isLoading = value;
      });
  }

  showInformDialog(String text, {String button = "Ок"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog.information(
        content: text,
        button: button,
        onPositive: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  openAuthorizationPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        content: "Ви впевнені, що хочите вийти",
        negativeButton: "Ні",
        positiveButton: "Так",
        onPositive: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AuthorizationPage(),
                  transitionsBuilder: RouteTransitionStyles.defaultStyle));
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
                height: 35,
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
          StreamBuilder<DataModel>(
              stream: mainBloc.data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DataModel dataModel = snapshot.data;
                  return Expanded(
                    child: MediaQuery.of(context).size.width <= listWight
                        ? buildList(dataModel)
                        : buildRow(dataModel),
                  );
                } else if (snapshot.hasError) {
                  Exception exception = snapshot.error;
                  return Expanded(
                    child: Column(
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
                            mainBloc.dataFetcher("potapuff.example.com");},
                          height: 35,
                          width: 175,
                          isLoading: isLoading,
                          title: "Повторити",
                        ),
                      ],
                    ),
                  );
                } else {
                  return Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
              })
        ],
      ),
    );
  }

  ListView buildList(DataModel dataModel) {
    Cpu cpu = dataModel.cpu.first;
    Memory memory = dataModel.memory;
    String cpuString = "${cpu.system + cpu.user}%";
    String memoryString =
        (memory.active / 1024 / 1024).floor().toString() + "mb";
    return ListView(
      padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
      children: [
        MainPageItem(
          title: "Поточне використання CPU",
          content: cpuString,
        ),
        MainPageItem(
          title: "Поточне використання пам’яті",
          content: memoryString,
        ),
      ],
    );
  }

  Container buildRow(DataModel dataModel) {
    Cpu cpu = dataModel.cpu.first;
    Memory memory = dataModel.memory;
    String cpuString = "${cpu.system + cpu.user}%";
    String memoryString =
        (memory.active / 1024 / 1024).floor().toString() + "mb";
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 70),
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: maxWight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MainPageItem(
              title: "Поточне використання CPU",
              content: cpuString,
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: MainPageItem(
              title: "Поточне використання пам’яті",
              content: memoryString,
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

  const MainPageItem({
    Key key,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      height: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AutoSizeText(
              title,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            flex: 3,
            child: AutoSizeText(content,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 56,
                    fontWeight: FontWeight.w500)),
          )
        ],
      ),
    );
  }
}
