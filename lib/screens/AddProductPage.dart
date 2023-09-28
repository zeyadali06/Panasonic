// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/main.dart';
import 'package:panasonic/models/ProductModel.dart';
import 'package:panasonic/services/ProductServices.dart';
import 'package:provider/provider.dart';
import 'package:number_editing_controller/number_editing_controller.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  @override
  void deactivate() {
    nullingProviderVars(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    final TextEditingController modelController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final NumberEditingTextController priceController = NumberEditingTextController.currency(allowNegative: false, currencyName: 'EGP', groupSeparator: '', decimalSeparator: '.');
    final NumberEditingTextController quantityController = NumberEditingTextController.integer(allowNegative: false);
    final TextEditingController imageController = TextEditingController();
    final TextEditingController abbreviationController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    Provider.of<ProviderVariables>(context, listen: false).used = false;
    Provider.of<ProviderVariables>(context, listen: false).category = allCategories.first;
    Provider.of<ProviderVariables>(context, listen: false).compatibility = {};

    ProductModel? providerProduct = Provider.of<ProviderVariables>(context, listen: false).product;

    if (providerProduct != null) {
      modelController.text = providerProduct.model;
      descriptionController.text = providerProduct.description;
      Provider.of<ProviderVariables>(context, listen: false).category = providerProduct.category;
      Provider.of<ProviderVariables>(context, listen: false).used = providerProduct.used;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(backgroundColor: KPrimayColor),
        body: Form(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(KHorizontalPadding),
            children: [
              // Device Model
              const LabelWithRedStar(label: 'Device Model'),
              const SizedBox(height: 5),
              TFFForAddProduct(
                hintText: 'Enter Device Model',
                onFieldSubmitted: (data) {
                  modelController.text = data.toUpperCase().trim();
                },
                validate: true,
                inputFormatters: [UpperCaseTextFormatter(), FilteringTextInputFormatter.deny(RegExp(' ')), LengthLimitingTextInputFormatter(15)],
                controller: modelController,
              ),
              const SizedBox(height: 20),

              // Description
              const LabelWithRedStar(label: 'Description'),
              const SizedBox(height: 5),
              TFFForAddProduct(
                hintText: 'Enter Device Description',
                onFieldSubmitted: (data) {
                  descriptionController.text = data.trim();
                },
                validate: true,
                controller: descriptionController,
              ),
              const SizedBox(height: 20),

              // Category
              const LabelWithRedStar(label: 'Category Of Device'),
              const SizedBox(height: 5),
              CustomDropdownButton(
                initialText: Provider.of<ProviderVariables>(context, listen: false).category,
                thingsToDisplay: allCategories.toList(),
                onSelected: (value) {
                  Provider.of<ProviderVariables>(context, listen: false).category = value;
                },
              ),
              const SizedBox(height: 10),

              // Used
              Row(
                children: [
                  const LabelWithRedStar(label: 'Used'),
                  CustomCheckBox(isChecked: Provider.of<ProviderVariables>(context, listen: false).used),
                ],
              ),
              const SizedBox(height: 10),

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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9]*\.?[0-9]*")),
                  FilteringTextInputFormatter.deny(RegExp(' ')),
                  LengthLimitingTextInputFormatter(15),
                ],
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
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.deny(RegExp(' ')),
                  LengthLimitingTextInputFormatter(15),
                ],
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
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  FilteringTextInputFormatter.deny(RegExp(' ')),
                  LengthLimitingTextInputFormatter(15),
                ],
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

              // Add Product
              CustomButton(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  await sendProductToFireStore(
                    context,
                    modelController,
                    descriptionController,
                    priceController,
                    quantityController,
                    imageController,
                    abbreviationController,
                    noteController,
                    scrollController,
                  );
                },
                widget: textOfCustomButton(text: 'Add Product'),
                color: KPrimayColor,
                borderColor: KPrimayColor,
              ),
              const SizedBox(height: 10),

              // Clear All
              CustomButton(
                onTap: () {
                  nullingProviderVars(context);
                  modelController.clear();
                  descriptionController.clear();
                  priceController.clear();
                  quantityController.clear();
                  imageController.clear();
                  abbreviationController.clear();
                  noteController.clear();
                  setState(() {});
                },
                widget: textOfCustomButton(text: 'Clear All'),
                color: KPrimayColor,
                borderColor: KPrimayColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> sendProductToFireStore(
    BuildContext context,
    TextEditingController modelController,
    TextEditingController descriptionController,
    NumberEditingTextController priceController,
    NumberEditingTextController quantityController,
    TextEditingController imageController,
    TextEditingController abbreviationController,
    TextEditingController noteController,
    ScrollController scrollController) async {
  try {
    if (modelController.text.isEmpty) {
      showSnackBar(context, 'Device Model is empty');
      throw Exception('model textField must not equil null');
    }
    if (descriptionController.text.isEmpty) {
      showSnackBar(context, 'Description is empty');
      throw Exception('description textField must not equil null');
    }
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
    await addProductToAccount(product: product, email: Provider.of<ProviderVariables>(context, listen: false).email!);
    await addProduct(
      product: ProductModel(
        model: modelController.text,
        description: descriptionController.text,
        category: Provider.of<ProviderVariables>(context, listen: false).category!,
        used: Provider.of<ProviderVariables>(context, listen: false).used!,
      ),
    );
    showSnackBar(context, 'Product Added Successfully');
    nullingProviderVars(context);
    Navigator.pop(context);
  } on Exception catch (e) {
    if (e.toString() == 'Exception: model textField must not equil null' || e.toString() == 'Exception: description textField must not equil null') {
      scrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      showSnackBar(context, 'Error, try again');
    }
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
              Provider.of<ProviderVariables>(context, listen: false).compatibility!.add(value!);
            });
          },
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(borderRadius: KRadius, border: Border.all(color: Colors.grey)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: KHorizontalPadding),
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
