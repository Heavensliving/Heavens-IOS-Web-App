import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefix;
  final String? prefixText;
  final String? errorText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? minLines;
  final bool? readOnly;
  final bool? enabled;
  final int? maxLines;
  final Color? color;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.onTap,
    this.suffixIcon,
    this.contentPadding,
    this.prefix,
    this.prefixText,
    this.errorText,
    this.keyboardType,
    this.maxLength,
    this.minLines,
    this.onChanged,
    this.readOnly,
    this.enabled,
    this.maxLines,
    this.suffixText,
    this.inputFormatters,
    this.color,
    this.focusNode,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      enabled: widget.enabled,
      readOnly: widget.readOnly ?? false,
      onTap: widget.onTap,
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      maxLength: widget.maxLength,
      minLines: widget.minLines,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        suffixText: widget.suffixText,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.2),
            )),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: widget.color ?? Colors.black.withOpacity(0.2),
            )),
        prefixIcon: widget.prefix,
        counterText: "",
        errorText: widget.errorText,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        prefixText: widget.prefixText,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: widget.validator,
    );
  }
}
