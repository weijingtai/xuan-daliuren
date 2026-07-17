import 'package:flutter/material.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'pages/dev.dart';
import 'pages/gong_layout_dev_page.dart';
import 'pages/my_home_page.dart';
import 'pages/new/new_home_page.dart';
import 'presentation/views/da_liu_ren_view.dart';
import 'di/dependency_injection.dart';
import 'di/daliuren_storage_dependencies.dart';

class NavigatorGenerator {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  static Logger logger = Logger();
  static final routes = {
    "/daliuren": (BuildContext context, {arguments}) {
      final deps = context.read<DaliurenStorageDependencies>();
      return MultiProvider(
        providers: DependencyInjection.getProviders(deps),
        child: const DaLiuRenView(),
      );
    },
    "/daliuren/old": (BuildContext context, {arguments}) {
      final deps = context.read<DaliurenStorageDependencies>();
      return MultiProvider(
        providers: DependencyInjection.getProviders(deps),
        child: MyHomePage(
          title: AppLocalizations.of(context)!.daliurenOld,
        ),
      );
    },
    "/daliuren/new": (BuildContext context, {arguments}) {
      final deps = context.read<DaliurenStorageDependencies>();
      return MultiProvider(
        providers: DependencyInjection.getProviders(deps),
        child: const NewHomePage(),
      );
    },
    "/daliuren/dev": (BuildContext context, {arguments}) => const DevMyWidget(),
    "/daliuren/gong-layout": (BuildContext context, {arguments}) {
      final deps = context.read<DaliurenStorageDependencies>();
      return MultiProvider(
        providers: DependencyInjection.getProviders(deps),
        child: const GongLayoutDevPage(),
      );
    },
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String? name = settings.name;
    if (name != null && name.isNotEmpty) {
      final Function? pageContentBuilder = routes[name];
      if (pageContentBuilder != null) {
        final Route route = MaterialPageRoute(
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
        return route;
      } else {
        return _errorPage('Could not found route for $name');
      }
    } else {
      return _errorPage("Navigator required naviation name.");
    }
  }

  static Route _errorPage(String msg) {
    return MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context)!.daliurenUnknownPage)),
          body: Center(child: Text(msg)));
    });
  }

  static Route<dynamic> generateRoute1(RouteSettings settings) {
    switch (settings.name) {
      case '/taiyishenshu/primary':
        return PageRouteBuilder(
            settings:
                settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
            // pageBuilder: (_, __, ___) => CreateOrderPage(settings.arguments == null ?null:settings.arguments as CreateOrderPageArgs),
            pageBuilder: (_, __, ___) => MyHomePage(title: AppLocalizations.of(__)!.taiyiShenshu),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              final tween = Tween(begin: begin, end: end);
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );
              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            });
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
