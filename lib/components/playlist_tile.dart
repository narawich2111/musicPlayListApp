import 'package:flutter/material.dart';

Widget playlistTile({
  required String title,
  required String cover,
  required String subtitle,
  required void Function() onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8),
      child: Row(children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(cover),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ]),
        const Spacer(),
        IconButton(
          onPressed: () {
            // Handle play/pause action here
          },
          icon: Icon(
            color: Colors.grey.shade600,
            Icons.play_circle_outline_outlined,
            size: 40,
          ),
        ),
        const SizedBox(width: 20),
      ]),
    ),
  );
  // return ListTile(
  //   leading: Container(
  //     height: 80,
  //     width: 80,
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(5),
  //       child: Image.asset(
  //         cover,
  //         width: 70,
  //         height: 70,
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   ),
  //   title: Text(title),
  //   subtitle: Text(subtitle),
  //   trailing: const Icon(
  //     Icons.play_circle_outline,
  //     size: 35,
  //   ),
  //   onTap: onTap,
  // );
}
