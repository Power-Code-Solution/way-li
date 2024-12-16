import 'package:flutter/material.dart';
import 'package:wayli/app/core/config/constants.dart';
import 'package:wayli/app/core/widgets/like_user_list_view.dart';
import 'package:wayli/app/core/widgets/popup_layout.dart';
import 'package:wayli/app/core/widgets/user_photo_row.dart';
import 'package:wayli/app/modules/home/comment_list_view.dart';


class PhotoDetailsView extends StatefulWidget {
  final String images;
  const PhotoDetailsView({super.key, required this.images});

  @override
  State<PhotoDetailsView> createState() => _PhotoDetailsViewState();
}

class _PhotoDetailsViewState extends State<PhotoDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
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
                  Text(
                    "Photo",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: UserPhotoRow(
                  pObj: {"image": widget.images},
                  onCommentPress: () {
                    Navigator.push(
                        context, PopupLayout(child: const CommentListView()));
                  },
                  onLikePress: (){

                    Navigator.push(
                        context, PopupLayout(child: const LikeUserListView()));
                    

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
