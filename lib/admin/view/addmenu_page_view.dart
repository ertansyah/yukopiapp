import 'package:flutter/material.dart';
import 'package:yukopiapps/controller/db_services.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({Key? key}) : super(key: key);

  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _fullDescriptionController = TextEditingController();
  TextEditingController _imageController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();

  bool _isLoading = false; // Added flag for loading state

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String id = DateTime.now()
          .millisecondsSinceEpoch
          .toString(); // Generate unique id

      setState(() {
        _isLoading = true; // Set loading state to true
      });

      DbServices.createOrUpdateMenu(
        id,
        name: _nameController.text,
        price: int.parse(_priceController.text),
        description: _descriptionController.text,
        full_description: _fullDescriptionController.text,
        image: _imageController.text,
      ).then((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Add Success'),
            content: Text('Menu added successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  _nameController.clear();
                  _priceController.clear();
                  _descriptionController.clear();
                  _fullDescriptionController.clear();
                  _imageController.clear();
                  Navigator.pop(context); // Close the dialog
                  _nameFocusNode.requestFocus(); // Set focus on Name field
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add menu. Error: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }).whenComplete(() {
        setState(() {
          _isLoading = false; // Set loading state to false
        });
      });
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the menu name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the menu description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _fullDescriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Full Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the menu full description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the image URL';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _submitForm, // Disable button when loading
                  child: _isLoading // Show loading indicator when loading
                      ? CircularProgressIndicator()
                      : Text('Add Menu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
