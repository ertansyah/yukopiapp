import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yukopiapps/controller/db_services.dart';

class ViewListMenuPage extends StatefulWidget {
  @override
  _ViewListMenuPageState createState() => _ViewListMenuPageState();
}

class _ViewListMenuPageState extends State<ViewListMenuPage> {
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: DbServices.menuCollection
                  .orderBy('name', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No Menu Available'));
                }

                List<QueryDocumentSnapshot> filteredDocs =
                    snapshot.data!.docs.where((doc) {
                  String name = doc['name'] as String;
                  return name.toLowerCase().contains(searchText.toLowerCase());
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(child: Text('No Menu Found'));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot menuSnapshot = filteredDocs[index];
                    Map<String, dynamic>? menuData =
                        menuSnapshot.data() as Map<String, dynamic>?;

                    if (menuData == null) {
                      return SizedBox();
                    }

                    String menuId = menuSnapshot.id;
                    String name = menuData['name'] as String;
                    int price = menuData['price'] as int;
                    String description = menuData['description'] as String;
                    String fullDescription =
                        menuData['full_description'] as String;
                    String? imageUrl = menuData['image'] as String?;

                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        title: Text(name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: $price'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Edit Menu'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFormField(
                                            initialValue: name,
                                            decoration: InputDecoration(
                                              labelText: 'Name',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                name = value;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 16.0),
                                          TextFormField(
                                            initialValue: price.toString(),
                                            decoration: InputDecoration(
                                              labelText: 'Price',
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                price =
                                                    int.tryParse(value) ?? 0;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 16.0),
                                          TextFormField(
                                            initialValue: description,
                                            decoration: InputDecoration(
                                              labelText: 'Description',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                description = value;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 16.0),
                                          TextFormField(
                                            initialValue: fullDescription,
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                              labelText: 'Full Description',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                fullDescription = value;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 16.0),
                                          TextFormField(
                                            initialValue: imageUrl ?? '',
                                            decoration: InputDecoration(
                                              labelText: 'Image URL',
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                imageUrl = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Save the updated data
                                          DbServices.createOrUpdateMenu(
                                            menuId,
                                            name: name,
                                            price: price,
                                            description: description,
                                            full_description: fullDescription,
                                            image: imageUrl,
                                          );

                                          Navigator.pop(context);
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit_document,
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text('Data akan dihapus?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          DbServices.deleteMenu(menuId);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Delete'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
