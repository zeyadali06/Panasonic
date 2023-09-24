// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/main.dart';
import 'package:panasonic/services/ProductServices.dart';
import 'package:provider/provider.dart';

class EditOrDeleteProductPage extends StatefulWidget {
  const EditOrDeleteProductPage({super.key});

  @override
  State<EditOrDeleteProductPage> createState() => _EditOrDeleteProductPageState();
}

class _EditOrDeleteProductPageState extends State<EditOrDeleteProductPage> {
  @override
  Widget build(BuildContext context) {
    ProductModel providerProduct = Provider.of<ProviderVariables>(context, listen: false).product!;

    final TextEditingController modelController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final NumberEditingTextController priceController = NumberEditingTextController.currency(allowNegative: false);
    final NumberEditingTextController quantityController = NumberEditingTextController.integer();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController abbreviationController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    modelController.text = providerProduct.model;
    descriptionController.text = providerProduct.description;
    Provider.of<ProviderVariables>(context, listen: false).category = providerProduct.category;
    Provider.of<ProviderVariables>(context, listen: false).used = providerProduct.used;
    providerProduct.price == null ? null : priceController.number = providerProduct.price;
    providerProduct.quantity == null ? null : quantityController.number = providerProduct.quantity;
    providerProduct.abbreviation == null ? null : abbreviationController.text = providerProduct.abbreviation!;
    Provider.of<ProviderVariables>(context, listen: false).compatibility == null ? <Set>{} : Provider.of<ProviderVariables>(context, listen: false).compatibility = providerProduct.compatibility;
    providerProduct.note == null ? null : noteController.text = providerProduct.note!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: KPrimayColor),
        body: ListView(
          padding: const EdgeInsets.all(KPadding),
          children: [
            // Device Model
            const LabelWithRedStar(label: 'Device Model'),
            const SizedBox(height: 5),
            TFFForAddProduct(
              hintText: '',
              controller: modelController,
              enabled: false,
            ),
            const SizedBox(height: 20),

            // Description
            const LabelWithRedStar(label: 'Description'),
            const SizedBox(height: 5),
            TFFForAddProduct(
              hintText: '',
              controller: descriptionController,
              enabled: false,
            ),
            const SizedBox(height: 20),

            // Category
            const LabelWithRedStar(label: 'Category Of Device'),
            const SizedBox(height: 5),
            CustomDropdownButton(
              enabled: false,
              initialText: Provider.of<ProviderVariables>(context, listen: false).category,
              thingsToDisplay: [Provider.of<ProviderVariables>(context, listen: false).category.toString()],
              onSelected: (value) {},
            ),
            const SizedBox(height: 20),

            // Used
            Row(
              children: [
                const LabelWithRedStar(label: 'Used'),
                Checkbox(value: Provider.of<ProviderVariables>(context, listen: false).used, onChanged: (value) {}),
              ],
            ),
            const SizedBox(height: 20),

            // Price
            const Text('Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TFFForAddProduct(
              onFieldSubmitted: (data) {
                try {
                  priceController.number = double.parse(data);
                } catch (e) {}
              },
              hintText: 'Enter Price',
              controller: priceController,
            ),
            const SizedBox(height: 20),

            // Quantity
            const Text('Quantity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TFFForAddProduct(
              onFieldSubmitted: (data) {
                try {
                  quantityController.number = int.parse(data);
                } catch (e) {}
              },
              hintText: 'Enter Quantity',
              controller: quantityController,
            ),
            const SizedBox(height: 20),

            // Abbreviation
            const Text('Abbreviation', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TFFForAddProduct(
              onFieldSubmitted: (data) {
                abbreviationController.text = data.trim().toUpperCase();
              },
              validateUpperCaseLetters: true,
              hintText: 'Enter Device Abbreviation',
              controller: abbreviationController,
            ),
            const SizedBox(height: 20),

            // Compatibility
            const Text('Compatibility', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ChooseAndShowCompatibleDevices(allCompatibleDevicesCopy: allCompatibleDevices.toSet()),
            const SizedBox(height: 20),

            // Note
            const Text('Notes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            TFFForAddProduct(
              onFieldSubmitted: (data) {
                noteController.text = data.trim();
              },
              multiLine: true,
              hintText: '',
              controller: noteController,
            ),
            const SizedBox(height: 20),

            // Save Changes
            CustomButton(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                sendEditedProductToFireStore(context, modelController, descriptionController, priceController, quantityController, imageController, abbreviationController, noteController);
              },
              widget: textOfCustomButton(text: 'Save Changes'),
              color: KPrimayColor,
              borderColor: KPrimayColor,
            ),
            const SizedBox(height: 10),

            // Delete Product
            CustomButton(
              onTap: () {
                final updates = <String, dynamic>{
                  '${providerProduct.model}${providerProduct.used ? 't' : 'f'}': FieldValue.delete(),
                };
                FirebaseFirestore.instance.collection(usersCollection).doc(Provider.of<ProviderVariables>(context, listen: false).email).update(updates);

                showSnackBar(context, 'Product Deleted Successfully');
                Provider.of<ProviderVariables>(context, listen: false).category = null;
                Provider.of<ProviderVariables>(context, listen: false).used = null;
                Provider.of<ProviderVariables>(context, listen: false).product = null;
                Navigator.pop(context);
              },
              widget: textOfCustomButton(text: 'Delete Product'),
              color: Colors.red,
              borderColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

void sendEditedProductToFireStore(context, modelController, descriptionController, priceController, quantityController, imageController, abbreviationController, noteController) {
  try {
    ProductModel? product = ProductModel(
      model: modelController.text,
      description: descriptionController.text,
      category: Provider.of<ProviderVariables>(context, listen: false).category!,
      used: Provider.of<ProviderVariables>(context, listen: false).used!,
      price: priceController.number == null ? null : priceController.number!.toDouble(),
      quantity: quantityController.number == null ? null : quantityController.number!.toInt(),
      image: imageController.text,
      abbreviation: abbreviationController.text,
      compatibility: Provider.of<ProviderVariables>(context, listen: false).compatibility,
      note: noteController.text,
    );
    addProductToAccount(product: product, email: Provider.of<ProviderVariables>(context, listen: false).email!);
    showSnackBar(context, 'Product Added Successfully');
    Provider.of<ProviderVariables>(context, listen: false).category = null;
    Provider.of<ProviderVariables>(context, listen: false).used = null;
    Provider.of<ProviderVariables>(context, listen: false).product = null;
    Navigator.pop(context);
  } catch (e) {
    showSnackBar(context, 'Error, try again');
  }
}

// ignore: must_be_immutable
class ChooseAndShowCompatibleDevices extends StatefulWidget {
  ChooseAndShowCompatibleDevices({super.key, required this.allCompatibleDevicesCopy});

  Set<String> allCompatibleDevicesCopy;

  @override
  State<ChooseAndShowCompatibleDevices> createState() => _ChooseAndShowCompatibleDevicesState();
}

class _ChooseAndShowCompatibleDevicesState extends State<ChooseAndShowCompatibleDevices> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdownButton(
          initialText: widget.allCompatibleDevicesCopy.isEmpty ? null : widget.allCompatibleDevicesCopy.first,
          thingsToDisplay: widget.allCompatibleDevicesCopy.toList(),
          onSelected: (value) {
            setState(() {
              widget.allCompatibleDevicesCopy.remove(value);
              if (Provider.of<ProviderVariables>(context, listen: false).compatibility == null) {
                Provider.of<ProviderVariables>(context, listen: false).compatibility = {};
              }
              Provider.of<ProviderVariables>(context, listen: false).compatibility!.add(value);
            });
          },
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(borderRadius: KRadius, border: Border.all(color: Colors.grey)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: KPadding),
            child: Column(
              children: Provider.of<ProviderVariables>(context, listen: false).compatibility != null
                  ? Provider.of<ProviderVariables>(context, listen: false).compatibility!.map((e) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(side: const BorderSide(width: 2, color: KPrimayColor), borderRadius: KRadius),
                        child: ListTile(
                          title: Text(e, style: const TextStyle(fontSize: 22)),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.allCompatibleDevicesCopy.add(e);
                                  Provider.of<ProviderVariables>(context, listen: false).compatibility!.remove(e);
                                });
                              },
                              icon: const Icon(Icons.clear)),
                        ),
                      );
                    }).toList()
                  : <Widget>[],
            ),
          ),
        ),
      ],
    );
  }
}


// zeyad@gmail.com

// 06062003


// zeyadali6060@gmail.com

// Ze06062003#


// set@gmail.com

// set.com