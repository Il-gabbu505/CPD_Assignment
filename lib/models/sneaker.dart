class Sneaker {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Sneaker({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Sneaker.fromMap(Map<String, dynamic> map) {
    return Sneaker(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price:
          map['price'] is int
              ? (map['price'] as int).toDouble()
              : (map['price'] ?? 0.0),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  static List<Sneaker> getSampleSneakers() {
    return [
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
}
