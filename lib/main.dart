import 'package:flutter/services.dart';
import 'package:flipclockandtimer/FlipClock.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    runApp((const Home()));
  });
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _timeString;
  String intialHour = "00";

  String intialMinutes = "00";

  @override
  void initState() {
    var now = DateTime.now();
    intialHour =
        now.hour.toString().length == 1 ? "0${now.hour}" : now.hour.toString();

    intialMinutes = now.minute.toString().length == 1
        ? "0${now.minute}"
        : now.minute.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: Scaffold(
          body: Container(
            width: double.infinity,
            child: OrientationBuilder(
              builder: (context, orientation) {
                return Flex(
                    direction: orientation == Orientation.portrait
                        ? Axis.vertical
                        : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlipBoard(
                        duration: const Duration(seconds: 1),
                        initialValue: intialHour,
                        finalValue: intialHour,
                        type: "hours",
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      FlipBoard(
                        duration: const Duration(seconds: 1),
                        initialValue: intialMinutes,
                        finalValue: intialMinutes,
                        type: "minutes",
                      )
                    ]);
              },
            ),
          ),
        ));
  }
}
