import 'package:fifa_on4_bank/core/service_locator/service_locator.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/favorite_player/favorite_player_trade_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/my_player/player_trade_table_provider.dart';
import 'package:fifa_on4_bank/ui/screen/player_trade_table/recent_matches/recent_matches_player_price_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'ui/screen/player_trade_table/player_trade_table_page.dart';

// https://javiercbk.github.io/json_to_dart/
// https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  timeago.setLocaleMessages('ko', timeago.KoMessages());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
      
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayerTradeTableProvider>(
          create: (context) => PlayerTradeTableProvider()..initTable(),
        ),
        ChangeNotifierProvider<FavoritePlayerTradeProvider>(
          create: (context) => FavoritePlayerTradeProvider(),
        ),
        ChangeNotifierProvider<RecentMatchesPlayerPriceProvider>(
          create: (context) => RecentMatchesPlayerPriceProvider()..initCode(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,  
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PlayerTradeTablePage(),
        navigatorObservers: <NavigatorObserver>[observer],
      ),
    );
  }
}