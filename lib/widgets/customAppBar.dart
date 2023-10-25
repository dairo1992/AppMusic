import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String avatar;
  final Widget leading;
  final String title;
  final Widget? actions;

  const CustomAppBar(
      {super.key,
      this.avatar = "",
      this.leading = const Icon(Icons.arrow_back_ios),
      required this.title,
      this.actions});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 25, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: leading),
      actions: [
        avatar != ''
            ? Container(
                margin: const EdgeInsets.only(right: 20),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                ),
              )
            : Container(),
        actions ?? Container()
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
