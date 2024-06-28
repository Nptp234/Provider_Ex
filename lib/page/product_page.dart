import 'dart:convert';
import 'dart:io';

import 'package:bt_tuan7/data/models/product.dart';
import 'package:bt_tuan7/page/cart_page.dart';
import 'package:bt_tuan7/page/view_model/product_VM.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/src/intl/number_format.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget{
  
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage>{

  Product product = Product();
  List<Product> lstProduct = [];
  Future<void> _loadProductLst() async {
    var data = await rootBundle.loadString('assets/files/productlist.json');
    var dataJson = jsonDecode(data);
    setState(() {
      lstProduct = (dataJson['data'] as List).map((e) => Product.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProductLst();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _headerCustom(context),
      floatingActionButton: _cartButton(context),
      body: _bodyCustom(context),
    );
  }

  PreferredSize _headerCustom(BuildContext context){
    return PreferredSize(
      preferredSize: Size.fromHeight(100), 
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          color: Colors.blueAccent,
        ),
        child: Center(child: Text('Product List', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),),
      )
    );
  }

  FloatingActionButton _cartButton(BuildContext context){
    return FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => CartPage()));
      },
      child: Stack(
        children: [
          const Icon(Icons.shopping_bag, color: Colors.white, size: 30,),
          Positioned(
            top: 0,
            right: 0,
            child: Consumer<ProductViewModel>(
              builder: (context, value, child) {
                return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.red
                  ),
                  child: Text('${value.sumAmount(value.groupedProduct)}', style: TextStyle(color: Colors.white, fontSize: 15),),
                );
              },
            ),
          )
        ],
      )
    );
  }

  Widget _bodyCustom(BuildContext context){
    return Container(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
        itemCount: lstProduct.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0.0, //khoang cach giua hang
          crossAxisSpacing: 5.0, //khoang cach giua cot
          childAspectRatio: 0.6,
        ), 
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index){
          return _itemProduct(lstProduct[index]);
        }
      ),
    );
  }

  Widget _itemProduct(Product product){
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10, bottom: 10),

        child: Column(
          children: [
            Expanded(flex: 1, child: Image.asset('assets/images/${product.img}', fit: BoxFit.cover,)),
            SizedBox(height: 20,),
            Expanded(flex: 0, child: Text(product.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),)),
            Expanded(flex: 0, child: Text('${NumberFormat('#,##0').format(product.price!)} VND', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),)),
            SizedBox(height: 20,),
            _addButton(context, product),
          ],
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context, Product product){
    return Consumer<ProductViewModel>(
      builder: (context, value, child){
        return GestureDetector(
          onTap: () {
            value.add(product);
          },

          child: Container(
            padding: EdgeInsets.all(5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.blueAccent
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('Add', style: TextStyle(color: Colors.white, fontSize: 20),)
                  ],
                )
              ),
            )
          );
      }
    );
  }

}