import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_editing_controller/number_editing_controller.dart';
import 'package:panasonic/constants.dart';
import 'package:panasonic/main.dart';
import 'package:provider/provider.dart';

class TFFForAddProduct extends StatefulWidget {
  const TFFForAddProduct({
    super.key,
    required this.hintText,
    this.controller,
    this.numberController,
    this.onFieldSubmitted,
    this.onChanged,
    this.validate = false,
    this.validateInt = false,
    this.validateDouble = false,
    this.validateUpperCaseLetters = false,
    this.multiLine = false,
    this.enabled = true,
    this.prefixText,
  });

  final String hintText;
  final String? prefixText;
  final void Function(String data)? onChanged;
  final void Function(String data)? onFieldSubmitted;
  final bool multiLine;
  final bool validate;
  final bool validateDouble;
  final bool validateInt;
  final bool validateUpperCaseLetters;
  final TextEditingController? controller;
  final NumberEditingTextController? numberController;
  final bool enabled;

  @override
  State<TFFForAddProduct> createState() => _TFFForAddProductState();
}

class _TFFForAddProductState extends State<TFFForAddProduct> {
  bool? foucs;
  Color color = Colors.grey;
  final errorColor = Colors.red;
  final noErrorFoucsColor = KPrimayColor;
  final noErrornoFoucsColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    int sum = 0;
    widget.validateDouble ? sum++ : null;
    widget.validateInt ? sum++ : null;
    widget.validateUpperCaseLetters ? sum++ : null;
    sum > 1 ? throw Exception('One of them should be true ') : null;

    return Focus(
      onFocusChange: (foucsed) {
        foucs = foucsed;
        if (foucsed && color != errorColor) {
          setState(() {
            color = noErrorFoucsColor;
          });
        } else if (foucsed == false && color != errorColor) {
          setState(() {
            color = noErrornoFoucsColor;
          });
        }
      },
      child: TextFormField(
        validator: (data) {
          if ((data!.isEmpty || data == '') && widget.validate) {
            setState(() {
              color = errorColor;
            });
            return 'Field is required';
          } else if (foucs == true) {
            setState(() {
              color = noErrorFoucsColor;
            });
          } else {
            setState(() {
              color = noErrornoFoucsColor;
            });
          }
          return null;
        },
        inputFormatters: widget.validateInt
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, FilteringTextInputFormatter.deny(RegExp(' '))]
            : widget.validateDouble
                ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r"[0-9]*\.?[0-9]*")), FilteringTextInputFormatter.deny(RegExp(' '))]
                : widget.validateUpperCaseLetters
                    ? [UpperCaseTextFormatter(), FilteringTextInputFormatter.deny(RegExp(' '))]
                    : null,
        keyboardType: widget.multiLine ? TextInputType.multiline : null,
        enabled: widget.enabled,
        maxLines: widget.multiLine ? null : 1,
        cursorColor: color,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        controller: widget.controller,
        style: const TextStyle(fontSize: 18),
        minLines: widget.multiLine ? 5 : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: KRadius),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2), borderRadius: KRadius),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: color),
          prefixText: widget.prefixText,
          prefixStyle: const TextStyle(fontSize: 18),
          suffixIcon: IconButton(
            onPressed: () {
              if (widget.controller != null) {
                widget.controller!.clear();
              } else if (widget.numberController != null) {
                widget.numberController!.clear();
              }
            },
            icon: Icon(Icons.clear, color: color),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

// ignore: must_be_immutable
class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({super.key, required this.hintText, required this.onChanged, required this.label, this.prefixIcon, this.obscureText = false, this.inputFormatters});

  final String hintText;
  final String label;
  final void Function(String data)? onChanged;
  List<TextInputFormatter>? inputFormatters;

  final IconData? prefixIcon;
  bool obscureText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final controller = TextEditingController();
  bool? foucs;
  Color color = Colors.grey;
  final errorColor = Colors.red;
  final noErrorFoucsColor = KPrimayColor;
  final noErrornoFoucsColor = Colors.grey;
  IconData icon = Icons.remove_red_eye_outlined;
  bool? show;

  @override
  void initState() {
    super.initState();
    show = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (foucsed) {
        foucs = foucsed;
        if (foucsed && color != errorColor) {
          setState(() {
            color = noErrorFoucsColor;
          });
        } else if (foucsed == false && color != errorColor) {
          setState(() {
            color = noErrornoFoucsColor;
          });
        }
      },
      child: TextFormField(
        validator: (data) {
          if (data!.isEmpty) {
            setState(() {
              color = errorColor;
            });
            return 'Field is required';
          } else if (foucs == true) {
            setState(() {
              color = noErrorFoucsColor;
            });
          } else {
            setState(() {
              color = noErrornoFoucsColor;
            });
          }
          return null;
        },
        cursorColor: color,
        obscureText: show!,
        onChanged: widget.onChanged,
        controller: controller,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: KRadius),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color, width: 2), borderRadius: KRadius),
          prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: color) : null,
          label: Text(widget.label, style: TextStyle(color: color)),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: color),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(icon, color: color),
                  onPressed: () {
                    show = !show!;
                    if (show!) {
                      icon = Icons.remove_red_eye_outlined;
                    } else {
                      icon = Icons.remove_red_eye;
                    }
                    setState(() {});
                  })
              : IconButton(
                  onPressed: () {
                    controller.clear();
                  },
                  icon: Icon(Icons.clear, color: color),
                ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomCheckBox extends StatefulWidget {
  CustomCheckBox({super.key, required this.isChecked});

  bool? isChecked = false;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      value: Provider.of<ProviderVariables>(context, listen: false).used,
      onChanged: (value) {
        setState(() {
          Provider.of<ProviderVariables>(context, listen: false).used = value;
        });
      },
    );
  }
}

// ignore: must_be_immutable
class CustomDropdownButton extends StatefulWidget {
  CustomDropdownButton({super.key, required this.thingsToDisplay, required this.initialText, this.enabled = true, required this.onSelected});

  String? initialText;
  final List<String> thingsToDisplay;
  final bool enabled;
  void Function(String? value) onSelected;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      menuHeight: MediaQuery.of(context).size.height - 50,
      enabled: widget.enabled,
      initialSelection: widget.initialText,
      dropdownMenuEntries: widget.thingsToDisplay.map<DropdownMenuEntry<String>>((value) => DropdownMenuEntry(value: value, label: value)).toList(),
      width: widthOfCustoms(context),
      textStyle: const TextStyle(fontSize: 18),
      onSelected: (value) {
        setState(() {
          widget.onSelected(value);
        });
      },
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: KRadius),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.widget, required this.color, required this.borderColor, this.state});

  final void Function() onTap;
  final Widget widget;
  final Color color;
  final Color borderColor;
  final bool? state;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(side: BorderSide(color: borderColor, width: 2), borderRadius: KRadius),
      onPressed: onTap,
      color: color,
      height: 50,
      minWidth: double.infinity,
      child: state == null
          ? widget
          : Row(
              children: [
                const Spacer(flex: 1),
                widget,
                const Spacer(flex: 1),
                state! ? const Text('used') : const Text('    '),
              ],
            ),
    );
  }
}

class GDForSignInMethods extends StatelessWidget {
  const GDForSignInMethods({super.key, required this.asset, required this.onTap, required this.text, required this.color});

  final Function() onTap;
  final String asset;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(borderRadius: KRadius, color: color),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(asset, width: 30, height: 30),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class LabelWithRedStar extends StatelessWidget {
  const LabelWithRedStar({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        const Text('*', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(fontSize: 17, color: Colors.white)),
      backgroundColor: KPrimayColor,
      duration: const Duration(seconds: 2),
    ),
  );
}

Text textOfCustomButton({required text}) {
  return Text(text, style: const TextStyle(color: Colors.white, fontSize: 20));
}
