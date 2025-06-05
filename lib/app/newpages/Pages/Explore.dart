import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/colors.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    // Calculate dynamic grid properties
    final crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
    final horizontalPadding = size.width * 0.04;
    final gridSpacing = size.width * 0.02;

    // Calculate location button dimensions
    final buttonWidth = size.width * 0.4; // 40% of screen width
    final buttonHeight = size.height * 0.06; // 6% of screen height

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.08),
        child: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.chevron_left)),
          backgroundColor: mainYellow,
          title: Text(
            "Explore",
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(Icons.chevron_right),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),
              // Location Selector Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: mainYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Lumley",
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: mainYellow),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Rawdon Street",
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              // Grid View
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              //   child: LayoutBuilder(
              //     builder: (context, constraints) {
              //       double itemWidth = (constraints.maxWidth -
              //               (gridSpacing * (crossAxisCount - 1))) /
              //           crossAxisCount;
              //       double aspectRatio = itemWidth / (itemWidth * 1.2);
              //
              //       return GridView.builder(
              //         shrinkWrap: true,
              //         physics: const NeverScrollableScrollPhysics(),
              //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: crossAxisCount,
              //           crossAxisSpacing: gridSpacing,
              //           mainAxisSpacing: gridSpacing,
              //           childAspectRatio: aspectRatio,
              //         ),
              //         itemCount: 60,
              //         itemBuilder: (context, index) {
              //           return  CardMain();
              //         },
              //       );
              //     },
              //   ),
              // ),
              // Bottom padding
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
