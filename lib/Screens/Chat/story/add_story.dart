import 'dart:io';
import 'package:flutter/material.dart';

class AddStoryPage extends StatelessWidget {
  final File imageFile;

  AddStoryPage({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Display the selected image
            Image.file(
              imageFile,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Bottom bar with actions
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button with gradient border
                    GradientStrokeButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Action icons (without gradient)
                    IconButton(
                      icon: Icon(Icons.crop, color: Colors.white),
                      onPressed: () {
                        // Handle crop action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.auto_awesome, color: Colors.white),
                      onPressed: () {
                        // Handle filter/action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.text_fields, color: Colors.white),
                      onPressed: () {
                        // Handle text action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.emoji_emotions, color: Colors.white),
                      onPressed: () {
                        // Handle emoji action
                      },
                    ),
                    // Next button with gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffFB457E), Color(0xff8048F9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your post story logic here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Далее',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom widget to create a gradient icon button with border
class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  GradientIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Color(0xffFB457E), Color(0xff8048F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        padding: EdgeInsets.all(8),
      ),
    );
  }
}

// Custom widget to create a gradient stroke button with border color
class GradientStrokeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  GradientStrokeButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, // Width of the button
      height: 50, // Height of the button
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xffFB457E), Color(0xff8048F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          width: 2, // Width of the stroke
          color: Colors.white, // Color of the stroke
        ),
      ),
      child: Center(
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
          padding: EdgeInsets.all(8),
        ),
      ),
    );
  }
}