import 'package:assignment2_flutter_devcamp_london/pages/card_detail_page.dart';
import 'package:assignment2_flutter_devcamp_london/pages/card_search_page.dart';
import 'package:assignment2_flutter_devcamp_london/pages/welcome_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomePage(),
      routes: [
        GoRoute(
          path: '/search',
          builder: (context, state) => const CardSearchPage(name: ''),
          routes: [
            GoRoute(
              path: '/search/:name',
              builder: (context, state) {
                final name = state.pathParameters['name'] ?? '';
                return CardSearchPage(name: name);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/card/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return CardDetailPage(id: id);
          },
        ),
      ],
    ),
  ],
);
