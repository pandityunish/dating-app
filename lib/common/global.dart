import 'package:flutter/material.dart';
import 'package:ristey/common/custom_button.dart';
import 'package:ristey/common/custom_button_2.dart';

import '../Assets/Error.dart';

const primarycolor = Color(0xFF1ABCFE);
void showsnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

customAlertBox(BuildContext context, IconData icon, String title,
    String subtitle, String bttitle, VoidCallback callback) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Icon(
          icon,
          size: 35,
          color: primarycolor,
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButtonD(
                name: "Allow $bttitle Service",
                callback: callback,
              )
            ],
          ),
        ),
      );
    },
  );
}

void customAlertBox1(BuildContext context, IconData icon, String title,
    String subtitle, VoidCallback callback) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SnackBarContent(
          error_text: title,
          appreciation: "",
          icon: icon,
          sec: 2,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
    },
  );
}

void customAlertBox2(BuildContext context, IconData icon, String title) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Icon(
          icon,
          size: 50,
          color: primarycolor,
        ),
        content: SizedBox(
          height: 80,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void termsAlertBox(BuildContext context, VoidCallback callback) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Terms and Condition",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Scrollbar(
          thickness: 5,
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  const Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                      onTap: callback, child: const CustomButtom(text: "Agree"))
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
