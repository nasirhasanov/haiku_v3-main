import 'package:flutter/material.dart';
import 'package:haiku/data/models/talk_model.dart';
import 'package:haiku/presentation/pages/home/widgets/talks_list_view.dart';

class TalksBuilder extends StatefulWidget {
  const TalksBuilder({
    super.key,
    this.scrollController,
    this.stream,
    this.onRefresh,
  });

  final ScrollController? scrollController;
  final Stream<List<TalkModel>>? stream;
  final Future<void> Function()? onRefresh;

  @override
  State<TalksBuilder> createState() => _TalksBuilderState();
}

class _TalksBuilderState extends State<TalksBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      child: StreamBuilder<List<TalkModel>>(
          stream: widget.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No talks available.'),
              );
            } else {
              return TalksListView(
                scrollController: widget.scrollController,
                talks: snapshot.data ?? [],
                onRefresh: widget.onRefresh,
              );
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
