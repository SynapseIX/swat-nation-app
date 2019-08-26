import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swat_nation/base/base_theme.dart';
import 'package:swat_nation/blocs/theme_bloc.dart';
import 'package:swat_nation/routes.dart';
import 'package:swat_nation/themes/dark_theme.dart';
import 'package:swat_nation/themes/light_theme.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({ Key key }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  _AppState() {
    final Router router = Router();
    Routes.configureRoutes(router);
    Routes.router = router;
  }

  @override
  void initState() {
    ThemeBloc.instance().retrieveSavedTheme();

    SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
      ],
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseTheme>(
      stream: ThemeBloc.instance().stream,
      initialData: LightTheme(),
      builder: (BuildContext context, AsyncSnapshot<BaseTheme> snapshot) {
        final BaseTheme theme = snapshot.data is LightTheme
          ? LightTheme()
          : DarkTheme();

        return MaterialApp(
          title: 'SWAT Nation',
          theme: theme.themeData,
          onGenerateRoute: Routes.router.generator,
        );
      },
    );
  }
}
