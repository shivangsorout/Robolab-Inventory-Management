import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rim/constants.dart';

class ComponentDetailsTile extends StatelessWidget {
  final String tileName;
  final void Function(String) onChanged;
  final String? errorText;
  final TextEditingController? controller;
  final bool? textFieldEnabled;
  final TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;

  ComponentDetailsTile({
    required this.tileName,
    required this.onChanged,
    required this.errorText,
    this.controller,
    this.textFieldEnabled,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tileName,
            style: const TextStyle(
              color: Color(0xff666666),
              fontSize: 18.0,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextField(
            inputFormatters: inputFormatters ?? [],
            keyboardType: keyboardType,
            enabled: textFieldEnabled ?? true,
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              errorText: errorText,
              hintText: tileName,
              hintStyle: const TextStyle(
                fontSize: 17.0,
                color: Color(0xffbdbdbd),
              ),
              filled: true,
              fillColor: const Color(0xfff6f6f6),
              border: kRoundedBorder,
              enabledBorder: kRoundedBorder,
              focusedBorder: kRoundedBorder,
            ),
          ),
        ],
      ),
    );
  }
}
