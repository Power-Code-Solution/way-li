import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../config/constants.dart';



class Skeleton extends StatelessWidget {
  const Skeleton({Key? key, this.height, this.width}) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius:
          const BorderRadius.all(Radius.circular(defaultPadding))),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({Key? key, this.size = 24}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        shape: BoxShape.circle,
      ),
    );
  }
}




class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Skeleton(height: 120, width: 120),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Skeleton(width: 80),
              const SizedBox(height: defaultPadding / 2),
              const Skeleton(),
              const SizedBox(height: defaultPadding / 2),
              const Skeleton(),
              const SizedBox(height: defaultPadding / 2),
              Row(
                children: const [
                  Expanded(
                    child: Skeleton(),
                  ),
                  SizedBox(width: defaultPadding),
                  Expanded(
                    child: Skeleton(),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}




class Skelton extends StatelessWidget {
  const Skelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final horizontalPadding = size.width * 0.04;
    final crossAxisCount = orientation == Orientation.portrait ? 2 : 3;
    final gridSpacing = size.width * 0.02;


    return Center(child:
    Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Shimmer.fromColors(
          baseColor: Colors.white!,
          // baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
              childAspectRatio: 1,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: size.height * 0.02),
                color: Colors.white,
              );
            },
          ),
        )
    )
    ) ;
  }
}