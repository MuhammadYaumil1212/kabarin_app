import 'package:flutter/material.dart';
import 'package:kabarin_app/pages/common/entities/entities.dart';

import '../../../common/style/color.dart';

class ContactItemList extends StatelessWidget {
  final VoidCallback onTap;
  final ContactItem item;
  const ContactItemList({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: .all(Radius.circular(100)),
          color: AppColor.pinkColor,
          image: (item.avatar != null && item.avatar!.isNotEmpty)
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(item.avatar!),
                )
              : null,
        ),
        child: (item.avatar == null || item.avatar!.isEmpty)
            ? Center(
                child: Text(
                  (item.name != null && item.name!.isNotEmpty)
                      ? item.name![0].toUpperCase()
                      : "?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              )
            : null,
      ),
      title: Text(overflow: .ellipsis, maxLines: 2, item.name ?? "No Name"),
    );
  }
}
