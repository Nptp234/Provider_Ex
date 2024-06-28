import 'package:bt_tuan7/page/product_page.dart';
import 'package:bt_tuan7/page/view_model/product_VM.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductViewModel(),
        ),
      ],

      child: MaterialApp(
        home: ProductPage(),
      ),
    );
  }
}
