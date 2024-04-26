// import 'package:flutter/material.dart';

// import 'custom_category_button_widget.dart';
// import 'images.dart';

// class DrawerWidget extends StatelessWidget {
//   const DrawerWidget({
//     super.key,
//     required pagina,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           const UserAccountsDrawerHeader(
//             accountName: Text("User Name"),
//             accountEmail: Text("user@dailystop.com"),
//             currentAccountPicture: CircleAvatar(
//               backgroundImage: NetworkImage(
//                   "https://cdn1.iconfinder.com/data/icons/bokbokstars-121-classic-stock-icons-1/512/person-man.png"),
//               backgroundColor: Colors.white,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.dashboard),
//             title: const Text('Show Inventory'),
//             onTap: () => _selectPage(0),
//           ),
//           ListTile(
//             leading: const Icon(Icons.input),
//             title: const Text('Inventory Entry'),
//             onTap: () => _selectPage(1),
//           ),
//           ListTile(
//             leading: const Icon(Icons.qr_code),
//             title: const Text('Barcode Generator'),
//             onTap: () => _selectPage(2),
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.add_shopping_cart),
//             title: const Text('Add Products'),
//             onTap: () => _selectPage(3),
//           ),
//           ListTile(
//             leading: const Icon(Icons.attach_money),
//             title: const Text('Check Price'),
//             onTap: () => _selectPage(4),
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.sync_alt),
//             title: const Text('Transfer Stock'),
//             onTap: () => _selectPage(5),
//           ),
//           ListTile(
//             leading: const Icon(Icons.image),
//             title: const Text('Upload Image'),
//             onTap: () => _selectPage(6),
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.image),
//             title: const Text('Upload Image'),
//             onTap: () => _selectPage(6),
//           ),
//           CustomCategoryButtonWidget(
//             icon: Images.logout,
//             buttonText: "Log Out",
//             onTap: () => _logout(context),
//             showDivider: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
