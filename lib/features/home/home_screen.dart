import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/puzzle_levels.dart';
import '../about/about_screen.dart';
import '../game/game_screen.dart';
import '../settings/settings_screen.dart';
import '../stats/stats_screen.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final titles = [AppConstants.appName, 'Progress', 'Settings'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_tabIndex]),
        actions: [
          if (_tabIndex == 0)
            IconButton(
              tooltip: 'About PathWeave',
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
              ),
            ),
        ],
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: const [
          _CampaignPlayTab(),
          StatsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (idx) => setState(() => _tabIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Puzzles',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _CampaignPlayTab extends StatelessWidget {
  const _CampaignPlayTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vm = context.watch<HomeViewModel>();
    final nextId = vm.nextPlayableLevelId;
    final nextLevel =
        PuzzleLevels.campaign.firstWhere((l) => l.id == nextId);
    final chapterLevels = vm.levelsForSelectedChapter;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        // Hero Continue Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      nextLevel.chapter.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${vm.totalStarsEarned} / ${vm.maxPossibleStars}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                'Level ${nextLevel.id}: ${nextLevel.title}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${nextLevel.rows}×${nextLevel.cols} weave · ${nextLevel.openCount} open tiles',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => GameScreen(initialLevel: nextLevel),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    vm.completed.isEmpty ? 'Start Weaving' : 'Continue Journey',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Daily Weave Card
        Card(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                vm.isTodayDailyDone
                    ? Icons.verified_rounded
                    : Icons.wb_sunny_outlined,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            title: Text(
              'Daily Weave · ${PuzzleLevels.todayKey()}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              vm.isTodayDailyDone
                  ? 'Completed today · ${vm.dailyStreak} day streak'
                  : 'Fresh 6×5 board generated for today',
            ),
            trailing: FilledButton.tonal(
              onPressed: () {
                final daily = PuzzleLevels.dailyForDate();
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => GameScreen(initialLevel: daily),
                  ),
                );
              },
              child: Text(vm.isTodayDailyDone ? 'Replay' : 'Play'),
            ),
          ),
        ),
        const SizedBox(height: 22),

        // Chapter Filter Chips
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: PuzzleLevels.chapters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final chapter = PuzzleLevels.chapters[index];
              final isSelected = chapter == vm.selectedChapter;
              return ChoiceChip(
                label: Text(chapter),
                selected: isSelected,
                onSelected: (_) => vm.selectChapter(chapter),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Level Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chapterLevels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) {
            final level = chapterLevels[index];
            final unlocked = vm.isUnlocked(level.id);
            final completed = vm.isCompleted(level.id);
            final stars = vm.starsForLevel(level.id);

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: unlocked
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => GameScreen(initialLevel: level),
                        ),
                      );
                    }
                  : null,
              child: Ink(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: unlocked
                      ? colorScheme.surfaceContainerLow
                      : colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: completed
                        ? colorScheme.primary.withValues(alpha: 0.5)
                        : colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: completed
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '#${level.id}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: completed
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (!unlocked)
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 18,
                            color: colorScheme.onSurfaceVariant,
                          )
                        else
                          Row(
                            children: List.generate(
                              3,
                              (s) => Icon(
                                s < stars
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 15,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: unlocked
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${level.rows}×${level.cols} · ${level.openCount} tiles',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
