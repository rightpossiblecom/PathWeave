import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/puzzle_levels.dart';
import '../../core/services/storage_service.dart';
import '../home/home_view_model.dart';
import '../settings/settings_view_model.dart';
import 'game_view_model.dart';

class GameScreen extends StatelessWidget {
  final PuzzleLevel initialLevel;

  const GameScreen({super.key, required this.initialLevel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => GameViewModel(
        ctx.read<StorageService>(),
        initialLevel,
      ),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  String _formatClock(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = context.watch<SettingsViewModel>();
    final vm = context.watch<GameViewModel>();
    final level = vm.level;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          context.read<HomeViewModel>().refresh();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              context.read<HomeViewModel>().refresh();
              Navigator.of(context).pop();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                level.isDaily
                    ? 'Daily Weave'
                    : 'Level ${level.id} · ${level.title}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${level.chapter} · ${level.rows}×${level.cols} Grid',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'How to play',
              icon: const Icon(Icons.help_outline_rounded),
              onPressed: () => _showHowToPlay(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              children: [
                _StatusHeader(
                  stepCount: vm.path.length,
                  totalOpen: level.openCount,
                  clock: _formatClock(vm.elapsedSeconds),
                  progress: vm.progress,
                ),
                if (vm.statusNote != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      vm.statusNote!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: _InteractiveBoard(
                      vm: vm,
                      showStepNumbers: settings.showStepNumbers,
                      haptics: settings.hapticsEnabled,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (vm.isSolved)
                  _SolvedBanner(
                    vm: vm,
                    onNextLevel: () {
                      context.read<HomeViewModel>().refresh();
                      if (level.isDaily ||
                          level.id >= PuzzleLevels.campaign.length) {
                        Navigator.of(context).pop();
                      } else {
                        final next = PuzzleLevels.campaign[level.id];
                        vm.loadLevel(next);
                      }
                    },
                  )
                else
                  _ControlRow(
                    canUndo: vm.path.length > 1,
                    onUndo: () =>
                        vm.undoStep(haptics: settings.hapticsEnabled),
                    onRestart: () =>
                        vm.restartLevel(haptics: settings.hapticsEnabled),
                    onHint: () => vm.useHint(haptics: settings.hapticsEnabled),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surfaceContainerLow,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How to Weave',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            _RuleRow(
              icon: Icons.gesture_rounded,
              text:
                  'Drag from the glowing start tile or tap adjacent tiles to extend your path.',
            ),
            const SizedBox(height: 10),
            _RuleRow(
              icon: Icons.grid_view_rounded,
              text:
                  'Visit every open tile exactly once. Dark stone blocks cannot be crossed.',
            ),
            const SizedBox(height: 10),
            _RuleRow(
              icon: Icons.flag_circle_rounded,
              text:
                  'Numbered anchor tiles (#N) must be visited on that exact step number.',
            ),
            const SizedBox(height: 10),
            _RuleRow(
              icon: Icons.undo_rounded,
              text:
                  'Drag backward onto your own trail at any time to unwind mistakes.',
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _RuleRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final int stepCount;
  final int totalOpen;
  final String clock;
  final double progress;

  const _StatusHeader({
    required this.stepCount,
    required this.totalOpen,
    required this.clock,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timeline_rounded,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$stepCount / $totalOpen tiles woven',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 15,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      clock,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveBoard extends StatelessWidget {
  final GameViewModel vm;
  final bool showStepNumbers;
  final bool haptics;

  const _InteractiveBoard({
    required this.vm,
    required this.showStepNumbers,
    required this.haptics,
  });

  void _handleOffset(
    Offset localPosition,
    double boardWidth,
    double boardHeight,
  ) {
    final cellW = boardWidth / vm.level.cols;
    final cellH = boardHeight / vm.level.rows;
    final col = (localPosition.dx / cellW).floor();
    final row = (localPosition.dy / cellH).floor();
    if (row >= 0 &&
        row < vm.level.rows &&
        col >= 0 &&
        col < vm.level.cols) {
      vm.handleCellInput(GridCell(row, col), haptics: haptics);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final level = vm.level;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        final cellSize = min(maxW / level.cols, maxH / level.rows);
        final boardW = cellSize * level.cols;
        final boardH = cellSize * level.rows;

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: SizedBox(
            width: boardW,
            height: boardH,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) =>
                  _handleOffset(details.localPosition, boardW, boardH),
              onPanStart: (details) =>
                  _handleOffset(details.localPosition, boardW, boardH),
              onPanUpdate: (details) =>
                  _handleOffset(details.localPosition, boardW, boardH),
              child: CustomPaint(
                size: Size(boardW, boardH),
                painter: _WeaveBoardPainter(
                  level: level,
                  path: vm.path,
                  isSolved: vm.isSolved,
                  showStepNumbers: showStepNumbers,
                  colorScheme: colorScheme,
                  textStyle: Theme.of(context).textTheme.labelMedium!,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WeaveBoardPainter extends CustomPainter {
  final PuzzleLevel level;
  final List<GridCell> path;
  final bool isSolved;
  final bool showStepNumbers;
  final ColorScheme colorScheme;
  final TextStyle textStyle;

  _WeaveBoardPainter({
    required this.level,
    required this.path,
    required this.isSolved,
    required this.showStepNumbers,
    required this.colorScheme,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / level.cols;
    final cellH = size.height / level.rows;
    final pad = min(cellW, cellH) * 0.08;
    final radius = Radius.circular(min(cellW, cellH) * 0.24);

    final visitedSet = path.toSet();

    for (var r = 0; r < level.rows; r++) {
      for (var c = 0; c < level.cols; c++) {
        final cell = GridCell(r, c);
        final rect = Rect.fromLTWH(
          c * cellW + pad,
          r * cellH + pad,
          cellW - pad * 2,
          cellH - pad * 2,
        );
        final rrect = RRect.fromRectAndRadius(rect, radius);

        if (level.isBlocked(cell)) {
          final blockPaint = Paint()
            ..color = colorScheme.onSurface.withValues(alpha: 0.14);
          canvas.drawRRect(rrect, blockPaint);
          final innerRect = rect.deflate(min(cellW, cellH) * 0.22);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              innerRect,
              Radius.circular(min(cellW, cellH) * 0.12),
            ),
            Paint()..color = colorScheme.onSurface.withValues(alpha: 0.16),
          );
        } else {
          final visited = visitedSet.contains(cell);
          final tilePaint = Paint()
            ..color = visited
                ? (isSolved
                    ? colorScheme.primaryContainer
                    : colorScheme.primary.withValues(alpha: 0.16))
                : colorScheme.surfaceContainerHighest;
          canvas.drawRRect(rrect, tilePaint);

          final borderPaint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2
            ..color = visited
                ? colorScheme.primary.withValues(alpha: 0.55)
                : colorScheme.outlineVariant;
          canvas.drawRRect(rrect, borderPaint);
        }
      }
    }

    // Draw continuous woven ribbon along the path
    if (path.isNotEmpty) {
      final strokeWidth = min(cellW, cellH) * 0.34;
      final linePaint = Paint()
        ..color = colorScheme.primary
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (path.length == 1) {
        final center = _centerOf(path.first, cellW, cellH);
        canvas.drawCircle(
          center,
          strokeWidth * 0.65,
          Paint()..color = colorScheme.primary,
        );
      } else {
        final ribbon = Path();
        final first = _centerOf(path.first, cellW, cellH);
        ribbon.moveTo(first.dx, first.dy);
        for (var i = 1; i < path.length; i++) {
          final pt = _centerOf(path[i], cellW, cellH);
          ribbon.lineTo(pt.dx, pt.dy);
        }
        canvas.drawPath(ribbon, linePaint);
      }

      // Start marker
      final startCenter = _centerOf(path.first, cellW, cellH);
      canvas.drawCircle(
        startCenter,
        min(cellW, cellH) * 0.22,
        Paint()..color = colorScheme.primary,
      );
      canvas.drawCircle(
        startCenter,
        min(cellW, cellH) * 0.09,
        Paint()..color = colorScheme.onPrimary,
      );

      // Head marker
      final headCenter = _centerOf(path.last, cellW, cellH);
      canvas.drawCircle(
        headCenter,
        min(cellW, cellH) * 0.24,
        Paint()..color = colorScheme.primary,
      );
      canvas.drawCircle(
        headCenter,
        min(cellW, cellH) * 0.12,
        Paint()..color = colorScheme.onPrimary,
      );
    }

    // Draw checkpoint anchor badge
    if (level.checkpointCell != null && level.checkpointStep != null) {
      final cpCenter = _centerOf(level.checkpointCell!, cellW, cellH);
      final cpVisited = visitedSet.contains(level.checkpointCell!);
      final badgeRadius = min(cellW, cellH) * 0.23;
      canvas.drawCircle(
        cpCenter,
        badgeRadius,
        Paint()
          ..color =
              cpVisited ? colorScheme.primary : colorScheme.tertiaryContainer,
      );
      _drawCenteredText(
        canvas,
        '#${level.checkpointStep}',
        cpCenter,
        textStyle.copyWith(
          fontSize: min(cellW, cellH) * 0.22,
          fontWeight: FontWeight.w800,
          color: cpVisited
              ? colorScheme.onPrimary
              : colorScheme.onTertiaryContainer,
        ),
      );
    }

    // Optional step numbers
    if (showStepNumbers) {
      for (var i = 0; i < path.length; i++) {
        final cell = path[i];
        if (cell == level.checkpointCell) continue;
        final center = _centerOf(cell, cellW, cellH);
        _drawCenteredText(
          canvas,
          '${i + 1}',
          center,
          textStyle.copyWith(
            fontSize: min(cellW, cellH) * 0.2,
            fontWeight: FontWeight.w800,
            color: colorScheme.onPrimary,
          ),
        );
      }
    }
  }

  Offset _centerOf(GridCell cell, double cellW, double cellH) {
    return Offset((cell.col + 0.5) * cellW, (cell.row + 0.5) * cellH);
  }

  void _drawCenteredText(
    Canvas canvas,
    String label,
    Offset center,
    TextStyle style,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _WeaveBoardPainter oldDelegate) {
    return oldDelegate.path.length != path.length ||
        oldDelegate.isSolved != isSolved ||
        oldDelegate.showStepNumbers != showStepNumbers ||
        oldDelegate.level.id != level.id ||
        oldDelegate.colorScheme != colorScheme;
  }
}

class _ControlRow extends StatelessWidget {
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onRestart;
  final VoidCallback onHint;

  const _ControlRow({
    required this.canUndo,
    required this.onUndo,
    required this.onRestart,
    required this.onHint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: canUndo ? onUndo : null,
            icon: const Icon(Icons.undo_rounded, size: 18),
            label: const Text('Undo'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reset'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.tonalIcon(
            onPressed: onHint,
            icon: const Icon(Icons.lightbulb_outline_rounded, size: 18),
            label: const Text('Hint'),
          ),
        ),
      ],
    );
  }
}

class _SolvedBanner extends StatelessWidget {
  final GameViewModel vm;
  final VoidCallback onNextLevel;

  const _SolvedBanner({
    required this.vm,
    required this.onNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLast =
        vm.level.isDaily || vm.level.id >= PuzzleLevels.campaign.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Icon(
                  index < vm.earnedStars
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 28,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            vm.level.isDaily ? 'Daily Weave Complete!' : 'Pattern Complete!',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Solved in ${vm.elapsedSeconds}s · ${vm.hintsUsed} hints used',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onNextLevel,
              icon: Icon(
                isLast
                    ? Icons.check_circle_outline_rounded
                    : Icons.arrow_forward_rounded,
              ),
              label: Text(isLast ? 'Back to Chapters' : 'Next Puzzle'),
            ),
          ),
        ],
      ),
    );
  }
}
