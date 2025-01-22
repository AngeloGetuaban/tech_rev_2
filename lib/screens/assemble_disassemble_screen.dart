import 'package:flutter/material.dart';

class AssembleDisassembleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assemble/Disassemble PC'),
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Personal Computer Assembly and Disassembly',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 20),

            // Disassembly Section
            // Disassembly Section
            _buildSectionTitle('Disassembly Steps', Icons.build),
            _buildStep(
              stepNumber: 1,
              title: 'Unplugging',
              description: 'Unplug every cable connected to the computer, including power, USB, mouse, keyboard, and other peripherals.',
              icon: Icons.power_settings_new,
            ),
            _buildStep(
              stepNumber: 2,
              title: 'Opening the Case',
              description: 'Unscrew the four screws at the back of the computer case and remove the side panels.',
              icon: Icons.build,
            ),
            _buildStep(
              stepNumber: 3,
              title: 'Removing the System Fan',
              description: 'Unplug the fan from the motherboard and unscrew it from the case. Carefully lift the fan out.',
              icon: Icons.air,
            ),
            _buildStep(
              stepNumber: 4,
              title: 'Removing the CPU Fan',
              description: 'Unplug the CPU fan from the motherboard and remove the screws securing it to the heat sink.',
              icon: Icons.memory,
            ),
            _buildStep(
              stepNumber: 5,
              title: 'Removing the Power Supply',
              description: 'Unplug all wires connected to the power supply and unscrew it from the case. Lift it out carefully.',
              icon: Icons.battery_charging_full,
            ),
            _buildStep(
              stepNumber: 6,
              title: 'Removing the CD/DVD Drive',
              description: 'Unplug the ribbon cable and power connector from the drive. Push the drive out from the inside.',
              icon: Icons.disc_full,
            ),
            _buildStep(
              stepNumber: 7,
              title: 'Removing the Hard Drive',
              description: 'Unplug the SATA cable and power connector. Unscrew the hard drive from its slot and remove it.',
              icon: Icons.storage,
            ),
            _buildStep(
              stepNumber: 8,
              title: 'Removing the RAM',
              description: 'Push down on the tabs at both ends of the RAM module to release it, then lift it out.',
              icon: Icons.memory,
            ),
            _buildStep(
              stepNumber: 9,
              title: 'Removing the Motherboard',
              description: 'Unscrew the motherboard from the case and disconnect all cables. Lift it out carefully.',
              icon: Icons.developer_board,
            ),
            _buildStep(
              stepNumber: 10,
              title: 'Final Check',
              description: 'Ensure all components are safely removed and stored. Clean the case if necessary.',
              icon: Icons.check_circle,
            ),
            SizedBox(height: 30),

            // Assembly Section
            _buildSectionTitle('Assembly Steps', Icons.construction),
            _buildStep(
              stepNumber: 1,
              title: 'Prepare the Case',
              description: 'Ensure the case is clean and ready for installation. Place it on a flat, stable surface.',
              icon: Icons.cleaning_services,
            ),
            _buildStep(
              stepNumber: 2,
              title: 'Install the Power Supply',
              description: 'Place the power supply in its slot and secure it with screws. Connect the necessary cables.',
              icon: Icons.power,
            ),
            _buildStep(
              stepNumber: 3,
              title: 'Install the Motherboard',
              description: 'Place the motherboard in the case and secure it with screws. Connect all cables.',
              icon: Icons.developer_board,
            ),
            _buildStep(
              stepNumber: 4,
              title: 'Install the CPU and CPU Fan',
              description: 'Place the CPU in its socket and attach the CPU fan. Connect the fan to the motherboard.',
              icon: Icons.memory,
            ),
            _buildStep(
              stepNumber: 5,
              title: 'Install the RAM',
              description: 'Insert the RAM modules into their slots and press down until they click into place.',
              icon: Icons.sd_storage,
            ),
            _buildStep(
              stepNumber: 6,
              title: 'Install the Hard Drive',
              description: 'Place the hard drive in its slot and secure it with screws. Connect the SATA and power cables.',
              icon: Icons.storage,
            ),
            _buildStep(
              stepNumber: 7,
              title: 'Install the CD/DVD Drive',
              description: 'Insert the drive into its slot and secure it. Connect the ribbon cable and power connector.',
              icon: Icons.disc_full,
            ),
            _buildStep(
              stepNumber: 8,
              title: 'Install the System Fan',
              description: 'Place the fan in its slot and secure it with screws. Connect it to the motherboard.',
              icon: Icons.air,
            ),
            _buildStep(
              stepNumber: 9,
              title: 'Connect Peripherals',
              description: 'Connect the keyboard, mouse, monitor, and other peripherals to the computer.',
              icon: Icons.keyboard,
            ),
            _buildStep(
              stepNumber: 10,
              title: 'Power On and Test',
              description: 'Plug in the power cable and turn on the computer. Ensure all components are functioning properly.',
              icon: Icons.power_settings_new,
            ),
          ],
        ),
      ),
    );
  }

  // Section Title Widget with Icon
  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: Colors.blueGrey[800],
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
        ],
      ),
    );
  }

  // Step Widget with Icon
  Widget _buildStep({required int stepNumber, required String title, required String description, required IconData icon}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.blueGrey[800],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step $stepNumber: $title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}