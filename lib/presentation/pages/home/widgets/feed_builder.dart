import 'package:flutter/material.dart';
import 'package:haiku/presentation/pages/home/widgets/feed_sliver_list_view.dart';

import '../../../../data/models/post_model.dart';
import 'feed_list_view.dart';

class FeedBuilder extends StatefulWidget {
  const FeedBuilder({
    super.key,
    this.scrollController,
    this.stream,
    this.onRefresh,
    this.isSliver,
  });

  final ScrollController? scrollController;
  final Stream<List<PostModel?>>? stream;
  final Future<void> Function()? onRefresh;
  final bool? isSliver;

  @override
  State<FeedBuilder> createState() => _FeedBuilderState();
}

class _FeedBuilderState extends State<FeedBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bool isSliver = widget.isSliver ?? true;

    return StreamBuilder<List<PostModel?>>(
      stream: widget.stream,
      builder: (context, snapshot) {
        final posts = snapshot.data ?? [];

        if (isSliver) {
          return FeedSliverListView(
            scrollController: widget.scrollController,
            posts: posts,
            onRefresh: widget.onRefresh,
          );
        } else {
          return FeedListView(
            scrollController: widget.scrollController,
            posts: posts,
            onRefresh: widget.onRefresh,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
