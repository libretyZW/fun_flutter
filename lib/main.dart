import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fun_flutter/config/router_manager.dart';
import 'package:fun_flutter/config/storage_manager.dart';
import 'package:fun_flutter/generated/i18n.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  runApp(MyApp());
  // Android状态栏透明 splash为白色,所以调整状态栏文字为黑色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: RefreshConfiguration(
            hideFooterWhenNotFull: true, //列表数据不满一页,不触发加载更多
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                S.delegate,
                RefreshLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: S.delegate.supportedLocales,
              onGenerateRoute: Router.generateRoute,
              initialRoute: RouterName.tab,
            )));
  }
}
