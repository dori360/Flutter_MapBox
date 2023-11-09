import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());
  
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapbox Users Location App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapboxUserLocationScreen(),
    );
  }
}

class MapboxUserLocationScreen extends StatefulWidget {
  @override
  _MapboxUserLocationScreenState createState() => _MapboxUserLocationScreenState();
}

class _MapboxUserLocationScreenState extends State<MapboxUserLocationScreen> {
  late MapboxMapController _mapController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Location _location = Location();
  bool _locationServiceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  _requestLocationPermission() async {
    _locationServiceEnabled = await _location.serviceEnabled();
    if (!_locationServiceEnabled) {
      _locationServiceEnabled = await _location.requestService();
      if (!_locationServiceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _getLocationData();
  }

  _getLocationData() async {
    _locationData = await _location.getLocation();
    _addLocationMarker();
  }

  _addLocationMarker() {
    if (_locationData != null) {
      _mapController.addSymbol(SymbolOptions(
        geometry: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        iconImage: 'assets/images/location_icon.png', // Add your location icon in the assets folder and update this path
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Location'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: Container(
        child: MapboxMap(
          onMapCreated: (controller) {
            _mapController = controller;
            // Load users and add symbols/markers to the map
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          accessToken: "pk.eyJ1IjoiZGFtb3NzIiwiYSI6ImNsbnVxeGMxbTBhcDYyd3Q5ZWQ5N3M1bGUifQ.KTJKQe_dCJCanby-xtsKZw", // replace with your Mapbox token
          styleString: "mapbox://styles/mapbox/streets-v11", // replace with your Mapbox style URL
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_locationData != null) {
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
                  zoom: 14.0,
                ),
              ),
            );
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('User Menu'),
          ),
          ListTile(
            title: Text('Sign Up'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Sign Up'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          // Add other fields as necessary
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                        TextButton(onPressed: () {
                          // Sign up logic goes here
                          Navigator.of(context).pop();
                        }, child: Text('Sign Up')),
                      ],
                    );
                  });
            },
          ),
          ListTile(
            title: Text('Sign In'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Sign In'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          // Add other fields as necessary
                        ],
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                        TextButton(onPressed: () {
                          // Sign in logic goes here
                          Navigator.of(context).pop();
                        }, child: Text('Sign In')),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}


/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions options = const FirebaseOptions(
    apiKey: "AIzaSyDH1Nz8XgAQafHrEgGfbtmj_cOF-oK_hxo",
    authDomain: "map1-b1a9c.firebaseapp.com",
    projectId: "map1-b1a9c",
    storageBucket: "map1-b1a9c.appspot.com",
    messagingSenderId: "617043144950",
    appId: "1:617043144950:web:c4d382c4bf3a4912b1fcd7",
    measurementId: "G-QM5KJDCMP7"
  );

  await Firebase.initializeApp();  // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users Map App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MapboxUserLocationScreenState createState() =>
      _MapboxUserLocationScreenState();
}

class _MapboxUserLocationScreenState extends State<MyHomePage> {
  MapboxMapController? _mapController;

  // Add this method to handle sign in
  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "your_email@gmail.com",  // Replace with your email
        password: "your_password",  // Replace with your password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  // Add this method to handle sign up
  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "your_email@gmail.com",  // Replace with your email
        password: "your_password",  // Replace with your password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // ...

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Sign Up'),
            onTap: () {
              // Handle sign up
              _signUp();
            },
          ),
          ListTile(
            title: const Text('Sign In'),
            onTap: () {
              // Handle sign in
              _signIn();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Location'),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Container(
        child: MapboxMap(
          onMapCreated: (controller) {
            _mapController = controller;
            // Load users and add symbols/markers to the map
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          accessToken: "pk.eyJ1IjoiZGFtb3NzIiwiYSI6ImNsbnVxeGMxbTBhcDYyd3Q5ZWQ5N3M1bGUifQ.KTJKQe_dCJCanby-xtsKZw",  // Replace with your Mapbox access token
        ),
      ),
    );
  }
}
*/ 