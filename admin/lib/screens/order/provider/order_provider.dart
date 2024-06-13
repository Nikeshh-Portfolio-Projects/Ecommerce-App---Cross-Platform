import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';


class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);

  updateOrder() async {
    try {
      if (orderForUpdate != null) {
        Map<String, dynamic> order = { 'trackingUrl': trackingUrlCtrl.text, 'orderStatus': selectedOrderStatus };
        final response = await service.updateItem(endpointUrl: 'orders', itemId: orderForUpdate?.sId ?? '', itemData: order);
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            log('Order Updated');
            _dataProvider.getAllOrders();
          } else {
            SnackBarHelper.showErrorSnackBar('Failed to add Order: ${apiResponse.message}');
          }
        } else {
          SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
        }
      }
    } catch(e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
      rethrow;
    }
  }

  deleteOrder(Order order) async {
    try {
      Response response = await service.deleteItem(endpointUrl: 'orders', itemId: order.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('Order Deleted Successfully');
          _dataProvider.getAllOrders();
        }
      } else {
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch(e) {
      print(e);
      rethrow;
    }
  }

  updateUI() {
    notifyListeners();
  }
}
