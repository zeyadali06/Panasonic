// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import 'package:panasonic/components/helper.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/main.dart';
import 'package:panasonic/models/ProductModel.dart';
import 'package:panasonic/services/ProductServices.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  @override
  void deactivate() {
    Provider.of<ProviderVariables>(context, listen: false).product = null;
    super.deactivate();
  }

  bool isLoading = false;
  bool isChecked = false;

  ScrollController scrollController = ScrollController();

  final TextEditingController modelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ProductModel providerProduct = Provider.of<ProviderVariables>(context, listen: false).product == null
        ? ProductModel(model: '', description: '', category: '', used: false)
        : Provider.of<ProviderVariables>(context, listen: false).product!;

    if (providerProduct.model != '') {
      modelController.text = providerProduct.model;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppBar(backgroundColor: KPrimayColor),
          body: Form(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              padding: const EdgeInsets.all(KHorizontalPadding),
              children: [
                // Device Model
                const LabelWithRedStar(label: 'Device Model'),
                const SizedBox(height: 5),
                TFFForAddProduct(
                  hintText: 'Enter Device Model',
                  onChanged: (data) {
                    providerProduct.model = data.toUpperCase().trim();
                  },
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                    FilteringTextInputFormatter.deny(RegExp(' ')),
                    LengthLimitingTextInputFormatter(15),
                  ],
                  controller: modelController,
                ),
                const SizedBox(height: 20),

                // Description
                const LabelWithRedStar(label: 'Description'),
                const SizedBox(height: 5),
                TFFForAddProduct(
                  hintText: 'Enter Device Description',
                  onChanged: (data) {
                    providerProduct.description = data.trim();
                  },
                ),
                const SizedBox(height: 20),

                // Category
                const LabelWithRedStar(label: 'Category Of Device'),
                const SizedBox(height: 5),
                CustomDropdownButton(
                  initialText: allCategories.first,
                  thingsToDisplay: allCategories.toList(),
                  onSelected: (value) {
                    providerProduct.category = value!;
                  },
                ),
                const SizedBox(height: 10),

                // Used
                Row(
                  children: [
                    const LabelWithRedStar(label: 'Used'),
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        isChecked = value!;
                        providerProduct.used = isChecked;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Price
                const Text('Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                TFFForAddProduct(
                  onChanged: (data) {
                    try {
                      data = data.replaceAll('EGP', '').replaceAll(',', '');
                      if (data == '') {
                        providerProduct.price = null;
                      } else {
                        providerProduct.price = double.parse(data);
                      }
                    } catch (_) {}
                  },
                  hintText: 'Enter Price',
                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                  controller: NumberEditingTextController.currency(
                    value: providerProduct.price,
                    allowNegative: false,
                    currencySymbol: 'EGP',
                    groupSeparator: ',',
                    decimalSeparator: '.',
                  ),
                ),
                const SizedBox(height: 20),

                // Quantity
                const Text('Quantity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                TFFForAddProduct(
                  onChanged: (data) {
                    try {
                      data = data.replaceAll(',', '');
                      if (data == '') {
                        providerProduct.quantity = null;
                      } else {
                        providerProduct.quantity = int.parse(data);
                      }
                    } catch (_) {}
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.deny(RegExp(' ')),
                    LengthLimitingTextInputFormatter(15),
                  ],
                  hintText: 'Enter Quantity',
                  controller: NumberEditingTextController.integer(value: providerProduct.quantity, allowNegative: false),
                ),
                const SizedBox(height: 20),

                // Abbreviation
                const Text('Abbreviation', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                TFFForAddProduct(
                  onChanged: (data) {
                    providerProduct.abbreviation = data.trim().toUpperCase();
                  },
                  inputFormatters: [
                    UpperCaseTextFormatter(),
                    FilteringTextInputFormatter.deny(RegExp(' ')),
                    LengthLimitingTextInputFormatter(15),
                  ],
                  hintText: 'Enter Device Abbreviation',
                ),
                const SizedBox(height: 20),

                // Compatibility
                const Text('Compatibility', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                ChooseAndShowCompatibleDevices(product: providerProduct, allCompatibleDevices: allCompatibleDevices.toSet()),
                const SizedBox(height: 20),

                // Note
                const Text('Notes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                TFFForAddProduct(
                  onChanged: (data) {
                    providerProduct.note = data.trim();
                  },
                  multiLine: true,
                  hintText: '',
                ),
                const SizedBox(height: 20),

                // Add Product
                CustomButton(
                  onTap: () async {
                    if (providerProduct.model == '') {
                      showSnackBar(context, 'Device model is empty');
                      scrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      return;
                    }
                    if (providerProduct.description == '') {
                      showSnackBar(context, 'Device description is empty');
                      scrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      return;
                    }
                    isLoading = true;
                    setState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                    await sendProductToFireStore(context, providerProduct);
                  },
                  widget: textOfCustomButton(text: 'Add Product'),
                  color: KPrimayColor,
                  borderColor: KPrimayColor,
                ),
                const SizedBox(height: 10),

                // Clear All
                CustomButton(
                  onTap: () {
                    Provider.of<ProviderVariables>(context, listen: false).product = null;
                    Navigator.pushReplacementNamed(context, 'AddProductPage');
                  },
                  widget: textOfCustomButton(text: 'Clear All'),
                  color: KPrimayColor,
                  borderColor: KPrimayColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> sendProductToFireStore(BuildContext context, ProductModel product) async {
  try {
    await addProductToAccount(product: product, email: Provider.of<ProviderVariables>(context, listen: false).email!);
    await addProduct(
      product: ProductModel(
        model: product.model,
        description: '',
        category: allCategories.first,
        used: false,
      ),
    );
    showSnackBar(context, 'Product Added Successfully');
    Provider.of<ProviderVariables>(context, listen: false).product = null;
    Navigator.pop(context);
  } catch (e) {
    showSnackBar(context, 'Error, try again');
  }
}



// zeyad@gmail.com

// 06062003

// zeyadali6060@gmail.com

// Ze06062003#

// set@gmail.com

// set.com
