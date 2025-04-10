import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_service.dart';
import 'screens/home_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'screens/camera_screen.dart';
import 'models/sneaker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseService = FirebaseService();
  await firebaseService.initializeDatabase();

  AwesomeNotifications().initialize('resource://drawable/res_default_icon', [
    NotificationChannel(
      channelKey: 'cart_channel',
      channelName: 'Cart Notifications',
      channelDescription: 'Notifies when a sneaker is added to the cart',
      defaultColor: Color(0xFF9D50DD),
      ledColor: Colors.white,
      importance: NotificationImportance.High,
      soundSource: 'asset://sounds/notification_sound.mp3',
    ),
  ]);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  final cameras = await availableCameras();

  runApp(SneakerApp(cameras: cameras));
}

class SneakerApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const SneakerApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sneaker Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SneakerAppHome(cameras: cameras),
    );
  }
}

class SneakerAppHome extends StatefulWidget {
  final List<CameraDescription> cameras;

  const SneakerAppHome({super.key, required this.cameras});

  @override
  _SneakerAppHomeState createState() => _SneakerAppHomeState();
}

class _SneakerAppHomeState extends State<SneakerAppHome> {
  int _selectedIndex = 0;
  final List<Sneaker> _cartItems = [];

  void addToCart(Sneaker sneaker) {
    setState(() {
      _cartItems.add(sneaker);
    });

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'cart_channel',
        title: 'Sneaker Added',
        body: '${sneaker.name} has been added to your cart!',
        notificationLayout: NotificationLayout.Default,
        icon: 'resource://drawable/ic_notification',
        backgroundColor: Color(0xFF9D50DD),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(addToCart: addToCart),
      CameraScreen(cameras: widget.cameras),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sneaker Shop'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Your Cart'),
                          content:
                              _cartItems.isEmpty
                                  ? const Text('Your cart is empty')
                                  : SizedBox(
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _cartItems.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: Image.asset(
                                            _cartItems[index].imageUrl,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(_cartItems[index].name),
                                          subtitle: Text(
                                            '\$${_cartItems[index].price}',
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Try On',
          ),
        ],
      ),
    );
  }
}
