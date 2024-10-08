import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required Map<String, dynamic>? card,
  }) : _card = card;

  final Map<String, dynamic>? _card;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                _card!['card_images'][0]['image_url'],
                width: 200,
                height: 300,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _card['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _card['type'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            if (_card['atk'] != null && _card['def'] != null)
              Text(
                'ATK: ${_card['atk']} / DEF: ${_card['def']}',
                style: const TextStyle(fontSize: 18,),
              ),
            const SizedBox(height: 10),
            if (_card['level'] != null)
              Text(
                'Level: ${_card['level']}',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 10),
            if (_card['attribute'] != null)
              Text(
                'Attribute: ${_card['attribute']}',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            Text(
              _card['desc'],
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ));
  }
}
