import 'package:flutter/material.dart';
import 'package:wayli/app/newpages/components/Card.dart';
import 'package:wayli/app/newpages/components/colors.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    // Calculate dynamic grid properties
    final crossAxisCount = orientation == Orientation.portrait
        ? 2 // Two columns in portrait
        : 3; // Three columns in landscape

    // Calculate dynamic padding and spacing
    final horizontalPadding = size.width * 0.04; // 4% of screen width
    final gridSpacing = size.width * 0.02; // 2% of screen width

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(size.height * 0.08), // Responsive app bar height
        child: AppBar(
          leading: const Icon(Icons.menu),
          backgroundColor: mainYellow,
          title: Row(
            children: [
              const Text(
                "Way Li",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset("assets/wayli.png", width: 30),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.notifications),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              // Search Field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 600, // Maximum width on larger screens
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: size.width * 0.04),
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.015,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Grid View
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate the aspect ratio based on available width
                    double itemWidth = (constraints.maxWidth -
                            (gridSpacing * (crossAxisCount - 1))) /
                        crossAxisCount;
                    double aspectRatio = itemWidth /
                        (itemWidth * 1.2); // Adjust 1.2 to change card height

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: gridSpacing,
                        mainAxisSpacing: gridSpacing,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: 60,
                      itemBuilder: (context, index) {
                        return const CardMain();
                      },
                    );
                  },
                ),
              ),
              // Bottom padding to ensure last row is visible
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
