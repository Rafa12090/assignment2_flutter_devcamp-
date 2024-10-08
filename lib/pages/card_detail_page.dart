// ignore_for_file: use_build_context_synchronously

import 'package:assignment2_flutter_devcamp_london/services/api_service.dart';
import 'package:assignment2_flutter_devcamp_london/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardDetailPage extends StatefulWidget {
  const CardDetailPage({super.key, required this.id});

  final String id;

  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _card;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCardDetails();
  }

  void _fetchCardDetails() async {
    try {
      final card = await _apiService.fetchCardById(widget.id);
      setState(() {
        _card = card;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Detail'),
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).go('/search');
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _card != null
              ? CardItem(card: _card)
              : const Center(child: Text('No card found')),
    );
  }
}

