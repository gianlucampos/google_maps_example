import 'package:flutter/material.dart';
import 'package:google_maps_example/models/posto.dart';

class PostoDetalhes extends StatelessWidget {
  const PostoDetalhes({Key? key, required this.posto}) : super(key: key);
  final Posto posto;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Image.network(posto.foto,
            height: 250,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.only(top: 24, left: 24),
          child: Text(
            posto.nome,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60, left: 24),
          child: Text(
            posto.endereco,
          ),
        ),
      ],
    );
  }
}
