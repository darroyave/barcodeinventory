import 'package:dailystopstock/screens/ui/category_list_page.dart';
import 'package:dailystopstock/screens/ui/count_inventary.dart';
import 'package:dailystopstock/screens/ui/entry_inventary.dart';
import 'package:dailystopstock/screens/ui/move_inventory.dart';
import 'package:dailystopstock/screens/ui/out_inventory.dart';
import 'package:dailystopstock/utils/custom_color.g.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: double.infinity,
      elevation: 1,
      child: Material(
        color: tertiary,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const SearchFieldDrawer(),
                  const SizedBox(height: 12),
                  MenuItem(
                    text: 'Categories',
                    icon: Icons.category,
                    onClicked: () {
                      Navigator.pop(context); // Cerrar el drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoryListPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'Items Entry',
                    icon: Icons.inbox,
                    onClicked: () {
                      Navigator.pop(context); // Cerrar el drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EntradaInventarioPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'Items out',
                    icon: Icons.workspaces_outline,
                    onClicked: () {
                      Navigator.pop(context); // Cerrar el drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SalidaInventarioPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'Items Transfer',
                    icon: Icons.update,
                    onClicked: () {
                      Navigator.pop(context); // Cerrar el drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TrasladoInventarioPage()),
                      );
                    },
                  ),
                  MenuItem(
                    text: 'Items Count',
                    icon: Icons.countertops_outlined,
                    onClicked: () {
                      Navigator.pop(context); // Cerrar el drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ConteoInventarioPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  MenuItem(
                    text: 'Barcode Generator',
                    icon: Icons.qr_code_2_sharp,
                    onClicked: () {
                      Navigator.pop(context); // Cerrar el drawer
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const CodigoBarrasPage()),
                      // );
                    },
                  ),
                  MenuItem(
                    text: 'Settings',
                    icon: Icons.settings,
                    onClicked: () => selectedItem(context, 6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Scaffold(), // Page 1
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Scaffold(), // Page 2
        ));
        break;
    }
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onClicked;

  const MenuItem({
    required this.text,
    required this.icon,
    this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: neutral),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onClicked,
    );
  }
}

class SearchFieldDrawer extends StatelessWidget {
  const SearchFieldDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: neutral, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        hintText: 'Search',
        hintStyle: const TextStyle(color: neutral),
        prefixIcon: const Icon(
          Icons.search,
          color: neutral,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: neutral.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: neutral.withOpacity(0.7)),
        ),
      ),
    );
  }
}
