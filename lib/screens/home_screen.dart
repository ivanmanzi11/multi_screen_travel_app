import 'package:flutter/material.dart';
import '../data/destinations.dart';
import '../models/destination_model.dart';
import '../widgets/category_chip.dart';
import '../widgets/destination_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = categories.first;
  String searchText = '';
  final Set<String> favorites = {};

  List<Destination> get filtered {
    return destinations.where((d) {
      final matchCategory =
          selectedCategory == 'Popular' ? true : d.category == selectedCategory;

      final matchSearch =
          d.title.toLowerCase().contains(searchText.toLowerCase()) ||
              d.location.toLowerCase().contains(searchText.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 520 ? 2 : 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visit Rwanda',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header Text
            const Text(
              "Discover Rwanda",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Explore beautiful destinations and book your guided tour",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),

            // Search Bar (UI Only)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 14,
                    offset: Offset(0, 8),
                    color: Color(0x14000000),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search destinations...',
                      ),
                      onChanged: (value) {
                        setState(() => searchText = value);
                      },
                    ),
                  ),
                  if (searchText.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => searchText = ''),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Categories
            SizedBox(
              height: 46,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final category = categories[i];
                  return CategoryChip(
                    label: category,
                    selected: category == selectedCategory,
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // Grid of Destinations
            Expanded(
              child: GridView.builder(
                itemCount: filtered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (_, i) {
                  final destination = filtered[i];
                  final isFav = favorites.contains(destination.id);

                  return DestinationCard(
                    destination: destination,
                    isFavorite: isFav,
                    onFavoriteToggle: () {
                      setState(() {
                        if (isFav) {
                          favorites.remove(destination.id);
                        } else {
                          favorites.add(destination.id);
                        }
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailScreen(destination: destination),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}