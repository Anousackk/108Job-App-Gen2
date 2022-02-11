import 'package:flutter/material.dart';
// import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'api/auth.dart';
import 'api/graphqlapi.dart';

import 'screen/AuthenScreen/login_page.dart';
import 'screen/ControlScreen/bottom_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

AuthUtil authUtil = AuthUtil();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(
    BuildContext context,
  ) {
    Link authLink;

    authLink = AuthLink(
      getToken: () async {
        await authUtil.buildgetTokenAndLang();
        // debugPrint('start with auth: ${authUtil.token.toString()}');
        // debugPrint('start with currenttoken: ${currentToken.toString()}');
        return authUtil.token;
      },
    ).concat(HttpLink(QueryInfo().host));
    final ValueNotifier<GraphQLClient> user = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: authLink,
        cache: GraphQLCache(),
      ),
    );
    return GraphQLProvider(
      client: user,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: '/',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: {
            '/': (context) => const BottomNavigation(),
            '/login': (context) => const LoginPage(),
          },
          // home:   const BottomNavigation(),
          builder: (context, Widget? child) {
            return FlutterSmartDialog(child: child);
          },
        ),
      ),
    );
  }
}
