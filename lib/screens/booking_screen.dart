import 'package:flutter/material.dart';
import 'package:multi_screen_travel_app/models/destination_model.dart';

class BookingScreen extends StatefulWidget {
  final Destination destination;

  const BookingScreen({super.key, required this.destination});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  int guests = 1;
  bool insurance = false;

  DateTime? selectedDate;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  double get totalPrice {
    double base = widget.destination.price * guests;
    if (insurance) base += 20;
    return base;
  }

  String get dateText {
    if (selectedDate == null) return "Select a date";
    return "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}";
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void increaseGuests() {
    setState(() {
      guests++;
    });
  }

  void decreaseGuests() {
    if (guests > 1) {
      setState(() {
        guests--;
      });
    }
  }

  void confirmBooking() {

  setState(() {
    guests = 1;
    insurance = false;
    selectedDate = null;

    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Booking confirmed!"),
    ),
  );

  Navigator.pop(context);
}

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
  iconTheme: const IconThemeData(color: Colors.green),
  title: const Text(
    "Booking",
    style: TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold,
    ),
  ),
  backgroundColor: Colors.white,
  elevation: 0,
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Destination Card
            card(
              child: Row(
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.destination.image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        widget.destination.title,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(widget.destination.location),

                      const SizedBox(height: 4),

                      Text(
                        "Base: \$${widget.destination.price} / guest",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Trip Details
            sectionTitle("Trip Details"),

            card(
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text("Travel Date"),
                    trailing: Text(dateText),
                    onTap: pickDate,
                  ),

                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        "Guests",
                        style: TextStyle(fontSize: 16),
                      ),

                      Row(
                        children: [

                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: decreaseGuests,
                          ),

                          Text(
                            "$guests",
                            style: const TextStyle(fontSize: 16),
                          ),

                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: increaseGuests,
                          ),

                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 24),

            // Traveler Information
            sectionTitle("Traveler Information"),

            card(
              child: Column(
                children: [

                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 24),

            // Extras
            sectionTitle("Extras"),

            card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [

                      Text(
                        "Travel Insurance",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text("+ \$20 flat fee"),

                    ],
                  ),

                  Switch(
                    value: insurance,
                    onChanged: (v) {
                      setState(() {
                        insurance = v;
                      });
                    },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 24),

            // Total
            sectionTitle("Total"),

            card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Total Price",
                    style: TextStyle(fontSize: 16),
                  ),

                  Text(
                    "\$${totalPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 30),

            // Confirm Button
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
    onPressed: confirmBooking,
    child: const Text(
      "Complete Booking",
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}