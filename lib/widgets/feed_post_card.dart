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

  //cheak user is liked
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

  //like toggle
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                          txt: widget.trip.userName[0].toLowerCase(),
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        )
                      : null,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt(
                        txt: widget.trip.userName,
                        fontWeight: FontWeight.bold,
                        fntSize: 14,
                      ),
                      Row(
                        children: [
                          Icon(Icons.public, size: 12, color: Colors.grey),
                          Txt(
                            txt: DateFormat(
                              'dd/MM/yyyy',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Txt(
                txt: widget.trip.title,
                fontWeight: FontWeight.bold,
                fntSize: 16,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 12, color: Colors.red[400]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Txt(
                      txt: widget.trip.location,
                      color: Colors.grey,
                      fntSize: 12,
                    ),
                  ),
                  if (widget.trip.description.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Txt(
                      txt: widget.trip.description,
                      fntSize: 14,
                      color: Colors.grey[800],
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => context.push('/details', extra: widget.trip),
            child: Hero(
              tag: 'feed_${widget.trip.id}',
              child: CachedNetworkImage(
                imageUrl: widget.trip.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Container(
                    height: 300,
                    color: Colors.grey.shade100,
                    child: CenterCircularProgressIndicator(),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    height: 300,
                    color: Colors.grey,
                    child: Icon(Icons.error, size: 50),
                  );
                },
              ),
            ),
          ),
          //like Comment Share
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Txt(
                          txt: widget.trip.likesCount.toString(),
                          fntSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _isLiked ? Colors.red : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                //comment
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
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Txt(
                          txt: widget.trip.commentsCount.toString(),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
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
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsBottomSheet(
        tripId: widget.trip.id,
        currentUserId: widget.currentUserId,
      ),
    );
  }
}

//Comment Options

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
    if (_commentController.text.trim().isEmpty || _isPosting) return;
    setState(() {
      _isPosting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      await _dbService.addComment(
        tripId: widget.tripId,
        userId: widget.currentUserId,
        userName: widget.currentUserId,
        userPhotoUrl: user?.photoURL,
        comment: _commentController.text.trim(),
      );
    } catch (e) {
      mySnkmsg('Failed to post comment: $e ', context);
    } finally {
      setState(() {
        _isPosting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.1,
      maxChildSize: 0.5,
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
              const Divider(),
              Expanded(
                child: StreamBuilder(
                  stream: _dbService.getComments(widget.tripId),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CenterCircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Txt(txt: 'Error: ${snapshot.error}'),
                      );
                    }
                    final comments = snapshot.data?.docs ?? [];
                    if (comments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Txt(
                              txt: 'No comments yet',
                              fntSize: 16,
                              color: Colors.grey[500],
                            ),
                            Txt(
                              txt: 'Be the first to comment!',
                              fntSize: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (_, index) {
                        final commentData =
                            comments[index].data() as Map<String, dynamic>;
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.amber.shade100,
                                backgroundImage:
                                    commentData['userPhotoUrl'] != null
                                    ? NetworkImage(commentData['userPhotoUrl'])
                                    : null,
                                child: commentData['userPhotoUrl'] == null
                                    ? Txt(
                                        txt: commentData['userName'][0]
                                            .toUpperCase(),
                                        fntSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                      )
                                    : null,
                                radius: 20,
                              ),
                              //comment content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Txt(
                                      txt: commentData['userName'] ?? 'Unknown',
                                      fntSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(height: 4),
                                    Txt(
                                      txt: commentData['comment'] ?? '',
                                      fntSize: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 4),
                                    Txt(
                                      txt: _formatTimestamp(
                                        commentData['timestamp'],
                                      ),
                                      fntSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              //Delet own  comment
                              if (commentData['userId'] == widget.currentUserId)
                                IconButton(
                                  onPressed: () async {
                                    await _dbService.deleteComment(
                                      comments[index].id,
                                      widget.tripId,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              //Comment Input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _commentController,
                        lableText: 'Add a comment',
                        hintText: 'Write your comment here...',
                        icon: Icons.comment_outlined,
                        maxLine: 3,

                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(onPressed: _postComment, icon: _isPosting ?
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CenterCircularProgressIndicator(),

                        ): const Icon(Icons.send),
                      color: Colors.amber,
                    ) ,

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
      if (difference.inHours < 1) return '${difference.inMinutes}m ago';
      if (difference.inDays < 1) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';

      return DateFormat('dd MMM').format(dateTime);
    } catch (e) {
      return 'Just now';
    }
  }
}
