import 'package:flutter/material.dart';
import '../../../../widgets/buttons/imagebutton.dart';
import '../screen/channel_settings_screen.dart';

class Buttons extends StatelessWidget {
  const Buttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 41,
                    decoration: const BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(9),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Manage Videos",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ImageButton(
                    onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyChannelSettings(),
                        ),
                      );
                    },
                    image: "pen.png",
                    haveColor: true,
                  ),
                ),
                Expanded(
                  child: ImageButton(
                    onPressed: () {},
                    image: "time-watched.png",
                    haveColor: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
