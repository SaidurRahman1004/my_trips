import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import 'package:my_trips/widgets/CustomText.dart';
import 'package:my_trips/widgets/custo_snk.dart';
import 'package:my_trips/widgets/custom_text_field.dart';

import '../models/trip_model.dart';
import '../services/db_service.dart';

class FeedPostCard extends StatefulWidget {
  final TripModel trip;
  final String currentUserId;

  const FeedPostCard({
    super.key,
    required this.trip,
    required this.currentUserId,
  });

  @override
  State<FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<FeedPostCard> {
  final _dbService = DBService();
  bool _isLiked = false;
  bool _isLiking = false;

  Future<void> _checkLikeStatus() async {
    final liked = await _dbService.isUserLiked(
      widget.trip.id,
      widget.currentUserId,
    );
    if (mounted) {
      setState(() {
        _isLiked = liked;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;
    setState(() {
      _isLiking = true;
    });

    try {
      await _dbService.likeTrip(widget.trip.id, widget.currentUserId);
      setState(() {
        _isLiked = !_isLiked;
      });
    } catch (e) {
      print('Like error: $e');
    } finally {
      setState(() => _isLiking = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLikeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 10, right: 10, top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.amber.shade100,
                  backgroundImage: widget.trip.userPhoto != null
                      ? NetworkImage(widget.trip.userPhoto!)
                      : null,
                  child: widget.trip.userPhoto == null
                      ? Txt(
                    txt: widget.trip.userName.isNotEmpty
                        ? widget.trip.userName[0].toUpperCase()
                        : 'U',
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt(
                        txt: widget.trip.userName,
                        fontWeight: FontWeight.bold,
                        fntSize: 15,
                      ),
                      Row(
                        children: [
                          Icon(Icons.public, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Txt(
                            txt: DateFormat(
                              'dd MMM yyyy',
                            ).format(widget.trip.date),
                            color: Colors.grey,
                            fntSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt(
                  txt: widget.trip.title,
                  fontWeight: FontWeight.bold,
                  fntSize: 16,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.red[400]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Txt(
                        txt: widget.trip.location,
                        color: Colors.grey.shade700,
                        fntSize: 13,
                      ),
                    ),
                  ],
                ),
                if (widget.trip.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Txt(
                    txt: widget.trip.description,
                    fntSize: 14,
                    color: Colors.grey[800],
                    maxLines: 3,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => context.push('/details', extra: widget.trip),
            child: Hero(
              tag: 'feed_${widget.trip.id}',
              child: CachedNetworkImage(
                imageUrl: widget.trip.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade100,
                    child: Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                          color: Colors.amber,
                        )),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        Txt(txt: 'Image not available', color: Colors.grey)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                InkWell(
                  onTap: _toggleLike,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Txt(
                          txt: widget.trip.likesCount.toString(),
                          fntSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _isLiked ? Colors.red : Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    _showCommentsBottomSheet(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Txt(
                          txt: widget.trip.commentsCount.toString(),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => context.push('/details', extra: widget.trip),
                  label: Txt(
                    txt: 'View',
                    color: Colors.amber,
                    fntSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  icon: Icon(
                      Icons.arrow_forward, size: 16, color: Colors.amber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
            ),
            child: CommentsBottomSheet(
              tripId: widget.trip.id,
              currentUserId: widget.currentUserId,
            ),
          ),
    );
  }
}

class CommentsBottomSheet extends StatefulWidget {
  final String tripId;
  final String currentUserId;

  const CommentsBottomSheet({
    super.key,
    required this.tripId,
    required this.currentUserId,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final DBService _dbService = DBService();
  bool _isPosting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _postComment() async {
    if (_commentController.text
        .trim()
        .isEmpty || _isPosting) return;
    setState(() {
      _isPosting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final String safeUserName = user?.displayName ?? 'User';
      final String? safePhotoUrl = user?.photoURL;

      await _dbService.addComment(
        tripId: widget.tripId,
        userId: widget.currentUserId,
        userName: safeUserName,
        userPhotoUrl: safePhotoUrl,
        comment: _commentController.text.trim(),
      );
      _commentController.clear();
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      if (mounted) {
        mySnkmsg('Failed to post comment', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Txt(
                      txt: 'Comments',
                      fntSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: StreamBuilder(
                  stream: _dbService.getComments(widget.tripId),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CenterCircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Txt(txt: 'Something went wrong'));
                    }
                    final comments = snapshot.data?.docs ?? [];
                    if (comments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 50,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 10),
                            Txt(
                              txt: 'No comments yet',
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (_, index) {
                        final commentData =
                        comments[index].data() as Map<String, dynamic>;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.amber.shade100,
                                backgroundImage:
                                commentData['userPhotoUrl'] != null
                                    ? NetworkImage(
                                    commentData['userPhotoUrl'])
                                    : null,
                                child: commentData['userPhotoUrl'] == null
                                    ? Txt(
                                  txt: commentData['userName'][0]
                                      .toUpperCase(),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                  fntSize: 12,
                                )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Txt(
                                          txt: commentData['userName'] ??
                                              'Unknown',
                                          fontWeight: FontWeight.bold,
                                          fntSize: 13,
                                        ),
                                        const SizedBox(width: 8),
                                        Txt(
                                          txt: _formatTimestamp(
                                              commentData['timestamp']),
                                          fntSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Txt(
                                      txt: commentData['comment'] ?? '',
                                      fntSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                              if (commentData['userId'] == widget.currentUserId)
                                IconButton(
                                  onPressed: () async {
                                    await _dbService.deleteComment(
                                      comments[index].id,
                                      widget.tripId,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.red.shade300,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _commentController,
                        lableText: 'Add a comment...',
                        hintText: 'Write here...',
                        maxLine: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: IconButton(
                        onPressed: _isPosting ? null : _postComment,
                        icon: _isPosting
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Just now';
    try {
      final DateTime dateTime = (timestamp as Timestamp).toDate();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      return DateFormat('dd MMM').format(dateTime);
    } catch (e) {
      return 'Just now';
    }
  }
}