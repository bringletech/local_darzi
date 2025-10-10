import 'package:flutter/material.dart';

class ActiveDressesScreen extends StatefulWidget {
  final Map<String, dynamic> response;
  const ActiveDressesScreen({super.key, required this.response});

  @override
  State<ActiveDressesScreen> createState() => _ActiveDressesScreenState();
}

class _ActiveDressesScreenState extends State<ActiveDressesScreen> {
  Map<String, dynamic> get data => widget.response;

  // Expansion control
  final Map<String, bool> _expanded = {
    "Today": false,
    "This Week": false,
    "Next Week": false,
    "Later": false,
  };

  @override
  Widget build(BuildContext context) {
    // Order data
    final orders = data["ActiveDresses"] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Active Dresses",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final section = orders[index];
          final title = section["title"];
          final items = section["orders"] as List<dynamic>;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.orange,
              collapsedBackgroundColor: Colors.orange,
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              textColor: Colors.white,
              collapsedTextColor: Colors.white,
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: items.isEmpty
                  ? [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("No Orders",
                      style: TextStyle(color: Colors.black54)),
                )
              ]
                  : items.map((order) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // Dress image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          order["dressImgUrl"] ?? "",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 60,
                            width: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, size: 30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Order details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order["name"] ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            if (order["dressName"] != null)
                              Text(order["dressName"],
                                  style: const TextStyle(
                                      color: Colors.black54)),
                            Text("Due: ${order["dueDate"]}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.red)),
                            Text(
                              "Balance: ₹${order["outstandingBalance"]}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
