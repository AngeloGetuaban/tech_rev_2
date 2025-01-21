import 'package:flutter/material.dart';
import 'parts_of_system_unit.dart'; // Import the Parts of System Unit screen
import 'os_installation_screen.dart'; // Import the OS Installation screen
import 'network_configuration_screen.dart'; // Import the Modem Configuration screen

class ModulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modules'),
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey.shade100,
              ),
              child: Icon(
                Icons.memory, // Use a brain-like icon for representation
                size: 50,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 40),

            // Button for OS Installation
            buildModuleButton(
              context,
              icon: Icons.computer,
              label: "OS Installation",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OSInstallationScreen(), // Navigate to OS Installation
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Button for Modem Configuration
            buildModuleButton(
              context,
              icon: Icons.router,
              label: "Modem Configuration",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NetworkConfigurationScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Button for Parts of System Unit
            buildModuleButton(
              context,
              icon: Icons.memory,
              label: "Parts of System Unit",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartsOfSystemUnitScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable button builder
  Widget buildModuleButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade50,
        minimumSize: Size(double.infinity, 60), // Full width button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 20), // Left padding
          Icon(icon, color: Colors.blueGrey),
          SizedBox(width: 20), // Spacing between icon and text
          Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}