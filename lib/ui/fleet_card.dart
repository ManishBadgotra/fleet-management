import 'package:flutter/material.dart';

import '../models/vehicle.dart';

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
  // Alert system is dependent on alertType if incorret alert type will be given then no matter what data is coming card will display wrong alert
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
        borderRadius: BorderRadius.all(Radius.circular(24)),
        child: Stack(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .max,
                  children: [
                    Row(
                      mainAxisSize: .max,
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
                          // maxLines: 2,
                          softWrap: true,
                          // overflow: TextOverflow.clip,
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
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 12,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(
                    color: (widget.alertType == AlertType.okay)
                        ? Colors.green
                        : (widget.alertType == AlertType.dueIn)
                        ? Colors.amberAccent
                        : Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
