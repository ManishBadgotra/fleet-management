import 'package:flutter/material.dart';
import './models/vehicle.dart';
import 'models/fleet_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: const TextStyle(fontSize: 30),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "Fleet Management App",
      home: Scaffold(
        primary: true, // user can see status bar if false
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: const Icon(Icons.fire_truck),
          title: const Text(
            "Fleet Management",
            style: TextStyle(overflow: TextOverflow.clip),
          ),
        ),

        body: Listing(),
      ),
    );
  }
}

class Listing extends StatefulWidget {
  const Listing({super.key});

  @override
  State<Listing> createState() => ListingState();
}

class ListingState extends State<Listing> {
  final searchController = TextEditingController();

  final List<FleetCard> vehicles = [
    FleetCard(
      license: "UP14JT9486",
      voilation: "Permit Expired",
      voilationText: "Permit expired 10 days ago",
      vehicleModel: "BharatBenz - Diesel/BS6",
      alertType: AlertType.overDue,
    ),
    FleetCard(
      license: "UP14FL0581",
      voilation: "PUC Certificate",
      voilationText: "PUC Certificate expiring soon",
      vehicleModel: "Bajaj Pulsar - Petrol/BS6",
      alertType: AlertType.dueIn,
    ),
    FleetCard(
      license: "UP14FN0809",
      voilation: "All Okay",
      voilationText: "Nothings needs a view",
      vehicleModel: "Mahindra - Diesel/BS6",
      alertType: AlertType.okay,
    ),
    FleetCard(
      license: "UP14JT3320",
      voilation: "PUC Certificate",
      voilationText: "PUC Certificate expiring soon",
      vehicleModel: "ASHOK LEYLAND DOST - CNG/BS4",
      alertType: AlertType.dueIn,
    ),
    FleetCard(
      license: "UP14NT8943",
      voilation: "All Okay",
      voilationText: "Nothings needs a view",
      vehicleModel: "ASHOK LEYLAND DOST+ - CNG/BS6",
      alertType: AlertType.okay,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            hintText: "Search Eg: TMXXXXXX",

            elevation: WidgetStatePropertyAll(4),
            leading: Icon(Icons.search_outlined),
            onChanged: (value) {
              // needs to implement search feature
              print(searchController.text);
            },
            controller: searchController,
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              int columns = 1;
              double spacing = 8;

              double totalSpacing = (columns - 1) * spacing;
              var itemWidth = (constraints.maxWidth - totalSpacing) / columns;

              double itemHeight = 180;
              double aspectRation = itemWidth / itemHeight;
              print("----- ${constraints.maxWidth}-----");
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: spacing,
                  crossAxisCount: columns,
                  childAspectRatio: aspectRation,
                  mainAxisSpacing: spacing,
                ),
                itemBuilder: (context, index) => vehicles[index],
                itemCount: vehicles.length,
              );
            },
          ),
        ),
        // const SizedBox(height: 8),
      ],
    );
  }
}
