
import 'package:dailystopstock/screens/ui/category_list_page.dart';
import 'package:dailystopstock/screens/ui/codebar_gen.dart';
import 'package:dailystopstock/screens/ui/entry_inventary.dart';
import 'package:dailystopstock/screens/ui/move_inventory.dart';
import 'package:dailystopstock/screens/ui/out_inventory.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;
  final screens = <Widget>[];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: selectedTab, children: const <Widget>[
          CategoryListPage(),
          CodeBarGen(),
          EntradaInventarioPage(),
          SalidaInventarioPage(),
          TrasladoInventarioPage(),
        ]),
        bottomNavigationBar: NavigationBar(
            selectedIndex: selectedTab,
            onDestinationSelected: (int index) {
              setState(() {
                selectedTab = index;
              });
            },
            animationDuration: const Duration(seconds: 3),
            destinations: const [
              NavigationDestination(
                  selectedIcon: Icon(Icons.home_filled),
                  tooltip: 'Navigate to the Dashboard',
                  icon: Icon(Icons.category),
                  label: 'Category'),
              NavigationDestination(
                  icon: Icon(Icons.barcode_reader), label: 'Scancode'),
              NavigationDestination(
                  icon: Icon(Icons.production_quantity_limits),
                  label: 'ItemsEntry'),
              NavigationDestination(
                  icon: Icon(Icons.insert_emoticon), label: 'ItemsOut'),
              NavigationDestination(
                  icon: Icon(Icons.logout), label: 'ItemsOut'),
            ]),
      );
}

// IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const CategoryListPage()),
//               );
//             },
//             icon: const Icon(Icons.category)),
//         IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CodeBarGen()),
//               );
//             },
//             icon: const Icon(Icons.insert_chart)),
//         IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const EntradaInventarioPage()),
//               );
//             },
//             icon: const Icon(Icons.barcode_reader)),
//         IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const SalidaInventarioPage()),
//               );
//             },
//             icon: const Icon(Icons.outdoor_grill_outlined)),
//         IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const TrasladoInventarioPage()),
//               );
//             },
//             icon: const Icon(Icons.traffic)),
//         IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const EntradaInventarioPage()),
//               );
//             },
//             icon: const Icon(Icons.traffic)),
