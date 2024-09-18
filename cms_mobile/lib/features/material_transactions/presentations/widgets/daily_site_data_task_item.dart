import 'package:cms_mobile/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class DailySiteDataTaskItem extends StatelessWidget {
  final String? iconSrc;
  final String title;
  final String subtitle;
  final String taskId;
  final String id;
  final onEdit;
  final onDelete;
  final onOpen;

  const DailySiteDataTaskItem(
      {super.key,
      this.iconSrc,
      required this.title,
      required this.subtitle,
      required this.id,
      required this.taskId,
      this.onEdit,
      this.onDelete,
      this.onOpen});

  @override
  Widget build(BuildContext context) {
    debugPrint('id: $id task id: $taskId');

    return InkWell(
      onTap: onOpen,
      child: Container(
        height: 80,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: ShapeDecoration(
          color: const Color(0x110F4A84),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 45,
            height: 45,
            padding: const EdgeInsets.all(5),
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: iconSrc != null
                ? SvgPicture.asset(
                    iconSrc!,
                  )
                : SizedBox(),
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: onEdit != null && onDelete != null
              ? PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      onTap: () {
                        context.goNamed(RouteNames.dailySiteDataTaskDetails,
                            pathParameters: {
                              'dailySiteDataId': id,
                              'dailySiteDataTaskId': taskId,
                            });
                      },
                      child: const Text('View Detail'),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
