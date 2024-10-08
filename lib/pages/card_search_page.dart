// ignore_for_file: use_build_context_synchronously

import 'package:assignment2_flutter_devcamp_london/services/api_service.dart';
import 'package:assignment2_flutter_devcamp_london/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardSearchPage extends StatefulWidget {
  final String name;

  const CardSearchPage({super.key, required this.name});

  @override
  CardSearchPageState createState() => CardSearchPageState();
}

class CardSearchPageState extends State<CardSearchPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _cards = [];
  bool _isLoading = false;
  int _currentPage = 0;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    if (widget.name.isNotEmpty) {
      _searchController.text = widget.name;
      _searchCards();
    } else {
      _loadMoreCards();
    }
  }

  void _searchCards() async {
    setState(() {
      _isLoading = true;
      _cards = [];
      _currentPage = 0;
    });

    try {
      final cards = await _apiService.fetchCardByName(_searchController.text);
      setState(() {
        _cards = [cards];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMoreCards() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final startIndex = _currentPage * _pageSize;
      final endIndex = startIndex + _pageSize;
      final newCards = await _apiService.fetchAllCards();
      setState(() {
        _cards.addAll(newCards.sublist(startIndex, endIndex.clamp(0, newCards.length)));
        _currentPage++;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yu-Gi-Oh! Card Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBarWidget(
              searchController: _searchController,
              onSearch: _searchCards,
            ),
            const SizedBox(height: 20),
            _isLoading && _cards.isEmpty
                ? const CircularProgressIndicator()
                : Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !_isLoading) {
                          _loadMoreCards();
                          return true;
                        }
                        return false;
                      },
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: _cards.length,
                        itemBuilder: (context, index) {
                          final card = _cards[index];
                          return GestureDetector(
                            onTap: () {
                              GoRouter.of(context).go('/card/${card['id']}');
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    card['card_images'][0]['image_url_small'],
                                    fit: BoxFit.cover,
                                    height: 120,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      card['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(card['type']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
