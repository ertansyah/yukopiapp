import 'package:flutter/material.dart';

import 'package:yukopiapps/modules/chek_out_screen.dart'; // Import CheckoutPage untuk mengakses CheckoutOption dan PaymentMethod

class OrderItem {
  final String menuImage;
  final String menuName;
  final int quantity;
  final int totalPrice;

  OrderItem({
    required this.menuImage,
    required this.menuName,
    required this.quantity,
    required this.totalPrice,
  });
}

class OrderListPage extends StatelessWidget {
  final String name;
  final CheckoutOption option; // Mengubah tipe data menjadi CheckoutOption
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
              'Opsi: ${getOptionText(option)}', // Menggunakan fungsi getOptionText untuk mendapatkan teks opsi
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Metode Pembayaran: $paymentMethod',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrderListDataPage(orderItems: orderItems),
                  ),
                );
              },
              child: Text('Lihat Pesanan'),
            ),
          ],
        ),
      ),
    );
  }

  String getOptionText(CheckoutOption option) {
    // Fungsi untuk mendapatkan teks opsi berdasarkan CheckoutOption
    return option == CheckoutOption.takeHome
        ? 'Bawa Pulang'
        : 'Makan di Tempat';
  }
}

class OrderListDataPage extends StatelessWidget {
  final List<OrderItem> orderItems;

  const OrderListDataPage({
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
