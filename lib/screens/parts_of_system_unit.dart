import 'package:flutter/material.dart';

class PartsOfSystemUnitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parts of System Unit'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          // Introductory Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book, size: 40, color: Colors.blueGrey),
                  SizedBox(width: 10),
                  Text(
                    "LESSON",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "The system unit is the box-like case that contains the electronic components of a computer including the motherboard, CPU, RAM, and other components. The system unit also includes the case that houses the internal components of the computer. Many people erroneously refer to this as the CPU.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
            ],
          ),
          Divider(),
          // Motherboard
          buildPartTile(
            context,
            title: "Motherboard",
            description:
            "Sometimes called the system board or main board. It is the main circuit board of a microcomputer, containing connectors for attaching additional boards.",
            image: "assets/motherboard2.jpg",
          ),
          Divider(),
          // Power Supply Unit
          buildPartTile(
            context,
            title: "Power Supply Unit",
            description:
            "This is the device that supplies power to your personal computer. It regulates voltage to eliminate spikes and surges in electrical systems.",
            image: "assets/power_supply2.jpg",
          ),
          Divider(),
          // Hard Disk Drive
          buildPartTile(
            context,
            title: "Hard Disk Drive",
            description:
            "The computer's main storage device used to store all data permanently. HDDs can be SATA (Serial ATA) or EIDE (Enhanced Integrated Drive Electronics).",
            image: "assets/hard_drive2.jpg",
          ),
          Divider(),
          // Optical Disk Drive
          buildPartTile(
            context,
            title: "Optical Disk Drive",
            description:
            "Allows a user to retrieve, edit, and delete content from optical disks such as CDs, DVDs, and Blu-ray disks. Available in SATA and EIDE types.",
            image: "assets/optical_disk2.jpg",
          ),
          Divider(),
          // RAM
          buildPartTile(
            context,
            title: "RAM (Random Access Memory)",
            description:
            "The memory that stores data temporarily while the machine is working. It allows data to be accessed randomly.",
            image: "assets/ram2.jpg",
          ),
          Divider(),
          // CPU
          buildPartTile(
            context,
            title: "CPU (Central Processing Unit)",
            description:
            "The brain of the computer, responsible for processing arithmetic and logical operations. It runs the operating system and applications.",
            image: "assets/cpu2.jpg",
          ),
          Divider(),
          // CPU Cooling System
          buildPartTile(
            context,
            title: "CPU Cooling System",
            description:
            "Designed to reduce the CPU's temperature to keep it running in good condition. Includes CPU fans and heatsinks.",
            image: "assets/cooling_system2.jpg",
          ),
        ],
      ),
    );
  }

  Widget buildPartTile(BuildContext context,
      {required String title, required String description, required String image}) {
    return ListTile(
      leading: Image.asset(
        image,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(description),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              title: title,
              description: description,
              image: image,
            ),
          ),
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  DetailPage({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                image,
                width: 500,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
