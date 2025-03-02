import 'package:flutter/material.dart';

// Champ de saisie réutilisable
class CustomInputField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxline;

  const CustomInputField({
    Key? key,
    required this.labelText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxline = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      maxLines: maxline,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.blue) : null,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// Bouton réutilisable
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF0052D4),
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? hint;

  const CustomDropdown({
    Key? key,
    required this.labelText,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      hint: hint != null ? Text(hint!) : null,
      items: items,
      onChanged: onChanged,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
    );
  }
}
