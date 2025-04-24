import 'package:flutter/material.dart';
import 'package:flutter_work/features/catalog/ui/widget/catalog_page.dart';
import 'package:flutter_work/features/catalog/ui/scope/catalog_scope.dart';
import 'package:flutter_work/features/profile/ui/scope/profile_scope.dart';
import 'package:flutter_work/features/profile/ui/widget/profile_page.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScope(
      child: CatalogScope(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: ApplicationWrapper(),
        ),
      ),
    );
  }
}

class ApplicationWrapper extends StatefulWidget {
  const ApplicationWrapper({super.key});

  @override
  State<ApplicationWrapper> createState() => _ApplicationWrapperState();
}

class _ApplicationWrapperState extends State<ApplicationWrapper> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return InitializerWidget(
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: const Color.fromARGB(255, 248, 230, 178),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.list),
              icon: Icon(Icons.list_outlined),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Badge(child: Icon(Icons.person)),
              label: 'Profile',
            ),
          ],
        ),
        body: <Widget>[ProductCatalogPage(), ProfilePage()][currentPageIndex],
      ),
    );
  }
}

class InitializerWidget extends StatefulWidget {
  const InitializerWidget({super.key, required this.child});

  final Widget child;

  @override
  State<InitializerWidget> createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  @override
  void initState() {
    super.initState();
    print('init');
    CatalogScope.load(context);
    ProfileScope.load(context);
    ProfileScope.loadEdit(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child; // You can add any initialization logic here
  }
}
