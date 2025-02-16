import 'dart:io';
import 'package:flutter/material.dart';
import '../screens/camera_screen.dart';
import 'profile_page.dart'; 

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> posts = []; 
  List<String> discoveryPosts = []; 
  bool isFriendsPage = true; 

  void addPost(String imagePath) {
    if (mounted) {
      setState(() {
        if (isFriendsPage) {
          posts.insert(0, imagePath);
        } else {
          discoveryPosts.insert(0, imagePath);
        }
      });
    }
  }

  Future<void> _openCamera() async {
    print("Camera button pressed");

    if (!mounted) return; 

    final capturedPath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraScreen(
          onImageCaptured: (imagePath) {
            Navigator.pop(context, imagePath);
          },
        ),
      ),
    );

    print("Returned from CameraScreen: $capturedPath");

    if (capturedPath != null && mounted) {
      addPost(capturedPath);
      print("Post added: $capturedPath");
    } else {
      print("No image returned from CameraScreen");
    }
  }

  void _toggleFeed(bool isFriendsSelected) {
    setState(() {
      isFriendsPage = isFriendsSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Column(
        children: [
          _buildTopBar(), 
          Expanded(
            child: (isFriendsPage ? posts : discoveryPosts).isEmpty
                ? _buildEmptyFeed()
                : PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: isFriendsPage ? posts.length : discoveryPosts.length,
                    itemBuilder: (context, index) {
                      return _buildPostCard(isFriendsPage ? posts[index] : discoveryPosts[index]);
                    },
                  ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Container(
            margin: const EdgeInsets.only(bottom: 15), 
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _toggleFeed(true), 
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isFriendsPage ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Friends",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isFriendsPage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleFeed(false), 
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: !isFriendsPage ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Discovery",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: !isFriendsPage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: _openCamera,
            child: const Icon(Icons.camera_alt, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.group, color: Colors.white, size: 28),
            onPressed: () {
              
            },
          ),
          const Text(
            "FitCheck",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFeed() {
    return Center(
      child: GestureDetector(
        onTap: _openCamera,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "No posts yet.\nTake a picture!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(String imagePath) {
    final file = File(imagePath);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: file.existsSync()
                ? Image.file(file, fit: BoxFit.cover)
                : Container(color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
