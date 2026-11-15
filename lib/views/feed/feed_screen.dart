import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_translations.dart';
import '../../providers/app_state.dart';
import '../../models/post.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final posts = state.posts;
    final isUrdu = state.lang == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.text('feed', state.lang)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(
          isUrdu ? 'پوسٹ لگائیں' : 'New Post',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isUrdu ? 'پوسٹ کرنے کے لیے لاگ ان ہونا ضروری ہے' : 'Please log in to post updates',
              ),
            ),
          );
        },
      ),
      body: posts.isEmpty
          ? Center(
              child: Text(
                isUrdu ? 'اس وقت کوئی نئی پوسٹ نہیں ہے' : 'No feed updates yet',
                style: const TextStyle(color: AppColors.textMuted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Author Row
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Text(
                                post.authorName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        post.authorName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      if (post.authorType == 'admin') ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppColors.blue.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'Official',
                                            style: TextStyle(fontSize: 10, color: AppColors.blue, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    '${post.createdAt.hour}:${post.createdAt.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Post Content
                        Text(
                          post.text,
                          style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        // Actions (Like & Comment)
                        Row(
                          children: [
                            TextButton.icon(
                              icon: Icon(
                                post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                                size: 18,
                                color: post.isLiked ? AppColors.primary : AppColors.textMuted,
                              ),
                              label: Text(
                                '${post.likesCount}',
                                style: TextStyle(
                                  color: post.isLiked ? AppColors.primary : AppColors.textMuted,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  post.isLiked = !post.isLiked;
                                  post.likesCount += post.isLiked ? 1 : -1;
                                });
                              },
                            ),
                            const SizedBox(width: 16),
                            TextButton.icon(
                              icon: const Icon(Icons.mode_comment_outlined, size: 18, color: AppColors.textMuted),
                              label: Text(
                                '${post.commentsCount}',
                                style: const TextStyle(color: AppColors.textMuted),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
