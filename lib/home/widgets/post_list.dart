import 'package:flutter/material.dart';
import 'package:postapp/home/models/post_model.dart';

class PostList extends StatelessWidget {
  const PostList({
    super.key,
    required this.postList,
  });

  final List<PostModel> postList;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple.shade500),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          children: [
            Text(
              postList[index].title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              postList[index].body,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "userID : ${postList[index].userId}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  "postID : ${postList[index].id}",
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      itemCount: postList.length,
    );
  }
}
