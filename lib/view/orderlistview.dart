import 'package:flutter/material.dart';
import 'package:yukopiapps/modules/order_list_model.dart';

class OrderListPage extends StatelessWidget {
  final String name;
  final String option;
  final String paymentMethod;
  final List<OrderItem> orderItems;

  const OrderListPage({
    required this.name,
    required this.option,
    required this.paymentMethod,
    required this.orderItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: $name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Opsi: $option',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Metode Pembayaran: $paymentMethod',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'Daftar Pesanan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  OrderItem orderItem = orderItems[index];
                  return ListTile(
                    title: Text(orderItem.menuName),
                    subtitle: Text('Quantity: ${orderItem.quantity}'),
                    trailing: Text('Total: Rp ${orderItem.totalPrice}'),
                    leading: Container(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        orderItem.menuImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
