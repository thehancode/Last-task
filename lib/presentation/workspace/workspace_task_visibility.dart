import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WorkspaceKeepSelectedTaskVisible extends StatefulWidget {
  const WorkspaceKeepSelectedTaskVisible({
    super.key,
    required this.selected,
    required this.first,
    required this.last,
    required this.child,
  });

  final bool selected;
  final bool first;
  final bool last;
  final Widget child;

  @override
  State<WorkspaceKeepSelectedTaskVisible> createState() =>
      _WorkspaceKeepSelectedTaskVisibleState();
}

class _WorkspaceKeepSelectedTaskVisibleState
    extends State<WorkspaceKeepSelectedTaskVisible> {
  @override
  void initState() {
    super.initState();
    if (widget.selected) _scheduleReveal();
  }

  @override
  void didUpdateWidget(covariant WorkspaceKeepSelectedTaskVisible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected && !oldWidget.selected) {
      _scheduleReveal();
    }
  }

  void _scheduleReveal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reveal();
      // Revealing a row can make the opposite overflow indicator appear,
      // which changes the list viewport by one measured text line. Recheck
      // after that layout so the newly selected row remains fully visible.
      WidgetsBinding.instance.addPostFrameCallback((_) => _reveal());
    });
  }

  void _reveal() {
    if (!mounted) return;
    final scrollable = Scrollable.maybeOf(context);
    final target = context.findRenderObject();
    if (scrollable == null || target == null || !target.attached) return;
    final position = scrollable.position;
    final viewport = RenderAbstractViewport.maybeOf(target);
    if (!position.hasPixels || viewport == null) return;

    if (widget.first) {
      position.jumpTo(position.minScrollExtent);
      return;
    }
    if (widget.last) {
      position.jumpTo(position.maxScrollExtent);
      return;
    }

    final leading = viewport.getOffsetToReveal(target, 0).offset;
    final trailing = viewport.getOffsetToReveal(target, 1).offset;
    double? offset;
    if (leading < position.pixels) {
      offset = leading;
    } else if (trailing > position.pixels) {
      offset = trailing;
    }
    if (offset != null) {
      position.jumpTo(
        offset.clamp(position.minScrollExtent, position.maxScrollExtent),
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
