import 'package:flutter/material.dart';

import '../../views/dashboard/dashboard.dart';

const SCROLL_THRESHOLD = 125.0;

/// [NestedScrollManager] is used to enable scrolling a inner scrollable Widget
/// and scroll the outer (parent) scrollable Widget as soon as the start / end of
/// the inner scrollable Widget has been reached and the user keeps on scrolling
/// (and reaching the [SCROLL_THRESHOLD]) so we direct the user-scroll to the parent
///
/// Right now only [ClampingScrollPhysics] for inner and parent scrollable Widget is
/// supported to guarantee a good behaviour - might be changed later
class NestedScrollManager extends StatefulWidget {
  final Widget child;

  NestedScrollManager({@required this.child});

  @override
  _NestedScrollManagerState createState() => _NestedScrollManagerState();
}

class _NestedScrollManagerState extends State<NestedScrollManager> {
  double _scrollThreshold = 0.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: (value) {
        /// Check if overscroll is still in the same direction so user might want to scroll
        /// further instead of scroll the inner ListView
        if (_scrollThreshold <= 0 && value.overscroll <= 0 ||
            _scrollThreshold >= 0 && value.overscroll >= 0) {
          _scrollThreshold += value.overscroll;
        } else {
          _scrollThreshold = 0;
        }

        /// Inner ListView end or start has been reached and user keeps on scrolling ([_scrollThreshold]
        /// has reached [SCROLL_THRESHOLD]) so we manually pass the user scroll to the outer
        /// ListView
        if (_scrollThreshold.abs() >= SCROLL_THRESHOLD) {
          double scrollPosition =
              DashboardScroll.of(context).scrollController.offset +
                  value.overscroll;
          DashboardScroll.of(context).scrollController.jumpTo(scrollPosition <
                  DashboardScroll.of(context)
                      .scrollController
                      .position
                      .minScrollExtent
              ? 0
              : scrollPosition >
                      DashboardScroll.of(context)
                          .scrollController
                          .position
                          .maxScrollExtent
                  ? DashboardScroll.of(context)
                      .scrollController
                      .position
                      .maxScrollExtent
                  : scrollPosition);
        }
        return true;
      },
      child: widget.child,
    );
  }
}