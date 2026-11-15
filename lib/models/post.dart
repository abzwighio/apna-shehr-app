class Post {
  final String id;
  final String authorName;
  final String authorType; // 'user', 'shop', 'mosque', 'admin'
  final String text;
  final String? imageUrl;
  final String? shopName;
  final DateTime createdAt;
  int likesCount;
  int commentsCount;
  bool isLiked;

  Post({
    required this.id,
    required this.authorName,
    this.authorType = 'user',
    required this.text,
    this.imageUrl,
    this.shopName,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id']?.toString() ?? '',
      authorName: map['author_name'] ?? 'Apna Shehr User',
      authorType: map['author_type'] ?? 'user',
      text: map['text'] ?? '',
      imageUrl: map['image_url'],
      shopName: map['shop_name'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
    );
  }
}
