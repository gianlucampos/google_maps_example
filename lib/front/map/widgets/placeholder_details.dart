import 'package:flutter/material.dart';
import 'package:google_maps_example/back/models/custom_placeholder.dart';

class PlaceHolderDetails extends StatelessWidget {
  const PlaceHolderDetails({Key? key, required this.placeholder}) : super(key: key);
  final CustomPlaceholder placeholder;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Image.network(placeholder.image,
            height: 250,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.only(top: 24, left: 24),
          child: Text(
            placeholder.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60, left: 24),
          child: Text(
            placeholder.adress,
          ),
        ),
      ],
    );
  }
}
