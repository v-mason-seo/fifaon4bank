import 'package:fifa_on4_bank/core/api/favorite_player_db_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_meta_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_on4_bank_api.dart';
import 'package:fifa_on4_bank/core/api/fifa_user_api.dart';
import 'package:fifa_on4_bank/core/api/local_api.dart';
import 'package:fifa_on4_bank/core/api/db_api.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;


void setupLocator() {

  serviceLocator.registerSingleton<FifaOn4BankApi>(FifaOn4BankApi());
  serviceLocator.registerSingleton<LocalApi>(LocalApi());
  serviceLocator.registerSingleton<DBApi>(DBApi());
  serviceLocator.registerSingleton<FavoritePlayerDbApi>(FavoritePlayerDbApi());
  serviceLocator.registerLazySingleton<FifaUserApi>(() => FifaUserApi());
  serviceLocator.registerLazySingleton<FifaMetaApi>(() => FifaMetaApi());

}