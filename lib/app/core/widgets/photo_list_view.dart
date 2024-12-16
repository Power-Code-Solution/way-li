import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/like_user_list_view.dart';
import 'package:wayli/app/core/widgets/photo_details_view.dart';
import 'package:wayli/app/core/widgets/popup_layout.dart';
import 'package:wayli/app/core/widgets/selection_button.dart';
import 'package:wayli/app/core/widgets/user_photo_row.dart';
import 'package:wayli/app/modules/home/comment_list_view.dart';


class PhotoListView extends StatefulWidget {
  const PhotoListView({super.key});

  @override
  State<PhotoListView> createState() => _PhotoListViewState();
}

class _PhotoListViewState extends State<PhotoListView> {
  var selectTab = 0;
  var isGrid = true;

  List imgArr = [
    "assets/images/l1.png",
    "assets/images/l2.png",
    "assets/images/l3.png",
    "assets/images/l4.png",
    "assets/images/l5.png",
    "assets/images/l1.png",
    "assets/images/l2.png",
    "assets/images/l3.png",
    "assets/images/l4.png",
    "assets/images/l5.png",
    "assets/images/l1.png",
    "assets/images/l2.png",
    "assets/images/l3.png",
    "assets/images/l4.png",
    "assets/images/l5.png",
    "assets/images/l1.png",
    "assets/images/l2.png",
    "assets/images/l3.png",
    "assets/images/l4.png",
    "assets/images/l5.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              pinned: true,
              floating: false,
              centerTitle: false,
              leadingWidth: 0,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      "assets/images/back.png",
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All Photos",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: secondaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Lombor Pizza",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: secondaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isGrid = !isGrid;
                    });
                  },
                  icon: Image.asset(
                    isGrid
                        ? "assets/images/filter.png"
                        : "assets/images/grid_icon.png",
                    width: 25,
                    height: 25,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            SliverAppBar(
              primary: false,
              floating: false,
              backgroundColor: Colors.white,
              expandedHeight: 70,
              elevation: 1,
              leading: Container(),
              leadingWidth: 0,
              flexibleSpace: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Row(
                    children: [
                      SelectionButton(
                          title: "Food",
                          subTitle: "(80)",
                          onPressed: () {
                            setState(
                              () {
                                selectTab = 0;
                              },
                            );
                          },
                          isSelect: selectTab == 0),
                      SelectionButton(
                          title: "Ambience",
                          subTitle: "(25)",
                          onPressed: () {
                            setState(
                              () {
                                selectTab = 1;
                              },
                            );
                          },
                          isSelect: selectTab == 1),
                      SelectionButton(
                          title: "Menu",
                          subTitle: "(10)",
                          onPressed: () {
                            setState(
                              () {
                                selectTab = 2;
                              },
                            );
                          },
                          isSelect: selectTab == 2),
                      SelectionButton(
                          title: "All Photos",
                          subTitle: "(115)",
                          onPressed: () {
                            setState(
                              () {
                                selectTab = 3;
                              },
                            );
                          },
                          isSelect: selectTab == 3),
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: isGrid
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                itemCount: imgArr.length,
                itemBuilder: (context, index) {
                  var images = imgArr[index] as String? ?? "";

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoDetailsView(
                            images: images,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                        ),
                        child: Image.asset(
                          images,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                })
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 2),
                itemCount: imgArr.length,
                itemBuilder: (context, index) {
                  var images = imgArr[index] as String? ?? "";
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0, 1))
                        ]),
                    child: UserPhotoRow(
                      pObj: {
                        "image": images,
                      },
                      onCommentPress: () {
                        Navigator.push(context,
                            PopupLayout(child: const CommentListView()));
                      },
                      onLikePress: () {
                        Navigator.push(context,
                            PopupLayout(child: const LikeUserListView()));
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
