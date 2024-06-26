import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget{
  
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _headerCustom(context),
    );
  }

  PreferredSize _headerCustom(BuildContext context){
    return PreferredSize(
      preferredSize: Size.fromHeight(100), 
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
        ),
      )
    );
  }

}