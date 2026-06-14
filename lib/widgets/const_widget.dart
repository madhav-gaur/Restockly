import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:restockly/themes/color_const.dart';

TextStyle smallTextStyle() {
  return TextStyle(
    color: textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}

TextStyle mediumTextStyle() {
  return TextStyle(
    color: textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

TextStyle boldTextStyle() {
  return TextStyle(
    color: textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );
}

Container boldContainer({required String text, IconData? icon}) {
  return Container(
    height: 42,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: primary,
      borderRadius: BorderRadius.circular(7),
    ),
    child: Row(
      mainAxisAlignment: icon != null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      children: [
        Text(text, style: boldTextStyle()),
        if (icon != null) Icon(icon, color: whiteText),
      ],
    ),
  );
}

Widget elevatedButton(VoidCallback onPressed, String text) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(primary),
        shape: WidgetStatePropertyAll(
          RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(100)),
        ),
        side: WidgetStatePropertyAll(BorderSide(color: primary, width: 2)),
        minimumSize: WidgetStatePropertyAll(Size.fromHeight(42)),
      ),
      child: Text(text, style: boldTextStyle().copyWith(color: whiteText)),
    ),
  );
}

Widget outlinedButton(VoidCallback onPressed, Widget widget) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(background),
        shape: WidgetStatePropertyAll(
          RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(100)),
        ),
        side: WidgetStatePropertyAll(BorderSide(color: primary, width: 1.7)),
        minimumSize: WidgetStatePropertyAll(Size.fromHeight(42)),
      ),
      child: widget,
    ),
  );
}

Widget textFormField({
  required TextEditingController controller,
  required String labelText,
  FormFieldValidator? validator,
  TextInputType inputType = TextInputType.text,
  bool isClearButton = true,
  bool isObscureText = false,
}) {
  return _CustomTextFormField(
    controller: controller,
    labelText: labelText,
    validator: validator,
    isClearButton: isClearButton,
    isObscureText: isObscureText,
    inputType: inputType,
  );
}

class _CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator? validator;
  final bool isClearButton;
  final bool isObscureText;
  final TextInputType inputType;

  const _CustomTextFormField({
    required this.controller,
    required this.labelText,
    this.validator,
    this.isClearButton = true,
    this.isObscureText = false,
    this.inputType = TextInputType.text,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<_CustomTextFormField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isObscureText;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final showClear =
        widget.isClearButton && widget.controller.text.isNotEmpty && !_obscure;

    return TextFormField(
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: _obscure,
      validator: widget.validator,
      keyboardType: widget.inputType,
      cursorColor: textSecondary,
      cursorWidth: 1.7,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        suffixIcon: showClear
            ? IconButton(
                onPressed: () => widget.controller.clear(),
                icon: Icon(Icons.close_rounded, size: 20),
                splashRadius: 20,
              )
            : (widget.isObscureText
                  ? IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      splashRadius: 20,
                    )
                  : SizedBox(width: 48)),
        suffixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        label: Text(widget.labelText),
        labelStyle: TextStyle(color: textSecondary, fontSize: 14),
        floatingLabelStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.4),
          borderRadius: BorderRadius.circular(7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.4),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary, width: 1.5),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: danger, width: 1.4),
        ),
        errorStyle: TextStyle(color: danger, fontWeight: FontWeight.w500),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: danger, width: 1.4),
        ),
      ),
    );
  }
}

Widget radioListTile<T>({
  required T value,
  required groupValue,
  required String title,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(
        color: groupValue == value ? primary : Colors.grey.shade300,
      ),
      borderRadius: BorderRadius.circular(7),
    ),
    child: RadioListTile(
      value: value,
      activeColor: primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      horizontalTitleGap: 0,
      title: Text(title, style: smallTextStyle()),
      dense: true,
    ),
  );
}

void showDefaultLoading({String? status = "Loading"}) {
  EasyLoading.show(status: status);
}

void showProgressLoading({String? status = "Loading"}) {
  EasyLoading.showProgress(0.5, status: status);
}

void showSuccessMessage({String status = "Loading"}) {
  EasyLoading.showSuccess(status);
}

void showErrorMessage({String status = "Loading"}) {
  EasyLoading.showError(status);
}

void showInfoMessage({String status = "Loading"}) {
  EasyLoading.showInfo(status);
}

void hideLoading() {
  EasyLoading.dismiss();
}

DropdownMenuFormField dropdownMenu<T>({
  required List<DropdownMenuEntry<T>> dropdownMenuEntries,
  required String label,
  required ValueChanged<T?> onSelected,
  T? initialSelection,
  FormFieldValidator? validator,
}) {
  return DropdownMenuFormField<T>(
    initialSelection: initialSelection,
    validator: validator,
    onSelected: onSelected,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    expandedInsets: EdgeInsets.all(0),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: textSecondary, fontSize: 14),
      // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      errorStyle: TextStyle(color: danger, fontWeight: FontWeight.w500),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide(color: danger, width: 1.4),
      ),
    ),

    menuStyle: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.white),
      elevation: const WidgetStatePropertyAll(8),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      side: WidgetStatePropertyAll(BorderSide(color: Colors.grey.shade200)),
    ),
    trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
    selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up_rounded),
    label: Text(label),
    dropdownMenuEntries: dropdownMenuEntries,
  );
}

Widget alertDialog({
  required String title,
  String? description = "",
  required VoidCallback cancel,
  required VoidCallback confirm,
  String? confirmText = "Confirm",
}) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    backgroundColor: background,
    title: Text(title, style: boldTextStyle().copyWith(fontSize: 24)),
    content: Text(description!, style: smallTextStyle()),
    actionsAlignment: MainAxisAlignment.spaceAround,
    actions: [
      Row(
        children: [
          Expanded(
            child: outlinedButton(
              cancel,
              Text("Cancel", style: mediumTextStyle()),
            ),
          ),
          SizedBox(width: 5),
          Expanded(child: elevatedButton(confirm, confirmText!)),
        ],
      ),
    ],
  );
}
