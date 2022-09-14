import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/db/db_helper.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Print",
      theme: ThemeData(primarySwatch: Colors.green),
      defaultTransition: Transition.cupertino,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
