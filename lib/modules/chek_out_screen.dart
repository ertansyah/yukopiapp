import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yukopiapps/controller/cart_provider.dart';
import 'package:yukopiapps/controller/menu_model.dart';
import 'package:yukopiapps/controller/db_services.dart';
import 'package:yukopiapps/modules/order_list_model.dart';

enum CheckoutOption {
  takeHome,
  dineIn,
}

enum PaymentMethod {
  OVO,
  dana,
  gopay,
  qris,
}

class CheckoutPage extends StatefulWidget {
  final CartProvider cartProvider;

  const CheckoutPage({
    required this.cartProvider,
    required List<OrderItem> orderList,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int totalPrice = 0;
  CheckoutOption selectedOption = CheckoutOption.takeHome;
  String tableNumber = '';
  TextEditingController nameController = TextEditingController();
  PaymentMethod selectedPaymentMethod = PaymentMethod.OVO;

  @override
  void initState() {
    super.initState();
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    totalPrice = 0;
    for (var cartItem in widget.cartProvider.cart) {
      DbServices.getMenu(cartItem.menuId.toString()).then((menu) {
        if (menu != null) {
          int itemPrice = menu.price * cartItem.quantity;
          setState(() {
            totalPrice += itemPrice;
          });
        }
      });
    }
  }

  void placeOrder() async {
    String name = nameController.text;
    String option = selectedOption == CheckoutOption.takeHome
        ? 'Bawa Pulang'
        : 'Makan di Tempat';
    String paymentMethod = selectedPaymentMethod.toString().split('.').last;

    List<OrderItem> orderItems = [];
    for (var cartItem in widget.cartProvider.cart) {
      MenuModel? menu = await DbServices.getMenu(cartItem.menuId.toString());
      if (menu != null) {
        int itemPrice = menu.price * cartItem.quantity;
        OrderItem orderItem = OrderItem(
          menuImage: menu.image,
          menuName: menu.name,
          quantity: cartItem.quantity,
          totalPrice: itemPrice,
        );
        orderItems.add(orderItem);
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesanan Sedang Diproses'),
          content: Text('Pesanan Anda sedang diproses. Terima kasih!'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderListPage(
                      name: name,
                      option: selectedOption,
                      paymentMethod: paymentMethod,
                      orderItems: orderItems,
                    ),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Checkout'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan Nama:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Pilih Opsi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            DropdownButton<CheckoutOption>(
              value: selectedOption,
              onChanged: (CheckoutOption? value) {
                setState(() {
                  selectedOption = value!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: CheckoutOption.takeHome,
                  child: Text('Bawa Pulang'),
                ),
                DropdownMenuItem(
                  value: CheckoutOption.dineIn,
                  child: Text('Makan di Tempat'),
                ),
              ],
            ),
            if (selectedOption == CheckoutOption.dineIn) ...[
              SizedBox(height: 16.0),
              TextFormField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nomor Meja',
                ),
                onChanged: (value) {
                  setState(() {
                    tableNumber = value;
                  });
                },
              ),
            ],
            SizedBox(height: 16.0),
            Text(
              'Metode Pembayaran:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            DropdownButton<PaymentMethod>(
              value: selectedPaymentMethod,
              onChanged: (PaymentMethod? value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: PaymentMethod.OVO,
                  child: Text('OVO'),
                ),
                DropdownMenuItem(
                  value: PaymentMethod.dana,
                  child: Text('Dana'),
                ),
                DropdownMenuItem(
                  value: PaymentMethod.gopay,
                  child: Text('Gopay'),
                ),
                DropdownMenuItem(
                  value: PaymentMethod.qris,
                  child: Text('QRIS'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartProvider.cart.length,
                itemBuilder: (context, index) {
                  var cartItem = widget.cartProvider.cart[index];
                  return FutureBuilder<MenuModel?>(
                    future: DbServices.getMenu(cartItem.menuId.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        MenuModel? menu = snapshot.data;
                        if (menu != null) {
                          int itemPrice = menu.price * cartItem.quantity;
                          return ListTile(
                            title: Text(menu.name),
                            subtitle: Text('Quantity: ${cartItem.quantity}'),
                            trailing: Text('Harga: Rp ${itemPrice}'),
                            leading: Container(
                              width: 80,
                              height: 80,
                              child: Image.network(
                                menu.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return Text('Error retrieving menu data');
                        }
                      } else if (snapshot.hasError) {
                        return Text('Error retrieving menu data');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total: Rp ${totalPrice.toString()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                placeOrder();
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
