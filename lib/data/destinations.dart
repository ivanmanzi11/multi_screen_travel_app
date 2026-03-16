import '../models/destination_model.dart';

final List<String> categories = [
  'Popular',
  'Wildlife',
  'Adventure',
  'Nature',
];

final List<Destination> destinations = [
  Destination(
    id: '1',
    title: "Mountain Gorilla Tracking",
    location: "Volcanoes National Park",
    category: "Wildlife",
    description:
        "Experience an unforgettable encounter with the endangered mountain gorillas in Volcanoes National Park. Enjoy guided trekking through Rwanda's lush forests.",
    image: "assets/images/gorilla.jpg",
    price: 1500,
    rating: 4.9,
  ),
  Destination(
    id: '2',
    title: "Mount Karisimbi",
    location: "Northern Province",
    category: "Adventure",
    description:
        "Climb Rwanda’s highest volcano and enjoy breathtaking panoramic views.",
    image: "assets/images/kalisimbi.jpg",
    price: 800,
    rating: 4.7,
  ),
  Destination(
    id: '3',
    title: "Akagera National Park",
    location: "Eastern Province",
    category: "Wildlife",
    description:
        "Explore Rwanda’s only savannah park and discover the Big Five.",
    image: "assets/images/akagera.jpg",
    price: 1200,
    rating: 4.8,
  ),
  Destination(
    id: '4',
    title: "Nyungwe National Park",
    location: "Southern Province",
    category: "Nature",
    description:
        "Walk the famous canopy walkway and discover one of Africa’s oldest rainforests.",
    image: "assets/images/nyungwe.jpg",
    price: 950,
    rating: 4.6,
  ),
];