import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/ui_mode.dart';
import '../../domain/models.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';
import 'workspace_presenters.dart';
import 'workspace_task_row.dart';

DateTime? _statusChangedAt(Task task, TaskStatus sectionStatus) =>
    switch (sectionStatus) {
      TaskStatus.done => task.completedAt,
      TaskStatus.archived => task.updatedAt,
      TaskStatus.pending || TaskStatus.doing => null,
    };

TextStyle? _dialogInputStyle(BuildContext context) =>
    usesTerminalPresentation ? Theme.of(context).textTheme.bodyMedium : null;

class WorkspaceTaskPanel extends ConsumerWidget {
  const WorkspaceTaskPanel({
    super.key,
    required this.state,
    required this.background,
    required this.backgroundConfigured,
    this.contextualTaskId,
    this.onTaskLongPress,
    this.onAndroidListPageChanged,
    this.onAndroidOpenDrawer,
  });
  final WorkspaceState state;
  final Uint8List? background;
  final bool backgroundConfigured;
  final String? contextualTaskId;
  final void Function(Task task, Offset globalPosition)? onTaskLongPress;
  final ValueChanged<int>? onAndroidListPageChanged;
  final VoidCallback? onAndroidOpenDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = state.deviceState.desktopAppearance;
    final hasBackground = background != null;
    final panelOpacity = backgroundConfigured ? 0.0 : 1.0;
    final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final normalContent = switch (state.view) {
      WorkspaceView.list =>
        android
            ? _AndroidListPages(
                state: state,
                onPageChanged: onAndroidListPageChanged,
                onOpenDrawer: onAndroidOpenDrawer,
              )
            : _ListContent(state: state),
      WorkspaceView.completed => _CompletedContent(state: state),
      WorkspaceView.multi => _MultiContent(state: state),
    };
    final border =
        state.view != WorkspaceView.multi && state.currentList?.isHabit == true
        ? TerminalPalette.of(context).doing
        : switch (state.view) {
            WorkspaceView.list => TerminalPalette.of(context).accent,
            WorkspaceView.completed => TerminalPalette.of(context).done,
            WorkspaceView.multi => TerminalPalette.of(context).accent,
          };
    final radius = usesTerminalPresentation
        ? BorderRadius.circular(TerminalMetrics.panelRadius)
        : BorderRadius.circular(12);
    final content = state.search == null
        ? normalContent
        : Column(
            children: [
              const _SearchBar(),
              Expanded(child: normalContent),
            ],
          );
    final panelColor = usesTerminalPresentation
        ? TerminalPalette.of(context).panel
        : Theme.of(context).colorScheme.surface;
    Widget panel = Container(
      key: ValueKey('task-panel-${state.view.name}'),
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: panelColor.withValues(alpha: panelOpacity),
        border: Border.all(color: border),
        borderRadius: radius,
      ),
      child: hasBackground
          ? Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(
                  background!,
                  fit: appearance.backgroundFit == DesktopBackgroundFit.cover
                      ? BoxFit.cover
                      : BoxFit.contain,
                ),
                ColoredBox(
                  color: TerminalPalette.of(context).background.withValues(
                    alpha: appearance.backgroundOverlayOpacity,
                  ),
                ),
                content,
              ],
            )
          : content,
    );
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      panel = WorkspaceTaskInteractions(
        contextualTaskId: contextualTaskId,
        onLongPress: onTaskLongPress ?? (_, _) {},
        child: panel,
      );
    }
    return panel;
  }
}

class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  final _controller = TextEditingController();
  late final _navigationFocusNode = FocusNode(
    debugLabel: 'workspace-search-navigation',
    onKeyEvent: _onKey,
  );
  late final _fieldFocusNode = FocusNode(
    debugLabel: 'workspace-search',
    onKeyEvent: _onKey,
  );

  @override
  void initState() {
    super.initState();
    _fieldFocusNode.addListener(_restoreNavigationFocus);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _fieldFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _fieldFocusNode.removeListener(_restoreNavigationFocus);
    _controller.dispose();
    _navigationFocusNode.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }

  void _restoreNavigationFocus() {
    if (_fieldFocusNode.hasFocus ||
        !mounted ||
        ref.read(workspaceViewModelProvider).search == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          !_fieldFocusNode.hasFocus &&
          ref.read(workspaceViewModelProvider).search != null) {
        _navigationFocusNode.requestFocus();
      }
    });
  }

  void _close() {
    ref.read(workspaceViewModelProvider.notifier).closeSearch();
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      vm.moveSearch(-1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      vm.moveSearch(1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _close();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _close();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(workspaceViewModelProvider).search!;
    final current = search.matchIds.isEmpty ? 0 : search.currentIndex + 1;
    return Focus(
      focusNode: _navigationFocusNode,
      onKeyEvent: _onKey,
      child: Padding(
        key: const ValueKey('workspace-search-line'),
        padding: EdgeInsets.symmetric(
          horizontal: TerminalMetrics.cell(context),
          vertical: usesTerminalPresentation
              ? TerminalMetrics.line(context) * .1
              : 2,
        ),
        child: Row(
          children: [
            Text('${AppLocalizations.of(context)!.search}: '),
            Expanded(
              child: TextField(
                key: const ValueKey('workspace-search-field'),
                controller: _controller,
                focusNode: _fieldFocusNode,
                autofocus: true,
                style: _dialogInputStyle(context),
                decoration: const InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                onChanged: ref
                    .read(workspaceViewModelProvider.notifier)
                    .updateSearch,
                onSubmitted: (_) => _close(),
                onTapOutside: (_) => _navigationFocusNode.requestFocus(),
              ),
            ),
            Text('$current/${search.matchIds.length} '),
            _SearchControl(
              label: '△',
              tooltip: AppLocalizations.of(context)!.previousMatch,
              onTap: () =>
                  ref.read(workspaceViewModelProvider.notifier).moveSearch(-1),
            ),
            _SearchControl(
              label: '▽',
              tooltip: AppLocalizations.of(context)!.nextMatch,
              onTap: () =>
                  ref.read(workspaceViewModelProvider.notifier).moveSearch(1),
            ),
            _SearchControl(
              label: '⨯',
              tooltip: AppLocalizations.of(context)!.closeSearch,
              onTap: _close,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchControl extends StatelessWidget {
  const _SearchControl({
    required this.label,
    required this.tooltip,
    required this.onTap,
  });
  final String label;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TerminalMetrics.cell(context) / 2,
        ),
        child: Text(label),
      ),
    ),
  );
}

class _ListContent extends StatelessWidget {
  const _ListContent({required this.state});
  final WorkspaceState state;

  @override
  Widget build(BuildContext context) {
    final visible = visibleTreeTasks(
      state.currentList,
      revealTaskIds: state.search?.matchIds.toSet() ?? const {},
    );
    return _TaskScrollView(
      key: const ValueKey('task-scroll-list'),
      eager: state.search != null,
      indicatorColor: TerminalPalette.of(context).accent,
      padding: usesTerminalPresentation
          ? TerminalMetrics.panelPadding(context)
          : const EdgeInsets.all(12),
      children: [
        for (final status in const [
          TaskStatus.pending,
          TaskStatus.done,
          TaskStatus.archived,
        ])
          _TaskSection(
            state: state,
            title: workspaceStatusLabel(status, AppLocalizations.of(context)!),
            status: status,
            tasks: visible.where((task) {
              final rootStatus = taskRoot(state.currentList!, task).status;
              return status == TaskStatus.pending
                  ? rootStatus == TaskStatus.doing ||
                        rootStatus == TaskStatus.pending
                  : rootStatus == status;
            }).toList(),
          ),
      ],
    );
  }
}

abstract final class AndroidGestureConfig {
  static const touchSlop = 18.0;
  static const horizontalDominance = 1.6;
  static const pageCommitViewportFraction = 0.20;
  static const pageCommitMinDistance = 72.0;
  static const pageCommitMaxDistance = 112.0;
  static const pageFlingVelocity = 350.0;
  static const drawerEdgeWidth = 24.0;
  static const drawerOpenDistance = 44.0;
  static const settleDuration = Duration(milliseconds: 220);

  static double pageCommitDistance(double viewportDimension) =>
      (viewportDimension * pageCommitViewportFraction).clamp(
        pageCommitMinDistance,
        pageCommitMaxDistance,
      );
}

class _AndroidGestureTrace {
  _AndroidGestureTrace({
    required this.source,
    required this.startPage,
    required this.startedAt,
  });

  final String source;
  final int startPage;
  final Duration startedAt;
  Offset total = Offset.zero;
  Offset? lockDelta;
  String owner = 'unclaimed';
  String result = 'none';
  double releaseVelocity = 0;
  Duration endedAt = Duration.zero;

  double _angle(Offset delta) =>
      math.atan2(delta.dy.abs(), delta.dx.abs()) * 180 / math.pi;

  String _ratio(Offset delta) => delta.dy == 0
      ? 'inf'
      : (delta.dx.abs() / delta.dy.abs()).toStringAsFixed(2);

  void printToConsole() {
    if (!kDebugMode) return;
    final lock = lockDelta;
    final elapsed = (endedAt - startedAt).inMilliseconds;
    debugPrint(
      '[android-gesture] source=$source startPage=$startPage '
      'dx=${total.dx.toStringAsFixed(1)} dy=${total.dy.toStringAsFixed(1)} '
      'angle=${_angle(total).toStringAsFixed(1)}deg ratio=${_ratio(total)} '
      'lockDx=${lock?.dx.toStringAsFixed(1) ?? '-'} '
      'lockDy=${lock?.dy.toStringAsFixed(1) ?? '-'} '
      'lockAngle=${lock == null ? '-' : '${_angle(lock).toStringAsFixed(1)}deg'} '
      'velocity=${releaseVelocity.toStringAsFixed(1)} '
      'elapsed=${elapsed}ms owner=$owner result=$result',
    );
  }
}

class _DominantHorizontalDragGestureRecognizer
    extends HorizontalDragGestureRecognizer {
  _DominantHorizontalDragGestureRecognizer({super.debugOwner});

  Offset _distance = Offset.zero;
  ValueChanged<Offset>? onQualified;
  bool _reportedQualification = false;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _distance = Offset.zero;
    _reportedQualification = false;
    super.addAllowedPointer(event);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) _distance += event.delta;
    super.handleEvent(event);
  }

  @override
  bool hasSufficientGlobalDistanceToAccept(
    PointerDeviceKind pointerDeviceKind,
    double? deviceTouchSlop,
  ) {
    final qualifies =
        _distance.dx.abs() > AndroidGestureConfig.touchSlop &&
        _distance.dx.abs() >=
            _distance.dy.abs() * AndroidGestureConfig.horizontalDominance;
    if (qualifies && !_reportedQualification) {
      _reportedQualification = true;
      onQualified?.call(_distance);
    }
    return qualifies;
  }
}

enum _AndroidHorizontalGestureOwner { page, drawer, blocked }

class _AndroidListPages extends StatefulWidget {
  const _AndroidListPages({
    required this.state,
    this.onPageChanged,
    this.onOpenDrawer,
  });

  final WorkspaceState state;
  final ValueChanged<int>? onPageChanged;
  final VoidCallback? onOpenDrawer;

  @override
  State<_AndroidListPages> createState() => _AndroidListPagesState();
}

class _AndroidListPagesState extends State<_AndroidListPages> {
  final _pageController = PageController();
  int _pageIndex = 0;
  int _gestureStartPage = 0;
  double _gestureStartPixels = 0;
  double _gestureDx = 0;
  _AndroidHorizontalGestureOwner? _gestureOwner;
  _AndroidGestureTrace? _gestureTrace;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onPageChanged?.call(0);
    });
  }

  @override
  void didUpdateWidget(covariant _AndroidListPages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.currentListId == widget.state.currentListId) return;
    _pageIndex = 0;
    _gestureOwner = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_pageController.hasClients) _pageController.jumpToPage(0);
      widget.onPageChanged?.call(0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (!_pageController.hasClients) return;
    _gestureStartPage = _pageIndex;
    _gestureStartPixels = _pageController.position.pixels;
    _gestureDx = 0;
    _gestureOwner = null;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_pageController.hasClients) return;
    final delta = details.primaryDelta ?? 0;
    _gestureDx += delta;
    _gestureOwner ??= switch ((_gestureStartPage, _gestureDx.sign)) {
      (0, < 0) => _AndroidHorizontalGestureOwner.page,
      (0, > 0) => _AndroidHorizontalGestureOwner.drawer,
      (1, > 0) => _AndroidHorizontalGestureOwner.page,
      _ => _AndroidHorizontalGestureOwner.blocked,
    };
    _gestureTrace?.owner = _gestureOwner!.name;
    if (_gestureOwner != _AndroidHorizontalGestureOwner.page) return;
    final position = _pageController.position;
    final target = (_gestureStartPixels - _gestureDx).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    _pageController.jumpTo(target);
  }

  void _handleDragEnd(DragEndDetails details) {
    final owner = _gestureOwner;
    _gestureOwner = null;
    _gestureTrace?.releaseVelocity = details.primaryVelocity ?? 0;
    if (owner == _AndroidHorizontalGestureOwner.drawer) {
      if (_gestureDx >= AndroidGestureConfig.drawerOpenDistance) {
        _gestureTrace?.result = 'drawer-opened';
        widget.onOpenDrawer?.call();
      } else {
        _gestureTrace?.result = 'drawer-distance-rejected';
      }
      return;
    }
    if (owner != _AndroidHorizontalGestureOwner.page ||
        !_pageController.hasClients) {
      _gestureTrace?.result = owner == _AndroidHorizontalGestureOwner.blocked
          ? 'blocked'
          : 'horizontal-rejected';
      return;
    }
    final position = _pageController.position;
    final distance = (position.pixels - _gestureStartPixels).abs();
    final velocity = details.primaryVelocity ?? 0;
    final velocityMatchesDirection =
        velocity.abs() >= AndroidGestureConfig.pageFlingVelocity &&
        velocity.sign == _gestureDx.sign;
    final commits =
        distance >=
            AndroidGestureConfig.pageCommitDistance(
              position.viewportDimension,
            ) ||
        velocityMatchesDirection;
    final direction = (-_gestureDx).sign.toInt();
    final targetPage = commits
        ? (_gestureStartPage + direction).clamp(0, 1)
        : _gestureStartPage;
    _gestureTrace?.result = commits
        ? 'page-committed-$targetPage'
        : 'page-returned-$_gestureStartPage';
    _settleToPage(targetPage);
  }

  void _handleDragCancel() {
    final owner = _gestureOwner;
    _gestureOwner = null;
    _gestureTrace?.result = owner == null
        ? 'horizontal-rejected'
        : 'horizontal-cancelled';
    if (owner == _AndroidHorizontalGestureOwner.page) {
      _settleToPage(_gestureStartPage);
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!kDebugMode) return;
    _gestureTrace = _AndroidGestureTrace(
      source: 'panel',
      startPage: _pageIndex,
      startedAt: event.timeStamp,
    );
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!kDebugMode) return;
    _gestureTrace?.total += event.delta;
  }

  void _handlePointerEnd(PointerEvent event) {
    if (!kDebugMode) return;
    final trace = _gestureTrace;
    if (trace == null) return;
    trace.endedAt = event.timeStamp;
    scheduleMicrotask(() {
      trace.printToConsole();
      if (identical(_gestureTrace, trace)) _gestureTrace = null;
    });
  }

  void _settleToPage(int page) {
    if (!_pageController.hasClients) return;
    unawaited(
      _pageController.animateToPage(
        page,
        duration: AndroidGestureConfig.settleDuration,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: _handlePointerDown,
    onPointerMove: _handlePointerMove,
    onPointerUp: _handlePointerEnd,
    onPointerCancel: _handlePointerEnd,
    child: RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: {
        _DominantHorizontalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<
              _DominantHorizontalDragGestureRecognizer
            >(
              () => _DominantHorizontalDragGestureRecognizer(debugOwner: this),
              (recognizer) => recognizer
                ..dragStartBehavior = DragStartBehavior.down
                ..onlyAcceptDragOnThreshold = true
                ..onQualified = (delta) {
                  _gestureTrace?.lockDelta ??= delta;
                }
                ..onStart = _handleDragStart
                ..onUpdate = _handleDragUpdate
                ..onEnd = _handleDragEnd
                ..onCancel = _handleDragCancel,
            ),
      },
      child: PageView(
        key: ValueKey('android-list-pages-${widget.state.currentListId}'),
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          _pageIndex = index;
          widget.onPageChanged?.call(index);
        },
        children: [
          _AndroidPendingContent(
            key: ValueKey('android-active-list-${widget.state.currentListId}'),
            state: widget.state,
          ),
          _AndroidDoneArchivedContent(state: widget.state),
        ],
      ),
    ),
  );
}

class AndroidDrawerEdgeDragRegion extends StatefulWidget {
  const AndroidDrawerEdgeDragRegion({super.key, required this.onOpenDrawer});

  final VoidCallback onOpenDrawer;

  @override
  State<AndroidDrawerEdgeDragRegion> createState() =>
      _AndroidDrawerEdgeDragRegionState();
}

class _AndroidDrawerEdgeDragRegionState
    extends State<AndroidDrawerEdgeDragRegion> {
  double _dx = 0;
  _AndroidGestureTrace? _gestureTrace;

  void _handlePointerDown(PointerDownEvent event) {
    if (!kDebugMode) return;
    _gestureTrace = _AndroidGestureTrace(
      source: 'edge',
      startPage: 0,
      startedAt: event.timeStamp,
    );
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!kDebugMode) return;
    _gestureTrace?.total += event.delta;
  }

  void _handlePointerEnd(PointerEvent event) {
    if (!kDebugMode) return;
    final trace = _gestureTrace;
    if (trace == null) return;
    trace.endedAt = event.timeStamp;
    scheduleMicrotask(() {
      trace.printToConsole();
      if (identical(_gestureTrace, trace)) _gestureTrace = null;
    });
  }

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: _handlePointerDown,
    onPointerMove: _handlePointerMove,
    onPointerUp: _handlePointerEnd,
    onPointerCancel: _handlePointerEnd,
    child: RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: {
        _DominantHorizontalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<
              _DominantHorizontalDragGestureRecognizer
            >(
              () => _DominantHorizontalDragGestureRecognizer(debugOwner: this),
              (recognizer) {
                recognizer
                  ..dragStartBehavior = DragStartBehavior.down
                  ..onlyAcceptDragOnThreshold = true
                  ..onQualified = (delta) {
                    _gestureTrace?.lockDelta ??= delta;
                  }
                  ..onStart = (_) {
                    _dx = 0;
                    _gestureTrace?.owner = 'drawer';
                  }
                  ..onUpdate = (details) {
                    _dx += details.primaryDelta ?? 0;
                  }
                  ..onEnd = (details) {
                    _gestureTrace?.releaseVelocity =
                        details.primaryVelocity ?? 0;
                    if (_dx >= AndroidGestureConfig.drawerOpenDistance) {
                      _gestureTrace?.result = 'drawer-opened';
                      widget.onOpenDrawer();
                    } else {
                      _gestureTrace?.result = 'drawer-distance-rejected';
                    }
                    _dx = 0;
                  }
                  ..onCancel = () {
                    _gestureTrace?.result = 'horizontal-cancelled';
                    _dx = 0;
                  };
              },
            ),
      },
      child: const SizedBox.expand(),
    ),
  );
}

class _AndroidPendingContent extends StatelessWidget {
  const _AndroidPendingContent({super.key, required this.state});

  final WorkspaceState state;

  @override
  Widget build(BuildContext context) {
    final visible = visibleTreeTasks(
      state.currentList,
      revealTaskIds: state.search?.matchIds.toSet() ?? const {},
    );
    final pendingTasks = visible.where((task) {
      final status = taskRoot(state.currentList!, task).status;
      return status == TaskStatus.doing || status == TaskStatus.pending;
    }).toList();
    final title = workspaceStatusLabel(
      TaskStatus.pending,
      AppLocalizations.of(context)!,
    );
    if (state.search == null) {
      return _TaskScrollView.slivers(
        key: const ValueKey('task-scroll-list'),
        indicatorColor: TerminalPalette.of(context).accent,
        padding: const EdgeInsets.all(12),
        slivers: [
          _AndroidTaskSectionSliver(
            state: state,
            title: title,
            status: TaskStatus.pending,
            tasks: pendingTasks,
          ),
        ],
      );
    }
    return _TaskScrollView(
      key: const ValueKey('task-scroll-list'),
      eager: true,
      indicatorColor: TerminalPalette.of(context).accent,
      padding: const EdgeInsets.all(12),
      children: [
        _TaskSection(
          state: state,
          title: title,
          status: TaskStatus.pending,
          tasks: pendingTasks,
        ),
      ],
    );
  }
}

class _AndroidDoneArchivedContent extends StatelessWidget {
  const _AndroidDoneArchivedContent({required this.state});

  final WorkspaceState state;

  @override
  Widget build(BuildContext context) {
    final searchMatches = state.search?.matchIds.toSet() ?? const <String>{};
    final doneTasks = visibleTreeTasks(
      state.currentList,
      rootStatuses: const {TaskStatus.done},
      revealTaskIds: searchMatches,
    );
    final archivedTasks = visibleTreeTasks(
      state.currentList,
      rootStatuses: const {TaskStatus.archived},
      revealTaskIds: searchMatches,
    );
    final doneTitle = workspaceStatusLabel(
      TaskStatus.done,
      AppLocalizations.of(context)!,
    );
    final archivedTitle = workspaceStatusLabel(
      TaskStatus.archived,
      AppLocalizations.of(context)!,
    );
    return KeyedSubtree(
      key: const ValueKey('android-done-archived-panel'),
      child: state.search == null
          ? _TaskScrollView.slivers(
              key: const ValueKey('task-scroll-done-archived'),
              indicatorColor: TerminalPalette.of(context).done,
              padding: const EdgeInsets.all(12),
              slivers: [
                _AndroidTaskSectionSliver(
                  state: state,
                  title: doneTitle,
                  status: TaskStatus.done,
                  tasks: doneTasks,
                ),
                _AndroidTaskSectionSliver(
                  sectionKey: const ValueKey('android-archived-panel'),
                  state: state,
                  title: archivedTitle,
                  status: TaskStatus.archived,
                  tasks: archivedTasks,
                ),
              ],
            )
          : _TaskScrollView(
              key: const ValueKey('task-scroll-done-archived'),
              eager: true,
              indicatorColor: TerminalPalette.of(context).done,
              padding: const EdgeInsets.all(12),
              children: [
                _TaskSection(
                  state: state,
                  title: doneTitle,
                  status: TaskStatus.done,
                  tasks: doneTasks,
                ),
                KeyedSubtree(
                  key: const ValueKey('android-archived-panel'),
                  child: _TaskSection(
                    state: state,
                    title: archivedTitle,
                    status: TaskStatus.archived,
                    tasks: archivedTasks,
                  ),
                ),
              ],
            ),
    );
  }
}

class _CompletedContent extends StatelessWidget {
  const _CompletedContent({required this.state});
  final WorkspaceState state;

  @override
  Widget build(BuildContext context) {
    final rows = completedTreeRows(
      state.currentList,
      revealTaskIds: state.search?.matchIds.toSet() ?? const {},
    );
    if (rows.isEmpty) {
      return WorkspaceEmptyState(
        AppLocalizations.of(context)!.noCompletedTasks,
      );
    }
    return _TaskScrollView(
      key: const ValueKey('task-scroll-completed'),
      eager: state.search != null,
      indicatorColor: TerminalPalette.of(context).done,
      padding: usesTerminalPresentation
          ? TerminalMetrics.panelPadding(context)
          : const EdgeInsets.all(12),
      children: [
        for (var index = 0; index < rows.length; index++)
          WorkspaceTaskRow(
            task: rows[index].task,
            state: state,
            statusChangedAt: rows[index].completedAt,
            showMobileDivider:
                index < rows.length - 1 &&
                rows[index].task.parentId == null &&
                rows[index + 1].task.parentId == null,
          ),
      ],
    );
  }
}

class _MultiContent extends StatelessWidget {
  const _MultiContent({required this.state});
  final WorkspaceState state;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final list in state.lists) {
      final searchMatchIds = state.search?.matchIds.toSet() ?? const <String>{};
      final visible = visibleTreeTasks(
        list,
        rootStatuses: const {TaskStatus.doing, TaskStatus.pending},
        revealTaskIds: searchMatchIds,
      );
      final matchingDoneRootIds = <String>{
        for (final task in list.tasks)
          if (searchMatchIds.contains(task.id) &&
              taskRoot(list, task).status == TaskStatus.done)
            taskRoot(list, task).id,
      };
      final matchingDoneTasks = matchingDoneRootIds.isEmpty
          ? const <Task>[]
          : visibleTreeTasks(
                  list,
                  rootStatuses: const {TaskStatus.done},
                  revealTaskIds: searchMatchIds,
                )
                .where(
                  (task) =>
                      matchingDoneRootIds.contains(taskRoot(list, task).id),
                )
                .toList();
      if (visible.isEmpty && matchingDoneTasks.isEmpty) continue;
      children.add(
        Padding(
          padding: EdgeInsets.only(
            top: usesTerminalPresentation ? 0 : 8,
            bottom: usesTerminalPresentation ? 0 : 4,
          ),
          child: Text(
            list.name.toUpperCase(),
            style: TextStyle(
              color: TerminalPalette.of(context).accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      for (final status in const [TaskStatus.doing, TaskStatus.pending]) {
        final tasks = visible
            .where((task) => taskRoot(list, task).status == status)
            .toList();
        if (tasks.isNotEmpty) {
          children.add(
            _TaskSection(
              state: state,
              title: workspaceStatusLabel(
                status,
                AppLocalizations.of(context)!,
              ),
              status: status,
              tasks: tasks,
            ),
          );
        }
      }
      if (matchingDoneTasks.isNotEmpty) {
        children.add(
          _TaskSection(
            state: state,
            title: workspaceStatusLabel(
              TaskStatus.done,
              AppLocalizations.of(context)!,
            ),
            status: TaskStatus.done,
            tasks: matchingDoneTasks,
          ),
        );
      }
    }
    return children.isEmpty
        ? WorkspaceEmptyState(
            AppLocalizations.of(context)!.noDoingOrPendingTasks,
          )
        : _TaskScrollView(
            key: const ValueKey('task-scroll-multi'),
            eager: state.search != null,
            indicatorColor: TerminalPalette.of(context).accent,
            padding: usesTerminalPresentation
                ? TerminalMetrics.panelPadding(context)
                : const EdgeInsets.all(12),
            children: children,
          );
  }
}

class _TaskScrollView extends StatefulWidget {
  const _TaskScrollView({
    super.key,
    required this.eager,
    required this.indicatorColor,
    required this.padding,
    required this.children,
  }) : slivers = null;

  const _TaskScrollView.slivers({
    super.key,
    required this.indicatorColor,
    required this.padding,
    required this.slivers,
  }) : eager = false,
       children = null;

  final bool eager;
  final Color indicatorColor;
  final EdgeInsetsGeometry padding;
  final List<Widget>? children;
  final List<Widget>? slivers;

  @override
  State<_TaskScrollView> createState() => _TaskScrollViewState();
}

class _TaskScrollViewState extends State<_TaskScrollView> {
  final _controller = ScrollController();
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateIndicators);
    _scheduleIndicatorUpdate();
  }

  @override
  void didUpdateWidget(covariant _TaskScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scheduleIndicatorUpdate();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_updateIndicators)
      ..dispose();
    super.dispose();
  }

  void _scheduleIndicatorUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateIndicators();
    });
  }

  void _updateIndicators() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    final canScrollUp = position.extentBefore > 0.5;
    final canScrollDown = position.extentAfter > 0.5;
    if (canScrollUp == _canScrollUp && canScrollDown == _canScrollDown) {
      return;
    }
    setState(() {
      _canScrollUp = canScrollUp;
      _canScrollDown = canScrollDown;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewport = widget.slivers != null
        ? CustomScrollView(
            key: const ValueKey('task-list-viewport'),
            controller: _controller,
            slivers: [
              SliverPadding(
                padding: widget.padding,
                sliver: SliverMainAxisGroup(slivers: widget.slivers!),
              ),
            ],
          )
        : widget.eager
        ? SingleChildScrollView(
            key: const ValueKey('task-list-viewport'),
            controller: _controller,
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children!,
            ),
          )
        : ListView(
            key: const ValueKey('task-list-viewport'),
            controller: _controller,
            padding: widget.padding,
            children: widget.children!,
          );
    if (!usesTerminalPresentation) {
      return ShaderMask(
        key: const ValueKey('android-task-scroll-fade'),
        blendMode: BlendMode.dstIn,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _canScrollUp ? Colors.transparent : Colors.black,
            Colors.black,
            Colors.black,
            _canScrollDown ? Colors.transparent : Colors.black,
          ],
          stops: const [0, .06, .94, 1],
        ).createShader(bounds),
        child: viewport,
      );
    }
    return Column(
      children: [
        if (_canScrollUp)
          _TaskOverflowIndicator(
            key: const ValueKey('task-overflow-up'),
            glyph: '▲',
            color: widget.indicatorColor,
          ),
        Expanded(child: viewport),
        if (_canScrollDown)
          _TaskOverflowIndicator(
            key: const ValueKey('task-overflow-down'),
            glyph: '▼',
            color: widget.indicatorColor,
          ),
      ],
    );
  }
}

class _AndroidTaskSectionSliver extends StatelessWidget {
  const _AndroidTaskSectionSliver({
    this.sectionKey,
    required this.state,
    required this.title,
    required this.status,
    required this.tasks,
  });

  final Key? sectionKey;
  final WorkspaceState state;
  final String title;
  final TaskStatus status;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) => SliverMainAxisGroup(
    slivers: [
      SliverToBoxAdapter(
        child: Text(
          key: sectionKey,
          '${workspaceStatusIcon(status)} $title (${tasks.where((task) => task.parentId == null).length})',
          style: TextStyle(
            color: workspaceStatusColor(context, status),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 4)),
      if (tasks.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '· ${AppLocalizations.of(context)!.empty}',
              style: TextStyle(color: TerminalPalette.of(context).muted),
            ),
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => WorkspaceTaskRow(
              task: tasks[index],
              state: state,
              statusChangedAt: _statusChangedAt(tasks[index], status),
              showMobileDivider:
                  index < tasks.length - 1 &&
                  tasks[index].parentId == null &&
                  tasks[index + 1].parentId == null,
            ),
            childCount: tasks.length,
          ),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: 14)),
    ],
  );
}

class _TaskOverflowIndicator extends StatelessWidget {
  const _TaskOverflowIndicator({
    super.key,
    required this.glyph,
    required this.color,
  });

  final String glyph;
  final Color color;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Center(
      child: Semantics(
        label: glyph == '▲' ? 'More tasks above' : 'More tasks below',
        child: Text(
          glyph,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({
    required this.state,
    required this.title,
    required this.status,
    required this.tasks,
  });
  final WorkspaceState state;
  final String title;
  final TaskStatus status;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: usesTerminalPresentation ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${workspaceStatusIcon(status)} $title (${tasks.where((task) => task.parentId == null).length})',
            style: TextStyle(
              color: workspaceStatusColor(context, status),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: usesTerminalPresentation ? 0 : 4),
          if (tasks.isEmpty)
            Padding(
              padding: EdgeInsets.only(
                left: 8,
                bottom: usesTerminalPresentation
                    ? TerminalMetrics.line(context)
                    : 0,
              ),
              child: Text(
                '· ${AppLocalizations.of(context)!.empty}',
                style: TextStyle(color: TerminalPalette.of(context).muted),
              ),
            )
          else
            for (var index = 0; index < tasks.length; index++)
              WorkspaceTaskRow(
                task: tasks[index],
                state: state,
                statusChangedAt: _statusChangedAt(tasks[index], status),
                showMobileDivider:
                    index < tasks.length - 1 &&
                    tasks[index].parentId == null &&
                    tasks[index + 1].parentId == null,
              ),
        ],
      ),
    );
  }
}
