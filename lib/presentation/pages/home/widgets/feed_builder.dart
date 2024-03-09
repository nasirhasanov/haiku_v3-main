import 'package:flutter/material.dart';

import '../../../../data/models/post_model.dart';
import 'feed_list_view.dart';

class FeedBuilder extends StatefulWidget {
  const FeedBuilder({
    super.key,
    this.scrollController,
    this.stream,
    this.onRefresh,
  });

  final ScrollController? scrollController;
  final Stream<List<PostModel>>? stream;
  final Future<void> Function()? onRefresh;

  @override
  State<FeedBuilder> createState() => _FeedBuilderState();
}

class _FeedBuilderState extends State<FeedBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<PostModel>>(
      stream: widget.stream,
      builder: (context, snapshot) => FeedListView(
        scrollController: widget.scrollController,
        posts: snapshot.data ?? [],
        onRefresh: widget.onRefresh,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
