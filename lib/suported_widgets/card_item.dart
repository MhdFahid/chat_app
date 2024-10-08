import 'package:flutter/material.dart';

import '../consts/constants.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.document,
  });
  final String document;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: const Color.fromARGB(255, 0, 12, 99),
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name : ".toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            gapH(10),
            Text(
              "Adress : ",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            gapH(10),
            Text(
              "Age : ",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            gapH(10),
            Text(
              "Email Id : ",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
