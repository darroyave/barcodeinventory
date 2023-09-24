
import 'package:dailystopstock/screens/category_list_page.dart';
import 'package:dailystopstock/screens/codebar_gen.dart';
import 'package:dailystopstock/screens/entry_inventary.dart';
import 'package:dailystopstock/screens/move_inventory.dart';
import 'package:dailystopstock/screens/out_inventory.dart';
import 'package:dailystopstock/utils/custom_color.g.dart';
import 'package:dailystopstock/widgets/neubutton.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: neutral,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tertiary,
        title: Text(
          'DAILYSTOP INVENTARY',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: GridView.count(
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            NeuButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryListPage()),
                );
              },
              child: Text(
                'CATEGORIES',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            NeuButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntradaInventarioPage(),
                  ),
                );
              },
              child: Text(
                'ITEMS ENTRY',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            NeuButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SalidaInventarioPage(),
                  ),
                );
              },
              child: Text(
                'ITEMS OUT',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            NeuButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrasladoInventarioPage(),
                  ),
                );
              },
              child: Text(
                'ITEMS TRANSF',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            NeuButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CodeBarGen(),
                //   ),
                // );
              },
              child: Text(
                'ITEMS COUNT',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            NeuButton(
              onPressed: () {

         Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CodeBarGen(),
                  ),
                );


              },
              child: Text(
                'BARCODE GEN',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: tertiary,
            backgroundColor: tertiary,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: Text(
            'LOGOUT',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
