import 'package:flutter/material.dart';
import '../models/sneaker.dart';
import '../widgets/sneaker_card.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  final Function(Sneaker) addToCart;

  const HomeScreen({super.key, required this.addToCart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late Future<List<Sneaker>> _sneakersFuture;

  @override
  void initState() {
    super.initState();
    _sneakersFuture = _firebaseService.getSneakers();
  }

  Future<void> _refreshSneakers() async {
    setState(() {
      _sneakersFuture = _firebaseService.getSneakers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Sneakers',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshSneakers,
                tooltip: 'Refresh from the database',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Sneaker>>(
              future: _sneakersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Error: ${snapshot.error}"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshSneakers,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("No sneakers found in database"),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshSneakers,
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                }

                final sneakers = snapshot.data!;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: sneakers.length,
                  itemBuilder: (context, index) {
                    return SneakerCard(
                      sneaker: sneakers[index],
                      onAddToCart: widget.addToCart,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
