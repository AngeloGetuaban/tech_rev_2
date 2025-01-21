import 'package:flutter/material.dart';

class OSInstallationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OS Installation'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: INSTALLING OPERATING SYSTEM
            _buildSection(
              title: 'INSTALLING OPERATING SYSTEM',
              children: [
                Text(
                  'Before the installation process undertakes, a technician must be aware of the minimum requirements of a computer hardware that is compatible with the operating system to be installed. Following the systems’ requirements means an efficient computer system. The list below shows the Windows XP minimum requirements for installation:',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                SizedBox(height: 16),
                _buildBulletPoints([
                  'Pentium 233 Mhz or compatible processor or faster; 300MHZ or faster recommended',
                  '64MB of RAM minimum; 128MB or more recommended',
                  '4.3GB hard disk space or more',
                  'CD-ROM or DVD-ROM',
                  'Super VGA (800X600) or higher-resolution monitor',
                  'Keyboard and mouse',
                ]),
              ],
            ),
            SizedBox(height: 24),

            // Section 2: Windows XP Installation Steps
            _buildSection(
              title: 'Windows XP Installation',
              children: [
                _buildStep(
                  step: '1. Insert the Windows XP CD-ROM and reboot the computer',
                  details: '• If you see a message about pressing any key to boot the CD, do so now. Otherwise, you will see a message about Setup inspecting your system.',
                ),
                _buildStep(
                  step: '2. MS-DOS portion of Setup begins',
                  details: '• In the first stage of setup, you will see a series of blue and gray MS-DOS-based screens.\n• In the first step, you will be asked to press F6 if you need to install any third-party or RAID drivers.',
                ),
                _buildStep(
                  step: '3. Welcome to Setup',
                  details: '• Finally, Setup begins. In this step, you can set up XP, launch the Recovery Console (another, more complicated system recovery tool), or quit.\n• Press ENTER to continue Setup, and it will examine your hard drives and removable disks.',
                ),
                _buildStep(
                  step: '4. Read the license agreement',
                  details: '• Next, you\'ll have to agree to Microsoft\'s complex licensing agreement. Among the highlights: You don\'t actually own Windows XP, and you can only install it on one PC.\n• Hit F8 to continue.',
                ),
                _buildStep(
                  step: '5. Choose an installation partition',
                  details: '• This crucial step lets you choose where to install XP.\n• On a clean install, you will typically install to the C: drive, but you might have other ideas, especially if you plan to dual-boot with 9x.\n• Setup will show you all of your available disks (in this case, just one) and let you create and delete partitions as needed.',
                ),
                _buildStep(
                  step: '6. Select the file system',
                  details: '• If you created a new partition or wish to change the file system of an existing partition, you can do so in the next step. NTFS (New Technology File System) is more secure than FAT (File Allocation System).\n• Regardless of which file system you choose, be sure to select one of the "quick" format options (the top two choices) if you do need to format, since these will work much more quickly than a full format.',
                ),
                _buildStep(
                  step: '7. Optionally format the partition',
                  details: '• If you did choose to change or format the file system, this will occur next. First, you\'ll be asked to verify the format. If you\'re installing XP on a system with more than one partition, especially one that still holds your data on one of the partitions, be sure you\'re formatting the correct partition.\n• Hit F to continue, and a yellow progress bar will indicate the status of the format. When this is complete, Setup will again examine your disks and create a list of files to copy.',
                ),
                _buildStep(
                  step: '8. Setup folder copy phase and reboot',
                  details: '• Setup will now copy system files to the system/boot partition(s) you just created. This will allow the PC to boot from the C: drive and continue Setup in GUI mode.\n• When the file copy is complete, Setup will initialize and save your XP configuration.\n• It will then reboot your PC. When the system reboots, you will probably see the "Press any key to boot from CD" message again. If this happens, do not press a key: Setup will now boot from your C: drive. In the event that you cannot prevent the CD-based Setup from reloading, eject the CD and reboot. Setup will ask for the CD when needed.',
                ),
                _buildStep(
                  step: '9. GUI Setup begins',
                  details: '• Once the system reboots, you will be presented with the GUI Setup phase, which is much more attractive than the DOS-mode phase. As you progress through GUI Setup, you can read promotional information on the right side of the screen about XP.\n• Next, your hardware devices are detected. This could take several minutes.',
                ),
                _buildStep(
                  step: '10. Regional and language Options',
                  details: '• In the first interactive portion of GUI Setup, you can choose to customize the regional and language settings that will be used by XP, as well as the text input language you\'d like. Users in the United States will not normally need to change anything here.',
                ),
                _buildStep(
                  step: '11. Personalize your software',
                  details: '• Now, enter your name and your company. The name you enter is not the same as your user name, incidentally, so you should enter your real name here (i.e., Rosalie Lujero or whatever).',
                ),
                _buildStep(
                  step: '12. Enter your product key',
                  details: '• Now you must enter the 25-character product key that is located on the orange sticker found on the back of the CD holder that came with Windows XP. You cannot install XP without a valid product key. Later on, you will be asked to activate and optionally register your copy of Windows XP. A product key can be used to install XP on only one PC.',
                ),
                _buildStep(
                  step: '13. Enter a computer name and administrator password',
                  details: '• In the next phase of Setup, you can create a name for your computer (which is used to identify it on a network) and, optionally in Pro Edition only, a password for the system Administrator, the person who controls the PC (this will generally be you, of course).',
                ),
                _buildStep(
                  step: '14. Supply your date and time settings',
                  details: '• Next, you can supply the date and time, which are auto-set based on information in your BIOS, and the time zone, which is irritatingly set to PST, which is where Microsoft is. Change these as appropriate.',
                ),
                _buildStep(
                  step: '15. Network setup',
                  details: '• If you have a networking card or modem, Setup now installs the networking components, which include the client for Microsoft networks, File and Print Sharing, the Quality of Service (QoS) Packet Scheduler, and the TCP/IP networking protocol by default.',
                ),
                _buildStep(
                  step: '16a. Choose networking settings',
                  details: '• In this phase, you can choose to keep the default settings (recommended) or enter custom settings.\n• Note that XP doesn\'t include the legacy NetBEUI protocol out of the box. If you want to use this protocol, you will need to install it later from the XP CD-ROM.',
                ),
                _buildStep(
                  step: '16b. Enter workgroup or domain information',
                  details: '• In Windows XP Professional only, you will be able to select a workgroup or domain name next. Home Edition doesn\'t work with Windows domains, however, and Setup will automatically supply the workgroup name MSHOME, which you can change later. The default workgroup name in XP Pro is, imaginatively, WORKGROUP.',
                ),
                _buildStep(
                  step: '17. Set-up completion',
                  details: '• From this point on, Setup will continue to completion without any further need for interaction. Setup will now copy files, complete installation, install your Start Menu items, register system components, save settings, remove any temporary files needed by Setup, and then reboot.\n• Again, you will probably see the "Press any key to boot from CD" message on reboot. If this happens, do not press a key, and your new XP install will boot up. You can remove the XP Setup CD now.',
                ),
                _buildStep(
                  step: '18. First boot',
                  details: '• You’ll be greeted by the XP splash screen on first boot (this actually appears briefly when you rebooted into GUI Setup as well). The splash screens for XP Pro and Home are subtly different.',
                ),
                _buildStep(
                  step: '19. Change display settings',
                  details: '• Users with CRT monitors and some LCDs (such as laptops and flat panel displays) will see a Display Settings dialog appear, which asks whether you\'d like XP to automatically set the resolution. This will generally change the resolution from 800 x 600 to 1024 x 768 on a CRT monitor or to the native resolution of an LCD display.\n• Click OK and let XP change the resolution. Then, accept the settings if the screen display changes and can be read. If you can\'t see the display, it will time out after 30 seconds and return to the sub-optimal 800 x 600 resolution.\n• Click OK to accept the screen resolution change.',
                ),
                _buildStep(
                  step: '20. Welcome to Microsoft Windows',
                  details: '• Now, you are presented with XP\'s "Out of Box Experience," or OOBE, which presents a silly wizard to guide you through the final set up of your PC.',
                ),
                _buildStep(
                  step: '21. Network setup',
                  details: '• In the opening OOBE phase, you are asked to set up your network/Internet connection, which is required for activation and registration. If you selected the default networking configuration during Setup and know it will work (because you\'re connected directly to a cable modem, perhaps, or are on a local area network), then select Yes (the default). Otherwise, you can select No and then Skip.\n• We\'ll assume that your network is up and running and select Yes.\n• Click Next to continue.',
                ),
                _buildStep(
                  step: '22. Optionally activate and register Windows',
                  details: '• If you selected Yes in the previous step, you are asked if you\'d like to activate Windows XP. This will tie your copy of XP to the current PC semi-permanently. Activation requires a connection to the Internet, but you can perform this step later if you want (and don\'t worry, XP will annoyingly remind you of this fact every time you boot the machine until you do so).',
                ),
                _buildStep(
                  step: '23. Set up users',
                  details: '• Now, you can set up the user names of the people who will be using the PC. You will want at least one user (for you), since you shouldn\'t be logging on as Administrator. Curiously, each user you do create here has administrative privileges, however, and no password. You should set up your users correctly with passwords as soon as possible.\n• This phase lets you create up to five users. You can create more later, or manage users, using the User Accounts tool in Control Panel.\n• Click Finish when done creating users. At this point, OOBE ends and you\'re ready to go.\n• Click Finish again.',
                ),
                _buildStep(
                  step: '24. Logon to Windows XP for the first time',
                  details: '• Click your name, that account will logon, and you\'ll be presented with the XP desktop. After you create passwords, however, you\'ll be asked to enter a password before you can logon.',
                ),
              ],
            ),
          ],
        ),
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

  Widget _buildStep({required String step, required String details}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
        ),
        SizedBox(height: 8),
        Text(
          details,
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