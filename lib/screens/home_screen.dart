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
  // ✅ Partner auto-scroll
  final ScrollController _partnerScrollController = ScrollController();
  Timer? _partnerTimer;

  String selectedCategory = categories.first;
  String searchText = '';
  final Set<String> favorites = {};

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final expertiseController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startPartnerAutoScroll();
  }

  void _startPartnerAutoScroll() {
    _partnerTimer?.cancel();

    _partnerTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_partnerScrollController.hasClients) return;

      final max = _partnerScrollController.position.maxScrollExtent;
      final next = _partnerScrollController.offset + 1;

      if (next >= max) {
        _partnerScrollController.jumpTo(0);
      } else {
        _partnerScrollController.jumpTo(next);
      }
    });
  }

  @override
  void dispose() {
    _partnerTimer?.cancel();
    _partnerScrollController.dispose();

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    expertiseController.dispose();
    messageController.dispose();

    super.dispose();
  }

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

  void submitForm() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    // ✅ Clear fields after submit
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    locationController.clear();
    expertiseController.clear();
    messageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Your request has been submitted successfully!"),
        backgroundColor: Colors.green,
      ),
    );
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

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Text(
          "Popular Destinations",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
      ),

      const SizedBox(height: 10),

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
                  builder: (_) => DetailScreen(destination: destination),
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
                "Discover breathtaking landscapes, unforgettable wildlife, and authentic cultural experiences with expertly guided tours.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// =====================
// 2) OUR SERVICES (Cards)
// =====================
Widget ourServicesSection() {
  const green = Color(0xFF1B5E20);

  Widget serviceCard({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 8),
            color: Color(0x14000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(
              imagePath,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
               Text(
  title,
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: Color(0xFF1B5E20),
  ),
),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                  ),
                  child: const Text("Read More"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
     const Text(
  "Our services",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1B5E20),
  ),
),
      const SizedBox(height: 8),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: const Text(
          "We provide travel planning services to help visitors explore Rwanda comfortably and efficiently.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
      const SizedBox(height: 30),

      LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 900;

          final cards = [
            serviceCard(
              title: "Tours",
              description:
                  "Explore Rwanda with guided experiences—from gorilla trekking to canopy walks and cultural highlights.",
              imagePath: "assets/images/gorilla.jpg",
            ),
            serviceCard(
              title: "Private Transport",
              description:
                  "Reliable vehicles, airport pickup, and experienced drivers so you can move easily across Rwanda.",
              imagePath: "assets/images/akagera.jpg",
            ),
            serviceCard(
              title: "Wildlife & Nature",
              description:
                  "Safaris in Akagera, rainforest adventures in Nyungwe, and Rwanda’s breathtaking landscapes.",
              imagePath: "assets/images/nyungwe.jpg",
            ),
            serviceCard(
              title: "Custom Planning",
              description:
                  "Personalized itineraries based on your interests, schedule, and travel style—stress free.",
              imagePath: "assets/images/kalisimbi.jpg",
            ),
          ];

          if (isSmall) {
            return Column(
              children: [
                for (int i = 0; i < cards.length; i++) ...[
                  cards[i],
                  const SizedBox(height: 20),
                ]
              ],
            );
          }

          // Big screens: 2 x 2 grid
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 20),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 20),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        },
      ),
    ],
  );
}

// =====================
// 3) WHY CHOOSE US
// =====================
Widget whyChooseUsSection() {
  const green = Color(0xFF1B5E20);

  Widget bullet({
    required String title,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
  title,
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Color(0xFF1B5E20),
  ),
),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
  "Why choose us?",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1B5E20),
  ),
),
      const SizedBox(height: 8),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: const Text(
          "We combine local expertise, personalized planning, and reliable travel support to help visitors experience Rwanda with confidence.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
      const SizedBox(height: 30),

      LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 900;

          final image = ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/akagera.jpg",
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );

          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bullet(
                title: "Local Expertise",
                text:
                    "We understand Rwanda’s destinations and logistics, helping you choose the best experiences.",
              ),
              bullet(
                title: "Personalized Planning",
                text:
                    "Every trip is tailored—wildlife, adventure, nature, or culture—based on your preferences.",
              ),
              bullet(
                title: "Reliable Support",
                text:
                    "From transport and stays to activities, we help coordinate key details so you can relax.",
              ),
            ],
          );

          if (isSmall) {
            return Column(
              children: [
                image,
                const SizedBox(height: 18),
                text,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: image),
              const SizedBox(width: 30),
              Expanded(child: text),
            ],
          );
        },
      ),
    ],
  );
}

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
              icon: Icons.directions_car,
              label: "Total Vehicles",
              value: "24",
            ),
          ),
          _statDivider(),
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
              label: "Avg Rating",
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
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: const Color(0xFF1B5E20)),
      const SizedBox(height: 6),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          color: Color(0xFF1B5E20),
        ),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black54,
          height: 1.2,
        ),
      ),
    ],
  );
}
  Widget partnersSection() {
    final partners = [
      "assets/images/partners/visit_rwanda.png",
      "assets/images/partners/rdb.png",
      "assets/images/partners/marriott.png",
      "assets/images/partners/airbnb.png",
      "assets/images/partners/rwandair.png",
    ];

    return Column(
      children: [
        const Text(
  "Our Trusted Partners",
  style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1B5E20),
  ),
),
        const SizedBox(height: 30),
        SizedBox(
          height: 80,
          child: ListView.builder(
            controller: _partnerScrollController, // ✅ controller added
            scrollDirection: Axis.horizontal,
            itemCount: partners.length * 20,
            itemBuilder: (context, index) {
              final logo = partners[index % partners.length];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset(
                  logo,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget customerReviewsSection() {
    return Column(
      children: [
       const Text(
  "Customer reviews",
  style: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1B5E20),
  ),
),
        const SizedBox(height: 10),
        const Text(
          "Discover what our clients think about our service",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(child: reviewCard(review1)),
            const SizedBox(width: 20),
            Expanded(child: reviewCard(review2)),
          ],
        ),
      ],
    );
  }

  Widget reviewCard(String text) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
              Icon(Icons.star, color: Colors.amber),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            text,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text(
            "Viator review",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget contactSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFFF5F7FA),
      child: Row(
        children: [
          Expanded(child: contactLeft()),
          const SizedBox(width: 40),
          Expanded(child: contactForm()),
        ],
      ),
    );
  }

  Widget contactLeft() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(
  "Connect with\nOur Team of Experts",
  style: TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1B5E20),
  ),
),
        SizedBox(height: 12),
        Text(
          "Contact our team of excellence-driven experts today to bring your trip to life.",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 25),
        Row(
          children: [
            Icon(Icons.phone, color: Color(0xFF1B5E20)),
            SizedBox(width: 10),
            Text("+250 780 123 321"),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.email, color: Color(0xFF1B5E20)),
            SizedBox(width: 10),
            Text("visit@rwanda.com"),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF1B5E20)),
            SizedBox(width: 10),
            Text("KG 220 St\nGishushu area\nKigali, Rwanda"),
          ],
        ),
      ],
    );
  }

  Widget contactForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B2C5F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: field("Full Name *", nameController)),
              const SizedBox(width: 12),
              Expanded(child: field("Email Address *", emailController)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: field("Phone Number *", phoneController)),
              const SizedBox(width: 12),
              Expanded(child: field("Location", locationController)),
            ],
          ),
          const SizedBox(height: 12),
          field("What expertise you're interested in?", expertiseController),
          const SizedBox(height: 12),
          messageField(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: submitForm,
              icon: const Icon(Icons.send),
              label: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget field(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: const Color(0xFF1B3F75),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget messageField() {
    return TextField(
      controller: messageController,
      maxLines: 4,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Tell us about your trip... *",
        hintStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: const Color(0xFF1B3F75),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget footerSection() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(18, 26, 18, 26),
    color: const Color(0xFF1B5E20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Visit Rwanda",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Premium guided tours, trusted drivers, and seamless bookings to explore Rwanda safely and comfortably.",
          style: TextStyle(color: Colors.white70, height: 1.4),
        ),
        const SizedBox(height: 18),

        const Text(
          "Social Media Platforms We Use",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            _socialChip(Icons.facebook, "Facebook"),
            const SizedBox(width: 10),
            _socialChip(Icons.camera_alt, "Instagram"),
            const SizedBox(width: 10),
            _socialChip(Icons.play_circle, "YouTube"),
          ],
        ),

        const SizedBox(height: 20),
        const Divider(color: Colors.white24),
        const SizedBox(height: 10),

        const Text(
          "© 2026 Visit Rwanda • All rights reserved",
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    ),
  );
}

Widget _socialChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.12),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white24),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    ),
  );
}

}

const review1 =
    "Harry was an amazing tour guide. It was below freezing all day, but he brought us to the best places and kept us warm. He has wide knowledge and is very invested in his clients having a great time.";

const review2 =
    "Our driver and guide Henry was excellent. He showed us 7 main sights and attractions in and around the town plus going to a restaurant for lunch. Henry was friendly and courteous while giving us flexibility in times for each location.";