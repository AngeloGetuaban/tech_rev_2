import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
class ImageRainbowCreatePage extends StatefulWidget {
  final String teacherId;

  const ImageRainbowCreatePage({super.key, required this.teacherId});

  @override
  State<ImageRainbowCreatePage> createState() => _ImageRainbowCreatePageState();
}

class _ImageRainbowCreatePageState extends State<ImageRainbowCreatePage> {
  List<dynamic> imageRainbows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchImageRainbows();
  }

  Future<void> _fetchImageRainbows() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('image_rainbows')
          .select()
          .eq('teacher_id', widget.teacherId);

      setState(() {
        imageRainbows = response ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching images: $e')),
      );
    }
  }

  Future<void> _addImageRainbow({
    required XFile imageFile,
    required String choice1,
    required String choice2,
    required String choice3,
    required String choice4,
    required String correctAnswer,
  }) async {
    try {
      // Generate a unique file name
      final fileName = '${DateTime
          .now()
          .millisecondsSinceEpoch}_${imageFile.name}';

      // Upload the image to Supabase storage
      final uploadedFilePath = await Supabase.instance.client.storage
          .from('image_rainbows') // Supabase bucket name
          .upload(fileName, File(imageFile.path));

      // Check if upload was successful
      if (uploadedFilePath == null || uploadedFilePath.isEmpty) {
        throw Exception('Failed to upload image.');
      }

      // Get public URL of the uploaded image
      final imageUrl = Supabase.instance.client.storage
          .from('image_rainbows')
          .getPublicUrl(fileName);

      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception('Failed to retrieve image URL.');
      }

      // Insert data into the image_rainbows table
      final newImageRainbow = {
        'rainbow_image': imageUrl,
        'rainbow_choice_1': choice1,
        'rainbow_choice_2': choice2,
        'rainbow_choice_3': choice3,
        'rainbow_choice_4': choice4,
        'rainbow_correct_answer': correctAnswer,
        'teacher_id': widget.teacherId,
      };

      await Supabase.instance.client.from('image_rainbows').insert(
          newImageRainbow);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image Rainbow added successfully!')),
      );

      _fetchImageRainbows(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding Image Rainbow: $e')),
      );
    }
  }

  /// Function to delete image rainbow
  Future<void> _deleteImageRainbow(String rainbowId) async {
    try {
      await Supabase.instance.client
          .from('image_rainbows')
          .delete()
          .eq('rainbow_id', rainbowId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image Rainbow deleted successfully!')),
      );

      // Refresh the list
      _fetchImageRainbows();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Image Rainbow: $e')),
      );
    }
  }

  void _showAddImageDialog() {
    final ImagePicker picker = ImagePicker();
    final TextEditingController choice1Controller = TextEditingController();
    final TextEditingController choice2Controller = TextEditingController();
    final TextEditingController choice3Controller = TextEditingController();
    final TextEditingController choice4Controller = TextEditingController();
    final TextEditingController correctAnswerController = TextEditingController();

    XFile? selectedImage;

    void _pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          selectedImage = pickedFile;
        });
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Image Rainbow',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: selectedImage == null
                        ? Center(child: Text('Upload Image'))
                        : Image.file(
                      File(selectedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: choice1Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 1',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: choice2Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 2',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: choice3Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 3',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: choice4Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 4',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: correctAnswerController,
                  decoration: InputDecoration(
                    labelText: 'Correct Answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the overlay
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedImage != null &&
                            choice1Controller.text
                                .trim()
                                .isNotEmpty &&
                            choice2Controller.text
                                .trim()
                                .isNotEmpty &&
                            choice3Controller.text
                                .trim()
                                .isNotEmpty &&
                            choice4Controller.text
                                .trim()
                                .isNotEmpty &&
                            correctAnswerController.text
                                .trim()
                                .isNotEmpty) {
                          _addImageRainbow(
                            imageFile: selectedImage!,
                            choice1: choice1Controller.text.trim(),
                            choice2: choice2Controller.text.trim(),
                            choice3: choice3Controller.text.trim(),
                            choice4: choice4Controller.text.trim(),
                            correctAnswer: correctAnswerController.text.trim(),
                          );
                          Navigator.pop(context); // Close the overlay
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                'Please fill all fields and upload an image.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3A86FF),
                      ),
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Rainbows'),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : imageRainbows.isEmpty
          ? Center(
        child: Text(
          'No images added yet.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : ListView.builder(
        itemCount: imageRainbows.length,
        itemBuilder: (context, index) {
          final imageRainbow = imageRainbows[index];
          return ListTile(
            leading: Image.network(
              imageRainbow['rainbow_image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              imageRainbow['rainbow_choice_1'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle:
            Text('Correct Answer: ${imageRainbow['rainbow_correct_answer']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _confirmDelete(imageRainbow['rainbow_id']);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddImageDialog,
        backgroundColor: const Color(0xFF3A86FF),
        child: Icon(Icons.add),
      ),
    );
  }

  /// Function to confirm deletion
  void _confirmDelete(String rainbowId) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Delete Image Rainbow'),
            content: Text(
                'Are you sure you want to delete this image rainbow?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // Close the dialog
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _deleteImageRainbow(rainbowId); // Call delete function
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
