import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instragran_clone/providers/user_provider.dart';
import 'package:instragran_clone/responsive/mobile_screen_layout.dart';
import 'package:instragran_clone/responsive/responsive_layout_screen.dart';
import 'package:instragran_clone/responsive/web_screen_layout.dart';
import 'package:instragran_clone/screens/login_screen.dart';
import 'package:instragran_clone/utils/colors.dart';
import 'package:instragran_clone/utils/firebase_ID.dart';
import 'package:instragran_clone/screens/comments_screens.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
          storageBucket: storageBucket),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Instragran Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: const ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        // ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snaphot) {
              if (snaphot.connectionState == ConnectionState.active) {
                if (snaphot.hasData) {
                  // print(snaphot.data);
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snaphot.hasError) {
                  return Center(
                    child: Text("${snaphot.error}"),
                  );
                }
              }
              if (snaphot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return const LoginScreen();
            }),
      ),
    );
  }
}
