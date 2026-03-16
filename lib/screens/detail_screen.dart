import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../widgets/rating_widget.dart';
import 'booking_screen.dart';

class DetailScreen extends StatelessWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  static const Color green = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          _heroAppBar(context),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topInfoRow(),
                  const SizedBox(height: 16),

                  _sectionTitle("About"),
                  const SizedBox(height: 8),
                  _card(
                    child: Text(
                      destination.description,
                      style: const TextStyle(height: 1.5, color: Colors.black87),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ✅ Akagera-style sections (works for all destinations)
                  _sectionTitle("Quick Facts"),
                  const SizedBox(height: 8),
                  _quickFacts(),

                  const SizedBox(height: 18),

                  _sectionTitle("Best Time To Visit"),
                  const SizedBox(height: 8),
                  _card(child: Text(_bestTimeText(destination.id), style: const TextStyle(height: 1.5))),

                  const SizedBox(height: 18),

                  _sectionTitle("Activities"),
                  const SizedBox(height: 8),
                  _card(child: _activitiesList(destination.id)),

                  const SizedBox(height: 18),

                  const SizedBox(height: 18),

_sectionTitle("Photo Gallery"),
const SizedBox(height: 8),
_photoGallery(),

const SizedBox(height: 24),   // 👈 add this

_sectionTitle("Pros & Cons"),
                  const SizedBox(height: 8),
                  _card(child: _prosCons(destination.id)),

                  const SizedBox(height: 18),

                  _sectionTitle("Reviews"),
                  const SizedBox(height: 8),
                  _card(child: _reviewBox(context)),

                  const SizedBox(height: 20),

                  // ✅ Book now button (same as before)
                Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingScreen(destination: destination),
        ),
      );
    },
    child: const Text(
      "Book Now",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
  ),
),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HERO (banner) ----------------
  SliverAppBar _heroAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: IconButton(
  icon: const Icon(
    Icons.arrow_back,
    color: Color(0xFF2E7D32),
  ),
  onPressed: () => Navigator.pop(context),
),
      flexibleSpace: FlexibleSpaceBar(
  title: Text(
    destination.title,
    style: const TextStyle(
      color: Color(0xFF2E7D32), // Rwanda-style green
      fontWeight: FontWeight.bold,
    ),
  ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(destination.image, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TOP INFO ----------------
  Widget _topInfoRow() {
    return _card(
      child: Row(
        children: [
          Expanded(
            child: _infoTile(
              icon: Icons.place,
              title: "Location",
              value: destination.location,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _infoTile(
              icon: Icons.attach_money,
              title: "Price",
              value: "\$${destination.price.toStringAsFixed(0)}",
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _infoTile(
              icon: Icons.star,
              title: "Rating",
              value: destination.rating.toStringAsFixed(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: green.withOpacity(0.12),
          child: Icon(icon, size: 16, color: green),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- SECTION TITLE ----------------
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: green,
      ),
    );
  }

  // ---------------- CARD WRAPPER ----------------
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 8)),
        ],
      ),
      child: child,
    );
  }

  // ---------------- QUICK FACTS ----------------
  Widget _quickFacts() {
    final facts = _factsFor(destination.id);

    return Column(
      children: facts.map((f) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: green.withOpacity(0.12),
                child: Icon(f.icon, size: 14, color: green),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(f.title, style: const TextStyle(fontWeight: FontWeight.w700))),
              Text(f.value, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<_Fact> _factsFor(String id) {
    // id: 1 gorilla, 2 kalisimbi, 3 akagera, 4 nyungwe (from your destinations.dart)
    if (id == '3') {
      return const [
        _Fact(Icons.calendar_month, "Best Time", "Jun – Sep"),
        _Fact(Icons.people, "High Season", "Weekends"),
        _Fact(Icons.map, "Size", "1,122 km²"),
        _Fact(Icons.terrain, "Altitude", "1,286–1,718m"),
      ];
    }
    if (id == '1') {
      return const [
        _Fact(Icons.calendar_month, "Best Time", "All year"),
        _Fact(Icons.hiking, "Trek", "2–6 hours"),
        _Fact(Icons.forest, "Habitat", "Rainforest"),
        _Fact(Icons.groups, "Group Size", "Small"),
      ];
    }
    if (id == '2') {
      return const [
        _Fact(Icons.calendar_month, "Best Time", "Dry season"),
        _Fact(Icons.terrain, "Difficulty", "High"),
        _Fact(Icons.timer, "Duration", "2 days"),
        _Fact(Icons.landscape, "Views", "Panoramic"),
      ];
    }
    return const [
      _Fact(Icons.calendar_month, "Best Time", "Dry season"),
      _Fact(Icons.forest, "Famous for", "Canopy Walk"),
      _Fact(Icons.bug_report, "Wildlife", "Primates"),
      _Fact(Icons.eco, "Ecosystem", "Rainforest"),
    ];
  }

  // ---------------- TEXTS ----------------
  String _bestTimeText(String id) {
    if (id == '3') {
      return "Akagera can be visited year-round, but the best wildlife viewing is during the Dry Season.";
    }
    if (id == '1') {
      return "Gorilla tracking is possible all year. Dry seasons usually make hiking easier.";
    }
    if (id == '2') {
      return "Mount Karisimbi is best climbed in drier months for safer trails and clearer views. Early mornings are colder.";
    }
    return "Nyungwe is beautiful year-round. Dry seasons are easier for hiking and canopy walks.";
  }

  Widget _activitiesList(String id) {
    final items = _activitiesFor(id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((t) => _bullet(t)).toList(),
    );
  }

  List<String> _activitiesFor(String id) {
    if (id == '3') {
      return const [
        "Day game drives to spot the Big Five and plains animals",
        "Boat trip on Lake Ihema for hippos and crocodiles",
        "Birding (one of Rwanda’s top birding locations)",
        "Sunset drive for savannah views",
      ];
    }
    if (id == '1') {
      return const [
        "Guided gorilla trek through Volcanoes forests",
        "Photography moments with strict conservation rules",
        "Optional cultural visit near the park",
      ];
    }
    if (id == '2') {
      return const [
        "Volcano hiking with expert guides",
        "Summit views and crater landscapes",
        "Overnight camping experience (if included)",
      ];
    }
    return const [
      "Canopy walkway experience above the rainforest",
      "Chimpanzee and primate trekking",
      "Nature hikes to waterfalls and viewpoints",
      "Bird watching",
    ];
  }

  Widget _prosCons(String id) {
    final pros = _prosFor(id);
    final cons = _consFor(id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...pros.map((t) => _prosConsRow(true, t)),
        const SizedBox(height: 12),
        ...cons.map((t) => _prosConsRow(false, t)),
      ],
    );
  }

  List<String> _prosFor(String id) {
    if (id == '3') return const ["Big Five chances", "Beautiful lakes + savannah", "Great boat safari"];
    if (id == '1') return const ["Once-in-a-lifetime gorilla encounter", "Highly protected experience", "Strong guides"];
    if (id == '2') return const ["Amazing challenge", "Top views", "Memorable hiking trip"];
    return const ["Canopy walk is unique", "Rich rainforest scenery", "Great primates + birds"];
  }

  List<String> _consFor(String id) {
    if (id == '3') return const ["Big cats may be harder to spot sometimes", "Dusty roads in dry season"];
    if (id == '1') return const ["Permit cost can be high", "Hike can be tiring"];
    if (id == '2') return const ["Physically demanding", "Cold at night"];
    return const ["Rain can be frequent", "Some trails are steep"];
  }

  Widget _prosConsRow(bool isPro, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPro ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: isPro ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }

  Widget _reviewBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RatingStars(rating: destination.rating),
            const SizedBox(width: 10),
            Text("${destination.rating.toStringAsFixed(1)} / 5",
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 10),
        Text(
  _reviewText(destination.id),
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(fontSize: 14, height: 1.4),
),
        GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Full Review"),
          content: Text(_reviewText(destination.id)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  },
  child: const Text(
    "Full Review",
    style: TextStyle(
      color: green,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.underline,
    ),
  ),
)
      ],
    );
  }

  String _reviewText(String id) {

  if (id == '3') {
    return "Akagera National Park offers one of the most rewarding safari experiences in Rwanda. "
        "During our visit we explored beautiful savannah landscapes, rolling hills, and lakes filled with hippos and crocodiles. "
        "The park is extremely well managed and the game drives were smooth and enjoyable. "
        "We were able to spot giraffes, zebras, antelopes, buffalo, and even lions in the distance. "
        "Our guide was very knowledgeable about wildlife behavior and conservation efforts in the park. "
        "What makes Akagera special is the combination of wildlife, scenery, and peaceful surroundings. "
        "It’s a fantastic destination for anyone who wants a classic African safari without large crowds.";
  }

  if (id == '1') {
    return "The gorilla trekking experience in Volcanoes National Park was truly unforgettable. "
        "The hike through the forest was challenging but exciting, and the guides were incredibly supportive throughout the journey. "
        "Once we found the gorilla family, we were able to observe them calmly interacting with each other in their natural habitat. "
        "Seeing these magnificent animals up close was emotional and inspiring. "
        "The conservation efforts in Rwanda are impressive and the park staff clearly care deeply about protecting these endangered gorillas. "
        "This experience is something every wildlife lover should try at least once in their lifetime.";
  }

  if (id == '2') {
    return "Climbing Mount Karisimbi was both challenging and rewarding. "
        "The hike takes you through beautiful volcanic landscapes, forests, and open terrain with breathtaking views of the surrounding region. "
        "The guides were professional and ensured that everyone in the group stayed safe and comfortable. "
        "Reaching the summit felt like a huge accomplishment and the panoramic scenery made the effort worthwhile. "
        "This adventure is perfect for travelers who enjoy hiking and want to experience Rwanda's volcanic mountains.";
  }

  return "Nyungwe National Park is one of Africa's most beautiful rainforests. "
      "Walking through the canopy walkway gives you a unique view of the forest from above the trees. "
      "The park is full of wildlife including monkeys, birds, and many rare plant species. "
      "The peaceful atmosphere and cool mountain air make Nyungwe a perfect destination for nature lovers and photographers. "
      "Guided walks through the forest provide fascinating insights into the ecosystem and the importance of conservation.";
}

  Widget _bullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "• ",
          style: TextStyle(
            fontSize: 18,
            color: green,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(height: 1.4),
          ),
        ),
      ],
    ),
  );
}

Widget _photoGallery() {
  final images = _galleryImages(destination.id);

  return SizedBox(
    height: 160,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _openImage(context, images[index]);
          },
          child: Container(
            width: 220,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(images[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    ),
  );
}
 
void _openImage(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (_) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: InteractiveViewer(
            child: Image.asset(imagePath),
          ),
        ),
      );
    },
  );
}

 List<String> _galleryImages(String id) {

  if (id == '3') {
    return [
      "assets/images/details/akagera_map.png",
      "assets/images/details/akagera_1.jpg",
      "assets/images/details/akagera_2.jpg",
      "assets/images/details/akagera_3.jpg",
      "assets/images/details/akagera_4.jpg",
      "assets/images/details/akagera_5.jpg",
      "assets/images/details/akagera_6.jpg",
    ];
  }

  if (id == '1') {
    return [
      "assets/images/details/gorilla_map.png",
      "assets/images/details/gorilla_1.jpg",
      "assets/images/details/gorilla_2.jpg",
      "assets/images/details/gorilla_3.jpg",
      "assets/images/details/gorilla_4.jpg",
      "assets/images/details/gorilla_5.jpg",
      "assets/images/details/gorilla_6.jpg",
    ];
  }

  if (id == '2') {
    return [
      "assets/images/details/kalisimbi_map.png",
      "assets/images/details/kalisimbi_1.jpg",
      "assets/images/details/kalisimbi_2.jpg",
      "assets/images/details/kalisimbi_3.jpg",
      "assets/images/details/kalisimbi_4.webp",
      "assets/images/details/kalisimbi_5.jpg",
      "assets/images/details/kalisimbi_6.png",
    ];
  }

  return [
    "assets/images/details/nyungwe_map.png",
    "assets/images/details/nyungwe_1.jpg",
    "assets/images/details/nyungwe_2.jpg",
    "assets/images/details/nyungwe_3.png",
    "assets/images/details/nyungwe_4.jpg",
    "assets/images/details/nyungwe_5.webp",
    "assets/images/details/nyungwe_6.jpg",
  ];
}

}

class _Fact {
  final IconData icon;
  final String title;
  final String value;
  const _Fact(this.icon, this.title, this.value);
}