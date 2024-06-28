import 'dart:collection';

import 'package:bt_tuan7/data/models/product.dart';
import 'package:flutter/material.dart';

class ProductViewModel with ChangeNotifier{

  // final List<Product> _listProduct = [];
  // UnmodifiableListView<Product> get listProduct => UnmodifiableListView(_listProduct);

  final List<Product>  _groupedProduct = [];
  UnmodifiableListView<Product> get groupedProduct => UnmodifiableListView(_groupedProduct);

  // Map<int, Product> groupProductMap = {};

  add(Product product){
    if (!_groupedProduct.contains(product)) {
      _groupedProduct.add(product);
    }
    product.quantity += 1;
    notifyListeners();
  }

  delete(int id){
    // _listProduct.removeWhere((product) => product.id == id);
    _groupedProduct.removeWhere((product) => product.id == id);
    notifyListeners();
  }
  
  clear(){
    for(var product in _groupedProduct){
      product.quantity=0;
    }
    _groupedProduct.clear();
    // if (_groupedProduct.isEmpty){
    //   for(var product in _listProduct){
    //     product.quantity = 0;
    //   }
      
    //   _listProduct.clear();
    // }
    notifyListeners();
  }

  decrease(Product _product){
    _product.quantity-=1;
    if (_product.quantity<=0){
      delete(_product.id!);
    }
    notifyListeners();
  }

  int sumPrice(Product product){
    return product.quantity * product.price!;
  }

  sumAmount(List<Product> lst){
    int sum = 0;
    for(var product in lst){
      sum += product.quantity;
    }
    return sum;
  }

  // int? quantity(int id){
  //   return _listProduct[id].quantity;
  // }

  void groupProducts(List<Product> lst) {
    
    for (var product in lst){
      if(_groupedProduct.isEmpty){
        _groupedProduct.add(product);
      }else{
        if(!_groupedProduct.contains(product)){
          _groupedProduct.add(product);
        }
      }
    }

    // notifyListeners();
  }
}