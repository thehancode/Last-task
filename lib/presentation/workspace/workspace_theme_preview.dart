import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme_catalog.dart';
import '../terminal_style.dart';

class WorkspaceThemePreview extends StatelessWidget {
  const WorkspaceThemePreview({super.key, required this.theme});

  final AppThemeDefinition theme;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: theme.panel,
    padding: TerminalMetrics.panelPadding(context),
    child: DefaultTextStyle(
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(color: theme.text),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('● Doing', style: TextStyle(color: theme.doing)),
          Text('◌ Pending', style: TextStyle(color: theme.pending)),
          Text('✓ Done', style: TextStyle(color: theme.done)),
          const Text('  sample task'),
          Text(
            '  sample task',
            style: TextStyle(
              color: theme.muted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Container(
            width: double.infinity,
            color: theme.accent,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              '› selected task',
              style: TextStyle(
                color: theme.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Horizontally scrolls long theme names while retaining their full semantics.
class WorkspaceMarqueeText extends StatefulWidget {
  const WorkspaceMarqueeText({super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  State<WorkspaceMarqueeText> createState() => _WorkspaceMarqueeTextState();
}

class _WorkspaceMarqueeTextState extends State<WorkspaceMarqueeText> {
  final _controller = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      if (_controller.position.maxScrollExtent <= 0) return;
      _timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
        if (!_controller.hasClients) return;
        final max = _controller.position.maxScrollExtent;
        final next = _controller.offset + TerminalMetrics.cell(context) * .2;
        _controller.jumpTo(next > max ? 0 : next);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.text,
    child: ExcludeSemantics(
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        child: Text(widget.text, maxLines: 1, style: widget.style),
      ),
    ),
  );
}
