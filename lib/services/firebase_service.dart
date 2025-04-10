import 'package:firebase_database/firebase_database.dart';
import '../models/sneaker.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("sneakers");

  Future<void> initializeDatabase() async {
    try {
      DataSnapshot snapshot = await _dbRef.get();

      if (snapshot.value == null) {
        print('No data found in Firebase, initializing with sample data...');
        await addSampleSneakers();
        print('Sample data added successfully!');
      } else {
        print('Data already exists in Firebase, skipping initialization.');
      }
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<List<Sneaker>> getSneakers() async {
    try {
      DataSnapshot snapshot = await _dbRef.get();

      if (snapshot.value == null) {
        return [];
      }

      if (snapshot.value is List) {
        List<dynamic> sneakersList = snapshot.value as List<dynamic>;
        List<Sneaker> sneakers = [];

        for (int i = 0; i < sneakersList.length; i++) {
          var value = sneakersList[i];
          if (value == null) {
            continue;
          }

          Map<String, dynamic> sneakerMap = {
            'id': i.toString(),
            'name': value['name'],
            'price':
                value['price'] is int
                    ? (value['price'] as int).toDouble()
                    : value['price'],
            'description': value['description'],
            'imageUrl': value['imageUrl'],
          };

          sneakers.add(Sneaker.fromMap(sneakerMap));
        }

        return sneakers;
      } else if (snapshot.value is Map) {
        Map<dynamic, dynamic> sneakersMap =
            snapshot.value as Map<dynamic, dynamic>;
        List<Sneaker> sneakers = [];

        sneakersMap.forEach((key, value) {
          if (value == null) {
            return;
          }

          Map<String, dynamic> sneakerMap = {
            'id': key.toString(),
            'name': value['name'],
            'price':
                value['price'] is int
                    ? (value['price'] as int).toDouble()
                    : value['price'],
            'description': value['description'],
            'imageUrl': value['imageUrl'],
          };

          sneakers.add(Sneaker.fromMap(sneakerMap));
        });

        return sneakers;
      }

      print('Unexpected data structure: ${snapshot.value.runtimeType}');
      return [];
    } catch (e) {
      print('Error fetching sneakers: $e');
      rethrow;
    }
  }

  Future<void> addSampleSneakers() async {
    List<Sneaker> sampleSneakers = Sneaker.getSampleSneakers();

    for (var sneaker in sampleSneakers) {
      await _dbRef.child(sneaker.id).set(sneaker.toMap());
    }
  }
}
