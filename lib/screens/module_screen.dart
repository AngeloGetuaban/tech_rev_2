import 'package:flutter/material.dart';
import 'assemble_disassemble_screen.dart'; // Import the Assemble/Disassemble screen
import 'parts_of_system_unit.dart'; // Import the Parts of System Unit screen
import 'os_installation_screen.dart'; // Import the OS Installation screen
import 'network_configuration_screen.dart'; // Import the Modem Configuration screen

class ModulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modules'),
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey.shade100.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.memory, // Use a brain-like icon for representation
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),

              // Button for Assemble/Disassemble
              buildModuleButton(
                context,
                icon: Icons.build,
                label: "ASSEMBLE/DISASSEMBLE",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssembleDisassembleScreen(), // Navigate to Assemble/Disassemble
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

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
      ),
    );
  }

  // Reusable button builder
  Widget buildModuleButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [Colors.blueGrey[600]!, Colors.blueGrey[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20), // Left padding
            Icon(icon, color: Colors.white),
            SizedBox(width: 20), // Spacing between icon and text
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}