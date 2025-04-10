import 'package:flutter/material.dart';
import '../models/sneaker.dart';
import '../widgets/sneaker_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(Sneaker) addToCart;

  const HomeScreen({super.key, required this.addToCart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Sneaker> _sneakers = [];

  @override
  void initState() {
    super.initState();
    _loadSneakers();
  }

  void _loadSneakers() {
    _sneakers = [
      Sneaker(
        id: '1',
        name: 'Air Max 90',
        price: 120.00,
        description:
            'The mesh upper with leather overlays provide a snug fit and high breathability',
        imageUrl: 'assets/images/air_max_90.jpg',
      ),
      Sneaker(
        id: '2',
        name: 'Ultraboost 22',
        price: 180.00,
        description:
            'Ultraboost running shoes serve up comfort and responsiveness. You will be riding on a BOOST midsole for endless energy, with a Linear Energy Push system and a Continental Rubber outsole.',
        imageUrl: 'assets/images/ultraboost_22.png',
      ),
      Sneaker(
        id: '3',
        name: 'Converse',
        price: 55.00,
        description:
            'Converse is an American lifestyle brand that markets, distributes, and licenses footwear, apparel, and accessories.',
        imageUrl: 'assets/images/converse.jpg',
      ),
      Sneaker(
        id: '4',
        name: 'Jordan 1',
        price: 170.00,
        description:
            'Air Jordan is a line of basketball and sportswear shoes produced by Nike, Inc. Related apparel and accessories are marketed under Jordan Brand.',
        imageUrl: 'assets/images/jordan_1.jpg',
      ),
    ];
  }

  void _refreshSneakers() {
    setState(() {
      _loadSneakers();
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
                tooltip: 'Refresh',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                _sneakers.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("No sneakers available"),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshSneakers,
                            child: const Text('Reload'),
                          ),
                        ],
                      ),
                    )
                    : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: _sneakers.length,
                      itemBuilder: (context, index) {
                        return SneakerCard(
                          sneaker: _sneakers[index],
                          onAddToCart: widget.addToCart,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
