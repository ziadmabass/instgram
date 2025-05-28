import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:testfirebase/auth/mainpage.dart';
import 'package:testfirebase/chat/data/repositories/chat_repository.dart';
import 'package:testfirebase/chat/presentation/cubit/chat_cubit.dart';
import 'package:testfirebase/controller/addreelscupit/reels_cubit.dart';
import 'package:testfirebase/controller/mediacubit/media_cupit.dart';
import 'package:testfirebase/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:testfirebase/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',  
      fallbackLocale: const Locale('ar'),
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
    ),)
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatCubit(ChatRepository())),
        BlocProvider(create: (context) => MediaCubit()),
        BlocProvider(create: (context) => ReelsCubit()),


      ], 
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        home: const ScreenUtilInit(designSize: Size(375, 812), child: MainPage()),
        theme: Provider.of<ThemeProvider>(context).themeData,
      ),
    );
  }
}
