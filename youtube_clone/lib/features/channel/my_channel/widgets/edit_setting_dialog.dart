import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  final String identifier;
  final Function(String channelName)? onSave;
  const SettingsDialog({
    Key? key,
    required this.identifier,
    this.onSave,
  }) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 0),
      title: Padding(
        padding: const EdgeInsets.only(left: 22, top: 20),
        child: Text(
          widget.identifier,
          style: const TextStyle(
            fontSize: 18,fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
      content: SizedBox(
        height: 50,
        child: TextField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "CANCEL",
            style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w400,),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onSave!(controller.text);
            print("object");
            Navigator.pop(context); 
          },
          child: const Text(
            "SAVE",
            style: TextStyle(color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
