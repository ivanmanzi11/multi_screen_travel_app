import 'dart:async';
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

  @override
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Visit Rwanda",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heroSection(),

            const SizedBox(height: 20),

            statisticsSection(),

            const SizedBox(height: 20),

            // 🔍 SEARCH
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search destinations...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() => searchText = value);
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🟢 CATEGORY CHIPS
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final category = categories[i];

                  return CategoryChip(
                    label: category,
                    selected: category == selectedCategory,
                    onTap: () {
                      setState(() => selectedCategory = category);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🟢 TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Popular Destinations",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🟢 GRID
            GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
    );
  }

  // 🔥 HERO SECTION
  Widget heroSection() {
    return Container(
      height: 450,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/rwanda.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.45),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Explore Rwanda Like Never Before",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 18),
              Text(
                "Discover breathtaking landscapes, unforgettable wildlife, and authentic cultural experiences.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 STATISTICS
  Widget statisticsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, 10),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _statItem(
                icon: Icons.place,
                label: "Destinations",
                value: "${destinations.length}",
              ),
            ),
            _statDivider(),
            Expanded(
              child: _statItem(
                icon: Icons.people,
                label: "Visitors",
                value: "12.8K",
              ),
            ),
            _statDivider(),
            Expanded(
              child: _statItem(
                icon: Icons.star,
                label: "Rating",
                value: "4.8",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statDivider() {
    return Container(
      width: 1,
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFFE5E7EB),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B5E20)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}