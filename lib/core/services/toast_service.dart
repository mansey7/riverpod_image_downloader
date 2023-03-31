import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {

  static Widget customToast(Color primaryColor, Color secondaryColor,
          IconData icon, String text, BuildContext context) =>
      Container(
        height: 70,
        width: 360,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: secondaryColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: Center(
                    child: Icon(
                      icon,
                      size: 30,
                      color: primaryColor,
                    ),
                  ),
                )),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
                child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            )),
          ],
        ),
      );

  void showCustomToast(BuildContext context) {
    FToast().init(context);
    FToast().showToast(
      child: customToast(Colors.green, Colors.white, Icons.download,
          'Image downloaded to your gallery!', context),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(milliseconds: 1500),
    );
  }
}
