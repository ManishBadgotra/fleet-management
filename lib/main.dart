import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // scrollDirection: Axis.horizontal, // this is can be changed for row view
      child: Column(
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
        ],
      ),
    );
  }
}

enum AlertType {
  okay,
  dueIn,
  overDue;

  @override
  String toString() {
    switch (this) {
      case AlertType.okay:
        return "Okay";
      case AlertType.dueIn:
        return "Due in";
      case AlertType.overDue:
        return "Overdue";
    }
  }
}

class FleetCard extends StatefulWidget {
  const FleetCard({
    super.key,
    required this.license,
    required this.vehicleModel,
    required this.voilation,
    required this.voilationText,
    required this.alertType,
  });
  final String license;
  final String voilation;
  final String voilationText;
  final String vehicleModel;
  // AlertType is needed to show alert according to type of Alert defined enum named AlertType.

  // If not given then it has default value to AlertType.overDue. Which means Document is Long Expired.
  final AlertType alertType;

  @override
  State<FleetCard> createState() => _FleetCardState();
}

class _FleetCardState extends State<FleetCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(24)),
        child: Stack(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          (widget.alertType == AlertType.okay)
                              ? "No Voilation"
                              : (widget.alertType == AlertType.dueIn)
                              ? "Expiring: ${widget.voilation}"
                              : "Voilation: ${widget.voilation}",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 8,
                            right: 12,
                            bottom: 8,
                            left: 12,
                          ),
                          decoration: BoxDecoration(
                            color: (widget.alertType == AlertType.okay)
                                ? Colors.green
                                : (widget.alertType == AlertType.dueIn)
                                ? Colors.amber[200]
                                : Colors.red[400],
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text(
                            widget.alertType.toString(),
                            style: TextStyle(
                              color: (widget.alertType == AlertType.okay)
                                  ? Colors.white
                                  : (widget.alertType == AlertType.dueIn)
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.license,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      widget.vehicleModel,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        (widget.alertType == AlertType.okay)
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ) /* okay */
                            : (widget.alertType == AlertType.dueIn)
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[400],
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.date_range_sharp,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ) /* due in */
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.dangerous,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ) /* overdue */,
                        const SizedBox(width: 8),
                        Text(
                          widget.voilationText,
                          style: TextStyle(
                            color: (widget.alertType == AlertType.okay)
                                ? Colors.black
                                : (widget.alertType == AlertType.dueIn)
                                ? Colors.amber
                                : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Container(
                  height: double.infinity,
                  width: 12,
                  color: (widget.alertType == AlertType.okay)
                      ? Colors.green
                      : (widget.alertType == AlertType.dueIn)
                      ? Colors.amberAccent
                      : Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
