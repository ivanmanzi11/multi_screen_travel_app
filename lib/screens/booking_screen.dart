import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../widgets/custom_button.dart';

class BookingScreen extends StatefulWidget {
  final Destination destination;

  const BookingScreen({super.key, required this.destination});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int guests = 1;
  String date = 'May 10, 2026';
  bool insurance = false;

  @override
  Widget build(BuildContext context) {
    final total =
        widget.destination.price * guests + (insurance ? 20 : 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 16,
                      offset: Offset(0, 8),
                      color: Color(0x14000000)),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      widget.destination.image,
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(widget.destination.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(widget.destination.location),
                        const SizedBox(height: 6),
                        Text(
                            'Base: \$${widget.destination.price.toStringAsFixed(0)} / guest'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _tile(
                    title: 'Travel Date',
                    trailing: Text(date),
                    onTap: () =>
                        setState(() => date = 'May 12, 2026'),
                  ),
                  _tile(
                    title: 'Guests',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: guests > 1
                              ? () => setState(() => guests--)
                              : null,
                          icon: const Icon(
                              Icons.remove_circle_outline),
                        ),
                        Text('$guests',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800)),
                        IconButton(
                          onPressed: () =>
                              setState(() => guests++),
                          icon: const Icon(
                              Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    value: insurance,
                    onChanged: (v) =>
                        setState(() => insurance = v),
                    title: const Text('Add travel insurance'),
                    subtitle:
                        const Text('+ \$20 flat fee'),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w900)),
                        const SizedBox(height: 6),
                        Text(
                            '\$${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.w900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              text: 'Confirm Booking',
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Booking confirmed! ✅')),
                );
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Success'),
                    content: Text(
                        'Your booking for ${widget.destination.title} is confirmed.'),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
      {required String title,
      required Widget trailing,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800)),
            trailing,
          ],
        ),
      ),
    );
  }
}