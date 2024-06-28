// import 'dart:html';

import 'package:bt_tuan7/data/models/product.dart';
import 'package:bt_tuan7/page/view_model/product_VM.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/src/intl/number_format.dart';

class CartPage extends StatefulWidget{

  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage>{

  sumPrice(List<Product> lst, ProductViewModel pvm){
    int sum = 0;
    for (var product in lst){
      sum = sum + pvm.sumPrice(product);
    }
    return sum;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _headerCustom(context),
      body: _bodyCustom(context),
      bottomSheet: _footerCustom(context),
    );
  }

  PreferredSize _headerCustom(BuildContext context){
    return PreferredSize(
      preferredSize: Size.fromHeight(100), 
      child: AppBar(
        title: Text('Cart List', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
        ),
        actions: [
          Consumer<ProductViewModel>(
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () {
                  value.clear();
                },

                child: Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.red
                  ),
                  child: Center(child: Text('Delete All', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),),
                ),
              );
            },
          )
        ],
      )
    );
  }

  Widget _bodyCustom(BuildContext context){
    return Consumer<ProductViewModel>(
      builder: (context, value, child) {
        // value.groupProducts(value.listProduct);
        return Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height-270,
          child: GridView.builder(
            itemCount: value.groupedProduct.isNotEmpty?value.groupedProduct.length:1,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 0.0, //khoang cach giua hang
              crossAxisSpacing: 5.0, //khoang cach giua cot
              childAspectRatio: 2.0,
            ), 
            scrollDirection: Axis.vertical,
            itemBuilder: value.groupedProduct.isNotEmpty ?
            (BuildContext context, int index){
              return _itemProduct(value.groupedProduct[index], value);
            }:(context, index) => Text('Cart is empty!', style: TextStyle(fontSize: 20, color: Colors.black), textAlign: TextAlign.center,)
          ),
        );
      },
    );
  }

  Widget _footerCustom(BuildContext context){
    return Consumer<ProductViewModel>(
      builder: (context, value, child){
        return Container(
          width: double.infinity,
          height: 150,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.blueAccent
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Expanded(flex: 1, child: Text('Amount: ', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)),
                  Expanded(flex: 1, child: Text('${value.sumAmount(value.groupedProduct)}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.end,)),
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(flex: 1, child: Text('Price: ', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)),
                  Expanded(flex: 1, child: Text('${NumberFormat('#,##0').format(value.groupedProduct.length * sumPrice(value.groupedProduct, value))} VND', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.end,)),
                  
                ],
              )
            ],
          ),
        );
      }
    );
  }

  Widget _itemProduct(Product product, ProductViewModel value){
    return Dismissible(
      key: UniqueKey(), 
      direction: DismissDirection.horizontal,
      background: Container(color: Colors.red,),
      onDismissed: (direction){
        value.delete(product.id!);
      },
      child: Container(
        width: double.infinity,
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(width: 1, color: Colors.grey),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Expanded(flex: 1, child: Image.asset('assets/images/${product.img}', fit: BoxFit.cover,),),

            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(product.name!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),
                  Text(product.desc!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey),),
                  Text('${NumberFormat('#,##0').format(product.price!)} VND', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),),
                  _changeAmount(context, product, value),
                ],
              )
            )
          ],
        ),
      )
    );
  }

  Widget _changeAmount(BuildContext context, Product product, ProductViewModel pvm){
    TextEditingController _amount = TextEditingController();
    _amount.text = '${product.quantity}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 10),

      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 0,
              child: Center(
                child: IconButton(
                  onPressed: (){pvm.decrease(product);}, 
                  icon: Icon(Icons.minimize, size: 30,)
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                // height: 10,
                child: TextFormField(
                  controller: _amount,
                  maxLength: 20,
                  style: TextStyle(fontSize: 15),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  
                ),
              )
            ),
            Expanded(
              flex: 0,
              child: Center(
                child: IconButton(
                  onPressed: (){pvm.add(product);}, 
                  icon: Icon(Icons.add, size: 30,)
                ),
              )
            ),
          ],
        ),
      ),
    );  
  }



}