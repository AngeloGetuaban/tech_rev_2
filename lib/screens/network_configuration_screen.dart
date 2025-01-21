import 'package:flutter/material.dart';

class NetworkConfigurationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network Configuration'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSection(
            title: 'Computer System and Network Configurations',
            children: [
              _buildSubSection(
                title: 'Computer Networks',
                content:
                'Networks are collections of computers, software, and hardware that are all connected to help their users work together. A network connects computers by means of cabling systems, specialized software, and devices that manage data traffic. A network enables users to share files and resources, such as printers, as well as send messages electronically (e-mail) to each other.\n\n'
                    'The most common networks are Local Area Networks or LANs for short. A LAN connects computers within a single geographical location, such as one office building, office suite, or home. By contrast, Wide Area Networks (WANs) span different cities or even countries, using phone lines or satellite links.',
              ),
              _buildSubSection(
                title: 'Network System Configuration',
                content:
                'All networks go through roughly the same steps in terms of design, rollout, configuration, and management.',
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildSection(
            title: 'Designing Your Network',
            children: [
              Text(
                'Plan on the design phase to take anywhere from one to three working days, depending on how much help you have and how big your network is.\n\n'
                    'Here are the key tasks:',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 8),
              _buildBulletPoints([
                'Settle on a peer-to-peer network or a client/server network.',
                'Pick your network system software.',
                'Pick a network language.',
                'Figure out what hardware you need.',
                'Decide on what degree of information security you need.',
                'Choose software and hardware solutions to handle day-to-day management chores.',
              ]),
            ],
          ),
          SizedBox(height: 24),
          _buildSection(
            title: 'Rolling Out Your Network',
            children: [
              Text(
                'Rolling out your network requires the following steps:',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 8),
              _buildBulletPoints([
                'Run and test network cables.',
                'Install the server or servers if you’re setting up a client/server network. (If you are setting up a peer-to-peer network, you typically don’t have to worry about any dedicated servers.)',
                'Set up the workstation hardware.',
                'Plug in and cable the Network Interface Cards (NICs – these connect the network to the LAN).',
                'Install the hub or hubs (if you are using twisted-pair cable).',
                'Install printers.',
                'Load up the server software (the NOS, or Network Operating System) if your network is a client/server type.',
                'Install the workstation software.',
                'Install modem hardware for remote dial-up (if you want the users to be able to dial into the network).',
                'Install the programs you want to run (application software).',
              ]),
            ],
          ),
          SizedBox(height: 24),
          _buildSection(
            title: 'Configuring Your Network',
            children: [
              Text(
                'Network configuration means customizing the network for your own use.',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 8),
              _buildBulletPoints([
                'Creating network accounts for your users (names, passwords, and groups).',
                'Creating areas on shared disk drives for users to share data files.',
                'Creating areas on shared disk drives for users to share programs (unless everyone runs programs from their own computer).',
                'Setting up print queues (the software that lets users share networked printers).',
                'Installing network support on user workstations, so they can "talk" to your network.',
              ]),
            ],
          ),
          SizedBox(height: 24),
          _buildSection(
            title: 'Managing Your Network',
            children: [
              Text(
                'The work you do right after your LAN is up and running and configured can save you huge amounts of time in the coming months.',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 8),
              _buildBulletPoints([
                'Mapping your network for easier management and troubleshooting.',
                'Setting up appropriate security measures to protect against accidental and intentional harm.',
                'Tuning up your LAN so that you get the best possible speed from it.',
                'Creating company standards for adding hardware and software, so you don’t have nagging compatibility problems later.',
                'Putting backup systems in place so that you have copies of data and programs if your hardware fails.',
                'Installing some monitoring and diagnostic software so that you can check on your network’s health and get an early warning of impending problems.',
                'Figuring out how you plan to handle troubleshooting – educating your LAN administrator, setting up a support contract with a software vendor, and so on.',
              ]),
            ],
          ),
          SizedBox(height: 24),
          _buildSection(
            title: 'Smooth Setup',
            children: [
              Text(
                'One key advantage of a peer-to-peer network is that it’s easy to set up. With the simplest sort of peer-to-peer network, you just use the built-in networking that comes with your operating system (Windows 98, Windows XP, Windows 7, Windows 8, and so on) and you have very little software to set up – even less if you have computers that have the operating system preinstalled, as most computers do these days.',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'Review for Cabling: UTP Cable',
                content:
                'A UTP cable (category 5) is one of the most popular LAN cables. This cable consists of 4 twisted pairs of metal wires (that means there are 8 wires in the cable). Adding RJ45 connectors at both ends of the UTP cable, it becomes a LAN cable they usually use.',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'Preparation',
                content:
                'You need a UTP Cable, Crimping Tool, RJ45, and Cutter.',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'Making Cable',
                content:
                'Follow the steps below:\n\n'
                    '1. Remove the outermost vinyl shield for 12mm at one end of the cable (we call this side A-side).\n'
                    '2. Arrange the metal wires in parallel (refer to the wire arrangement table). Don\'t remove the shield of each metal line.\n'
                    '3. Insert the metal wires into the RJ45 connector while keeping the metal wire arrangement.\n'
                    '4. Set the RJ45 connector (with the cable) on the pliers and squeeze it tightly.\n'
                    '5. Make the other side of the cable (we call this side B-side) in the same way.\n'
                    '6. After you\'ve made it, you don\'t need to take care of the direction of the cable. (Any cable in this page is directionless --- that means you can set either end of the cable to either device.)',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'How to See the Wire Arrangement',
                content:
                'Take the UTP cable with your left hand and an RJ45 connector with your right hand. Hold the RJ45 connector in the way you can see the contact metal face of the RJ45 connector.\n\n'
                    'The tables below are for the case where the UTP cable consists of green/green-white, orange/orange-white, blue/blue-white, brown/brown-white twisted pairs.',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: '10 Base T / 100 Base T Straight',
                content:
                '10BaseT and 100BaseT are the most common modes of LAN. You can use UTP category-5 cable for both modes. (You can use UTP category-3 cable for 10BaseT, in which there are only 3 wires inside the cable.)\n\n'
                    'A straight cable is used to connect a computer to a hub. You can use it to connect 2 hubs in the case one of the hubs has an uplink port (and you use a normal port on the other hub).',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: '10 Base T / 100 Base T Cross',
                content:
                'A cross cable for 10BaseT and 100BaseT is used to connect 2 computers directly (with ONLY the UTP cable). It is also used when you connect 2 hubs with a normal port on both hubs. (In other words, the cross cable is used relatively in a rare case.)',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'Creating Peer to Peer Network',
                content:
                'To create a peer network, you must have the following components:\n\n'
                    '- A network interface or Local Area Network (LAN) adapter for each computer. The same manufacturer and model of network card is preferred.\n'
                    '- Cabling that is supported by the network cards.\n'
                    '- Windows XP or 7 drivers for the network cards.\n'
                    '- A common network protocol.\n'
                    '- A unique computer name for each computer.',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'Task: Creating Peer to Peer Network',
                content:
                'To create a peer network, follow these steps for each computer connected to the network:\n\n'
                    '1. Shut down the computer and install the network card and appropriate cabling for each computer.\n'
                    '2. Start Windows and install the network drivers. Windows may detect your network card and install the drivers when you start the computer. If the network card drivers are not included with Windows, follow the manufacturer\'s instructions about how to install the network drivers.\n'
                    '3. Choose a client and a common protocol for each computer.\n'
                    '4. Configure a peer server. Each computer that is configured for File and Printer Sharing can act as a server.\n'
                    '5. Give each computer a unique computer name.',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'Task: Setting Windows Network Connection',
                content:
                'Equipment, Tools, and Materials Required:\n\n'
                    '- UTP cables\n'
                    '- 4 Computer units\n'
                    '- 1 hub\n\n'
                    'Given the following materials, set up a network connection on four computers.',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'Task: Using the Internet for Research',
                content:
                'In this project, you will learn how useful the Internet can be for a PC support technician.\n\n'
                    '1. Using your own or a lab computer, pretend that the motherboard manual is not available and you need to replace a faulty processor. Identify the manufacturer and model of the motherboard by looking for the manufacturer name and model number stamped on the board. Research the Web site for that manufacturer. Print the list of processors the board can support.\n'
                    '2. Research the Web site for your motherboard and print the instructions for flashing BIOS.\n'
                    '3. Research the Abit Web site (www.abit.com.tw) and print a photograph of a motherboard that has a riser slot. Also, print the photograph of the riser card that fits this slot. What is the function of the riser card?',
              ),
              SizedBox(height: 16),
              _buildSubSection(
                title: 'Task: More Security for Remote Desktop',
                content:
                'When Jacob travels on company business, he finds it’s a great help to be able to access his office computer from anywhere on the road using Remote Desktop. However, he wants to make sure his office computer as well as the entire corporate network is as safe as possible. One way you can help Jacob add more security is to change the port that Remote Desktop uses. Knowledgeable hackers know that Remote Desktop uses port 3389, but if you change this port to a secret port, hackers are less likely to find the open port.\n\n'
                    '1. Set up Remote Desktop on a computer to be the host computer. Use another computer (the client computer) to create a Remote Desktop session to the host computer. Verify the session works by transferring files in both directions.\n'
                    '2. Next, change the port that Remote Desktop uses on the host computer to a secret port. Print a screenshot showing how you made the change. Use the client computer to create a Remote Desktop session to the host computer using the secret port. Print a screenshot showing how you made the connection using the secret port. Verify the session works by transferring files in both directions.\n'
                    '3. What secret port did you use?',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSubSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points.map((point) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ', style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            Expanded(
              child: Text(
                point,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }
}