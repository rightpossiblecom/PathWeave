import 'dart:math';

class GridCell {
  final int row;
  final int col;
  const GridCell(this.row, this.col);

  bool isAdjacentTo(GridCell other) {
    return (row - other.row).abs() + (col - other.col).abs() == 1;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GridCell && other.row == row && other.col == col);

  @override
  int get hashCode => Object.hash(row, col);
}

class PuzzleLevel {
  final int id;
  final String chapter;
  final String title;
  final int rows;
  final int cols;
  final List<GridCell> blocks;
  final List<GridCell> solution;
  final int? checkpointStep;
  final GridCell? checkpointCell;
  final bool isDaily;
  final String? dailyDateKey;

  const PuzzleLevel({
    required this.id,
    required this.chapter,
    required this.title,
    required this.rows,
    required this.cols,
    required this.blocks,
    required this.solution,
    this.checkpointStep,
    this.checkpointCell,
    this.isDaily = false,
    this.dailyDateKey,
  });

  GridCell get startCell => solution.first;
  int get openCount => rows * cols - blocks.length;
  bool isBlocked(GridCell cell) => blocks.contains(cell);
}

class PuzzleLevels {
  static const List<String> chapters = ['Breeze', 'Weave', 'Labyrinth', 'Mastery'];

  static const List<PuzzleLevel> campaign = [
    PuzzleLevel(
      id: 1,
      chapter: 'Breeze',
      title: 'Stepping Stones',
      rows: 4,
      cols: 4,
      blocks: [GridCell(0, 0), GridCell(3, 0)],
      solution: [GridCell(0, 1), GridCell(1, 1), GridCell(1, 0), GridCell(2, 0), GridCell(2, 1), GridCell(3, 1), GridCell(3, 2), GridCell(2, 2), GridCell(1, 2), GridCell(0, 2), GridCell(0, 3), GridCell(1, 3), GridCell(2, 3), GridCell(3, 3)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 2,
      chapter: 'Breeze',
      title: 'Quiet Corner',
      rows: 4,
      cols: 4,
      blocks: [GridCell(0, 0), GridCell(3, 0), GridCell(3, 3)],
      solution: [GridCell(3, 2), GridCell(3, 1), GridCell(2, 1), GridCell(2, 0), GridCell(1, 0), GridCell(1, 1), GridCell(0, 1), GridCell(0, 2), GridCell(1, 2), GridCell(2, 2), GridCell(2, 3), GridCell(1, 3), GridCell(0, 3)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 3,
      chapter: 'Breeze',
      title: 'Twin Pillars',
      rows: 4,
      cols: 4,
      blocks: [GridCell(2, 0), GridCell(3, 0)],
      solution: [GridCell(3, 2), GridCell(3, 1), GridCell(2, 1), GridCell(1, 1), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3), GridCell(1, 3), GridCell(1, 2), GridCell(2, 2), GridCell(2, 3), GridCell(3, 3)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 4,
      chapter: 'Breeze',
      title: 'Garden Gate',
      rows: 4,
      cols: 4,
      blocks: [GridCell(0, 3), GridCell(2, 3), GridCell(3, 3)],
      solution: [GridCell(1, 3), GridCell(1, 2), GridCell(2, 2), GridCell(3, 2), GridCell(3, 1), GridCell(3, 0), GridCell(2, 0), GridCell(2, 1), GridCell(1, 1), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(0, 2)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 5,
      chapter: 'Breeze',
      title: 'Courtyard',
      rows: 4,
      cols: 4,
      blocks: [GridCell(0, 3), GridCell(2, 0), GridCell(2, 1), GridCell(3, 3)],
      solution: [GridCell(0, 0), GridCell(1, 0), GridCell(1, 1), GridCell(0, 1), GridCell(0, 2), GridCell(1, 2), GridCell(1, 3), GridCell(2, 3), GridCell(2, 2), GridCell(3, 2), GridCell(3, 1), GridCell(3, 0)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 6,
      chapter: 'Breeze',
      title: 'Lantern Walk',
      rows: 5,
      cols: 4,
      blocks: [GridCell(0, 0), GridCell(3, 0), GridCell(4, 0)],
      solution: [GridCell(1, 2), GridCell(1, 3), GridCell(2, 3), GridCell(2, 2), GridCell(3, 2), GridCell(3, 3), GridCell(4, 3), GridCell(4, 2), GridCell(4, 1), GridCell(3, 1), GridCell(2, 1), GridCell(2, 0), GridCell(1, 0), GridCell(1, 1), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 7,
      chapter: 'Breeze',
      title: 'Mossy Path',
      rows: 5,
      cols: 4,
      blocks: [GridCell(0, 0), GridCell(1, 0), GridCell(1, 1), GridCell(3, 2)],
      solution: [GridCell(4, 0), GridCell(3, 0), GridCell(2, 0), GridCell(2, 1), GridCell(3, 1), GridCell(4, 1), GridCell(4, 2), GridCell(4, 3), GridCell(3, 3), GridCell(2, 3), GridCell(2, 2), GridCell(1, 2), GridCell(1, 3), GridCell(0, 3), GridCell(0, 2), GridCell(0, 1)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 8,
      chapter: 'Breeze',
      title: 'Cedar Bridge',
      rows: 5,
      cols: 4,
      blocks: [GridCell(0, 2), GridCell(0, 3), GridCell(4, 2)],
      solution: [GridCell(4, 3), GridCell(3, 3), GridCell(3, 2), GridCell(2, 2), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(1, 1), GridCell(2, 1), GridCell(3, 1), GridCell(4, 1), GridCell(4, 0), GridCell(3, 0), GridCell(2, 0), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 9,
      chapter: 'Breeze',
      title: 'Pebble Turn',
      rows: 5,
      cols: 4,
      blocks: [GridCell(0, 0), GridCell(3, 0), GridCell(4, 2), GridCell(4, 3)],
      solution: [GridCell(4, 0), GridCell(4, 1), GridCell(3, 1), GridCell(3, 2), GridCell(3, 3), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(2, 2), GridCell(2, 1), GridCell(2, 0), GridCell(1, 0), GridCell(1, 1), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 10,
      chapter: 'Breeze',
      title: 'Morning Loom',
      rows: 5,
      cols: 4,
      blocks: [GridCell(3, 0), GridCell(4, 0), GridCell(4, 1), GridCell(4, 2), GridCell(4, 3)],
      solution: [GridCell(2, 2), GridCell(2, 3), GridCell(1, 3), GridCell(0, 3), GridCell(0, 2), GridCell(1, 2), GridCell(1, 1), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(2, 1), GridCell(3, 1), GridCell(3, 2), GridCell(3, 3)],
      checkpointStep: null,
      checkpointCell: null,
    ),
    PuzzleLevel(
      id: 11,
      chapter: 'Weave',
      title: 'Crosswind',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 0), GridCell(4, 0), GridCell(4, 1)],
      solution: [GridCell(1, 0), GridCell(2, 0), GridCell(3, 0), GridCell(3, 1), GridCell(2, 1), GridCell(2, 2), GridCell(3, 2), GridCell(4, 2), GridCell(4, 3), GridCell(4, 4), GridCell(3, 4), GridCell(2, 4), GridCell(1, 4), GridCell(0, 4), GridCell(0, 3), GridCell(0, 2), GridCell(0, 1), GridCell(1, 1), GridCell(1, 2), GridCell(1, 3), GridCell(2, 3), GridCell(3, 3)],
      checkpointStep: 12,
      checkpointCell: GridCell(2, 4),
    ),
    PuzzleLevel(
      id: 12,
      chapter: 'Weave',
      title: 'Silk Thread',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 3), GridCell(0, 4), GridCell(1, 3), GridCell(1, 4)],
      solution: [GridCell(4, 4), GridCell(3, 4), GridCell(2, 4), GridCell(2, 3), GridCell(2, 2), GridCell(2, 1), GridCell(1, 1), GridCell(1, 2), GridCell(0, 2), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(3, 0), GridCell(4, 0), GridCell(4, 1), GridCell(3, 1), GridCell(3, 2), GridCell(3, 3), GridCell(4, 3), GridCell(4, 2)],
      checkpointStep: 11,
      checkpointCell: GridCell(0, 0),
    ),
    PuzzleLevel(
      id: 13,
      chapter: 'Weave',
      title: 'Bamboo Arch',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 0), GridCell(0, 1), GridCell(1, 1), GridCell(3, 1)],
      solution: [GridCell(1, 0), GridCell(2, 0), GridCell(2, 1), GridCell(2, 2), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(1, 4), GridCell(2, 4), GridCell(3, 4), GridCell(4, 4), GridCell(4, 3), GridCell(3, 3), GridCell(3, 2), GridCell(4, 2), GridCell(4, 1), GridCell(4, 0), GridCell(3, 0)],
      checkpointStep: 11,
      checkpointCell: GridCell(1, 4),
    ),
    PuzzleLevel(
      id: 14,
      chapter: 'Weave',
      title: 'Four Corners',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 0), GridCell(0, 3), GridCell(1, 0), GridCell(3, 3), GridCell(4, 0)],
      solution: [GridCell(0, 4), GridCell(1, 4), GridCell(2, 4), GridCell(3, 4), GridCell(4, 4), GridCell(4, 3), GridCell(4, 2), GridCell(3, 2), GridCell(2, 2), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(0, 2), GridCell(0, 1), GridCell(1, 1), GridCell(2, 1), GridCell(2, 0), GridCell(3, 0), GridCell(3, 1), GridCell(4, 1)],
      checkpointStep: 11,
      checkpointCell: GridCell(1, 3),
    ),
    PuzzleLevel(
      id: 15,
      chapter: 'Weave',
      title: 'Spiral Echo',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 2), GridCell(0, 3), GridCell(4, 0), GridCell(4, 1)],
      solution: [GridCell(3, 3), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(1, 1), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(3, 0), GridCell(3, 1), GridCell(2, 1), GridCell(2, 2), GridCell(3, 2), GridCell(4, 2), GridCell(4, 3), GridCell(4, 4), GridCell(3, 4), GridCell(2, 4), GridCell(1, 4), GridCell(0, 4)],
      checkpointStep: 11,
      checkpointCell: GridCell(3, 1),
    ),
    PuzzleLevel(
      id: 16,
      chapter: 'Weave',
      title: 'Stone Pond',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 4), GridCell(1, 4), GridCell(4, 0), GridCell(4, 1), GridCell(4, 2)],
      solution: [GridCell(2, 4), GridCell(3, 4), GridCell(4, 4), GridCell(4, 3), GridCell(3, 3), GridCell(3, 2), GridCell(3, 1), GridCell(2, 1), GridCell(2, 2), GridCell(2, 3), GridCell(1, 3), GridCell(0, 3), GridCell(0, 2), GridCell(1, 2), GridCell(1, 1), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(3, 0)],
      checkpointStep: 11,
      checkpointCell: GridCell(1, 3),
    ),
    PuzzleLevel(
      id: 17,
      chapter: 'Weave',
      title: 'Narrow Pass',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 4), GridCell(2, 3), GridCell(3, 0), GridCell(3, 1), GridCell(3, 2), GridCell(4, 4)],
      solution: [GridCell(4, 0), GridCell(4, 1), GridCell(4, 2), GridCell(4, 3), GridCell(3, 3), GridCell(3, 4), GridCell(2, 4), GridCell(1, 4), GridCell(1, 3), GridCell(0, 3), GridCell(0, 2), GridCell(1, 2), GridCell(2, 2), GridCell(2, 1), GridCell(1, 1), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0)],
      checkpointStep: 10,
      checkpointCell: GridCell(0, 3),
    ),
    PuzzleLevel(
      id: 18,
      chapter: 'Weave',
      title: 'Woven Reed',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 3), GridCell(0, 4), GridCell(1, 3), GridCell(1, 4), GridCell(2, 4)],
      solution: [GridCell(0, 0), GridCell(0, 1), GridCell(0, 2), GridCell(1, 2), GridCell(2, 2), GridCell(2, 3), GridCell(3, 3), GridCell(3, 4), GridCell(4, 4), GridCell(4, 3), GridCell(4, 2), GridCell(4, 1), GridCell(4, 0), GridCell(3, 0), GridCell(2, 0), GridCell(1, 0), GridCell(1, 1), GridCell(2, 1), GridCell(3, 1), GridCell(3, 2)],
      checkpointStep: 11,
      checkpointCell: GridCell(4, 2),
    ),
    PuzzleLevel(
      id: 19,
      chapter: 'Weave',
      title: 'Still Water',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 0), GridCell(3, 2), GridCell(4, 0), GridCell(4, 1), GridCell(4, 2), GridCell(4, 4)],
      solution: [GridCell(4, 3), GridCell(3, 3), GridCell(2, 3), GridCell(2, 2), GridCell(2, 1), GridCell(3, 1), GridCell(3, 0), GridCell(2, 0), GridCell(1, 0), GridCell(1, 1), GridCell(0, 1), GridCell(0, 2), GridCell(1, 2), GridCell(1, 3), GridCell(0, 3), GridCell(0, 4), GridCell(1, 4), GridCell(2, 4), GridCell(3, 4)],
      checkpointStep: 10,
      checkpointCell: GridCell(1, 1),
    ),
    PuzzleLevel(
      id: 20,
      chapter: 'Weave',
      title: 'Tapestry',
      rows: 5,
      cols: 5,
      blocks: [GridCell(0, 0), GridCell(0, 1), GridCell(1, 0), GridCell(1, 1)],
      solution: [GridCell(3, 1), GridCell(3, 2), GridCell(3, 3), GridCell(4, 3), GridCell(4, 2), GridCell(4, 1), GridCell(4, 0), GridCell(3, 0), GridCell(2, 0), GridCell(2, 1), GridCell(2, 2), GridCell(1, 2), GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(1, 4), GridCell(1, 3), GridCell(2, 3), GridCell(2, 4), GridCell(3, 4), GridCell(4, 4)],
      checkpointStep: 11,
      checkpointCell: GridCell(2, 2),
    ),
    PuzzleLevel(
      id: 21,
      chapter: 'Labyrinth',
      title: 'Terrace',
      rows: 6,
      cols: 5,
      blocks: [GridCell(0, 2), GridCell(4, 0), GridCell(5, 0), GridCell(5, 4)],
      solution: [GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(1, 1), GridCell(1, 2), GridCell(2, 2), GridCell(2, 1), GridCell(2, 0), GridCell(3, 0), GridCell(3, 1), GridCell(3, 2), GridCell(4, 2), GridCell(4, 1), GridCell(5, 1), GridCell(5, 2), GridCell(5, 3), GridCell(4, 3), GridCell(3, 3), GridCell(2, 3), GridCell(1, 3), GridCell(0, 3), GridCell(0, 4), GridCell(1, 4), GridCell(2, 4), GridCell(3, 4), GridCell(4, 4)],
      checkpointStep: 14,
      checkpointCell: GridCell(5, 1),
    ),
    PuzzleLevel(
      id: 22,
      chapter: 'Labyrinth',
      title: 'Hidden Alcove',
      rows: 6,
      cols: 5,
      blocks: [GridCell(1, 2), GridCell(1, 3), GridCell(2, 0), GridCell(3, 0), GridCell(4, 0)],
      solution: [GridCell(5, 0), GridCell(5, 1), GridCell(4, 1), GridCell(3, 1), GridCell(3, 2), GridCell(2, 2), GridCell(2, 1), GridCell(1, 1), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(1, 4), GridCell(2, 4), GridCell(2, 3), GridCell(3, 3), GridCell(3, 4), GridCell(4, 4), GridCell(4, 3), GridCell(4, 2), GridCell(5, 2), GridCell(5, 3), GridCell(5, 4)],
      checkpointStep: 13,
      checkpointCell: GridCell(0, 3),
    ),
    PuzzleLevel(
      id: 23,
      chapter: 'Labyrinth',
      title: 'Sunken Steps',
      rows: 6,
      cols: 5,
      blocks: [GridCell(0, 4), GridCell(1, 1), GridCell(1, 2), GridCell(1, 4), GridCell(2, 4), GridCell(4, 3)],
      solution: [GridCell(3, 2), GridCell(3, 1), GridCell(3, 0), GridCell(4, 0), GridCell(5, 0), GridCell(5, 1), GridCell(4, 1), GridCell(4, 2), GridCell(5, 2), GridCell(5, 3), GridCell(5, 4), GridCell(4, 4), GridCell(3, 4), GridCell(3, 3), GridCell(2, 3), GridCell(1, 3), GridCell(0, 3), GridCell(0, 2), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(2, 1), GridCell(2, 2)],
      checkpointStep: 13,
      checkpointCell: GridCell(3, 4),
    ),
    PuzzleLevel(
      id: 24,
      chapter: 'Labyrinth',
      title: 'Amber Trail',
      rows: 6,
      cols: 5,
      blocks: [GridCell(0, 0), GridCell(0, 4), GridCell(1, 0), GridCell(3, 1), GridCell(5, 0)],
      solution: [GridCell(2, 1), GridCell(2, 0), GridCell(3, 0), GridCell(4, 0), GridCell(4, 1), GridCell(5, 1), GridCell(5, 2), GridCell(4, 2), GridCell(3, 2), GridCell(2, 2), GridCell(1, 2), GridCell(1, 1), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3), GridCell(1, 3), GridCell(2, 3), GridCell(3, 3), GridCell(4, 3), GridCell(5, 3), GridCell(5, 4), GridCell(4, 4), GridCell(3, 4), GridCell(2, 4), GridCell(1, 4)],
      checkpointStep: 13,
      checkpointCell: GridCell(0, 1),
    ),
    PuzzleLevel(
      id: 25,
      chapter: 'Labyrinth',
      title: 'Split Ridge',
      rows: 6,
      cols: 5,
      blocks: [GridCell(0, 0), GridCell(0, 4), GridCell(1, 0), GridCell(1, 2), GridCell(1, 4), GridCell(3, 1)],
      solution: [GridCell(4, 3), GridCell(3, 3), GridCell(3, 2), GridCell(2, 2), GridCell(2, 3), GridCell(2, 4), GridCell(3, 4), GridCell(4, 4), GridCell(5, 4), GridCell(5, 3), GridCell(5, 2), GridCell(4, 2), GridCell(4, 1), GridCell(5, 1), GridCell(5, 0), GridCell(4, 0), GridCell(3, 0), GridCell(2, 0), GridCell(2, 1), GridCell(1, 1), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3), GridCell(1, 3)],
      checkpointStep: 13,
      checkpointCell: GridCell(4, 1),
    ),
    PuzzleLevel(
      id: 26,
      chapter: 'Labyrinth',
      title: 'Cloister',
      rows: 6,
      cols: 6,
      blocks: [GridCell(0, 2), GridCell(1, 2), GridCell(2, 3), GridCell(4, 3), GridCell(5, 5)],
      solution: [GridCell(1, 1), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(2, 1), GridCell(2, 2), GridCell(3, 2), GridCell(3, 3), GridCell(3, 4), GridCell(2, 4), GridCell(1, 4), GridCell(1, 3), GridCell(0, 3), GridCell(0, 4), GridCell(0, 5), GridCell(1, 5), GridCell(2, 5), GridCell(3, 5), GridCell(4, 5), GridCell(4, 4), GridCell(5, 4), GridCell(5, 3), GridCell(5, 2), GridCell(5, 1), GridCell(5, 0), GridCell(4, 0), GridCell(3, 0), GridCell(3, 1), GridCell(4, 1), GridCell(4, 2)],
      checkpointStep: 16,
      checkpointCell: GridCell(0, 5),
    ),
    PuzzleLevel(
      id: 27,
      chapter: 'Labyrinth',
      title: 'Shadow Wall',
      rows: 6,
      cols: 6,
      blocks: [GridCell(0, 0), GridCell(1, 2), GridCell(1, 3), GridCell(2, 2), GridCell(2, 3), GridCell(3, 2)],
      solution: [GridCell(4, 4), GridCell(3, 4), GridCell(3, 3), GridCell(4, 3), GridCell(4, 2), GridCell(5, 2), GridCell(5, 3), GridCell(5, 4), GridCell(5, 5), GridCell(4, 5), GridCell(3, 5), GridCell(2, 5), GridCell(2, 4), GridCell(1, 4), GridCell(1, 5), GridCell(0, 5), GridCell(0, 4), GridCell(0, 3), GridCell(0, 2), GridCell(0, 1), GridCell(1, 1), GridCell(1, 0), GridCell(2, 0), GridCell(2, 1), GridCell(3, 1), GridCell(3, 0), GridCell(4, 0), GridCell(4, 1), GridCell(5, 1), GridCell(5, 0)],
      checkpointStep: 16,
      checkpointCell: GridCell(0, 5),
    ),
    PuzzleLevel(
      id: 28,
      chapter: 'Labyrinth',
      title: 'Deep Weave',
      rows: 6,
      cols: 6,
      blocks: [GridCell(0, 0), GridCell(0, 5), GridCell(1, 0), GridCell(3, 2), GridCell(3, 3), GridCell(4, 2), GridCell(4, 3)],
      solution: [GridCell(4, 4), GridCell(3, 4), GridCell(2, 4), GridCell(1, 4), GridCell(1, 5), GridCell(2, 5), GridCell(3, 5), GridCell(4, 5), GridCell(5, 5), GridCell(5, 4), GridCell(5, 3), GridCell(5, 2), GridCell(5, 1), GridCell(5, 0), GridCell(4, 0), GridCell(4, 1), GridCell(3, 1), GridCell(3, 0), GridCell(2, 0), GridCell(2, 1), GridCell(2, 2), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(1, 1), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3), GridCell(0, 4)],
      checkpointStep: 15,
      checkpointCell: GridCell(4, 0),
    ),
    PuzzleLevel(
      id: 29,
      chapter: 'Labyrinth',
      title: 'Jade Lattice',
      rows: 6,
      cols: 6,
      blocks: [GridCell(0, 5), GridCell(2, 0), GridCell(3, 0), GridCell(3, 5), GridCell(5, 1), GridCell(5, 2)],
      solution: [GridCell(5, 0), GridCell(4, 0), GridCell(4, 1), GridCell(4, 2), GridCell(4, 3), GridCell(3, 3), GridCell(3, 2), GridCell(3, 1), GridCell(2, 1), GridCell(2, 2), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(1, 1), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(1, 4), GridCell(1, 5), GridCell(2, 5), GridCell(2, 4), GridCell(3, 4), GridCell(4, 4), GridCell(4, 5), GridCell(5, 5), GridCell(5, 4), GridCell(5, 3)],
      checkpointStep: 16,
      checkpointCell: GridCell(0, 0),
    ),
    PuzzleLevel(
      id: 30,
      chapter: 'Labyrinth',
      title: 'Sanctuary',
      rows: 6,
      cols: 6,
      blocks: [GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(0, 5), GridCell(2, 2), GridCell(5, 4), GridCell(5, 5)],
      solution: [GridCell(4, 5), GridCell(3, 5), GridCell(2, 5), GridCell(1, 5), GridCell(1, 4), GridCell(2, 4), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(1, 1), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(2, 1), GridCell(3, 1), GridCell(4, 1), GridCell(4, 2), GridCell(3, 2), GridCell(3, 3), GridCell(3, 4), GridCell(4, 4), GridCell(4, 3), GridCell(5, 3), GridCell(5, 2), GridCell(5, 1), GridCell(5, 0), GridCell(4, 0), GridCell(3, 0)],
      checkpointStep: 15,
      checkpointCell: GridCell(2, 1),
    ),
    PuzzleLevel(
      id: 31,
      chapter: 'Mastery',
      title: 'Mirage',
      rows: 6,
      cols: 6,
      blocks: [GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(2, 2), GridCell(5, 2)],
      solution: [GridCell(1, 2), GridCell(1, 3), GridCell(1, 4), GridCell(0, 4), GridCell(0, 3), GridCell(0, 2), GridCell(0, 1), GridCell(1, 1), GridCell(2, 1), GridCell(3, 1), GridCell(3, 0), GridCell(4, 0), GridCell(5, 0), GridCell(5, 1), GridCell(4, 1), GridCell(4, 2), GridCell(3, 2), GridCell(3, 3), GridCell(2, 3), GridCell(2, 4), GridCell(3, 4), GridCell(4, 4), GridCell(4, 3), GridCell(5, 3), GridCell(5, 4), GridCell(5, 5), GridCell(4, 5), GridCell(3, 5), GridCell(2, 5), GridCell(1, 5), GridCell(0, 5)],
      checkpointStep: 16,
      checkpointCell: GridCell(4, 2),
    ),
    PuzzleLevel(
      id: 32,
      chapter: 'Mastery',
      title: 'Obsidian',
      rows: 6,
      cols: 6,
      blocks: [GridCell(1, 1), GridCell(3, 2), GridCell(4, 2), GridCell(4, 3), GridCell(5, 2), GridCell(5, 3)],
      solution: [GridCell(4, 4), GridCell(5, 4), GridCell(5, 5), GridCell(4, 5), GridCell(3, 5), GridCell(3, 4), GridCell(3, 3), GridCell(2, 3), GridCell(2, 2), GridCell(2, 1), GridCell(3, 1), GridCell(4, 1), GridCell(5, 1), GridCell(5, 0), GridCell(4, 0), GridCell(3, 0), GridCell(2, 0), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(0, 2), GridCell(1, 2), GridCell(1, 3), GridCell(0, 3), GridCell(0, 4), GridCell(0, 5), GridCell(1, 5), GridCell(2, 5), GridCell(2, 4), GridCell(1, 4)],
      checkpointStep: 16,
      checkpointCell: GridCell(3, 0),
    ),
    PuzzleLevel(
      id: 33,
      chapter: 'Mastery',
      title: 'Skyline',
      rows: 6,
      cols: 6,
      blocks: [GridCell(0, 5), GridCell(3, 0), GridCell(3, 5), GridCell(4, 0), GridCell(4, 3), GridCell(5, 0), GridCell(5, 1)],
      solution: [GridCell(1, 5), GridCell(2, 5), GridCell(2, 4), GridCell(2, 3), GridCell(3, 3), GridCell(3, 4), GridCell(4, 4), GridCell(4, 5), GridCell(5, 5), GridCell(5, 4), GridCell(5, 3), GridCell(5, 2), GridCell(4, 2), GridCell(4, 1), GridCell(3, 1), GridCell(3, 2), GridCell(2, 2), GridCell(1, 2), GridCell(1, 1), GridCell(2, 1), GridCell(2, 0), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3), GridCell(1, 3), GridCell(1, 4), GridCell(0, 4)],
      checkpointStep: 15,
      checkpointCell: GridCell(3, 1),
    ),
    PuzzleLevel(
      id: 34,
      chapter: 'Mastery',
      title: 'Long Gallery',
      rows: 7,
      cols: 6,
      blocks: [GridCell(0, 4), GridCell(0, 5), GridCell(1, 4), GridCell(1, 5), GridCell(3, 1), GridCell(3, 4)],
      solution: [GridCell(4, 2), GridCell(4, 3), GridCell(4, 4), GridCell(5, 4), GridCell(6, 4), GridCell(6, 5), GridCell(5, 5), GridCell(4, 5), GridCell(3, 5), GridCell(2, 5), GridCell(2, 4), GridCell(2, 3), GridCell(3, 3), GridCell(3, 2), GridCell(2, 2), GridCell(1, 2), GridCell(1, 3), GridCell(0, 3), GridCell(0, 2), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(1, 1), GridCell(2, 1), GridCell(2, 0), GridCell(3, 0), GridCell(4, 0), GridCell(4, 1), GridCell(5, 1), GridCell(5, 0), GridCell(6, 0), GridCell(6, 1), GridCell(6, 2), GridCell(5, 2), GridCell(5, 3), GridCell(6, 3)],
      checkpointStep: 19,
      checkpointCell: GridCell(0, 2),
    ),
    PuzzleLevel(
      id: 35,
      chapter: 'Mastery',
      title: 'Citadel',
      rows: 7,
      cols: 6,
      blocks: [GridCell(0, 0), GridCell(1, 0), GridCell(3, 2), GridCell(4, 0), GridCell(5, 0), GridCell(6, 0), GridCell(6, 5)],
      solution: [GridCell(1, 5), GridCell(0, 5), GridCell(0, 4), GridCell(0, 3), GridCell(0, 2), GridCell(0, 1), GridCell(1, 1), GridCell(1, 2), GridCell(2, 2), GridCell(2, 1), GridCell(2, 0), GridCell(3, 0), GridCell(3, 1), GridCell(4, 1), GridCell(4, 2), GridCell(4, 3), GridCell(5, 3), GridCell(5, 2), GridCell(5, 1), GridCell(6, 1), GridCell(6, 2), GridCell(6, 3), GridCell(6, 4), GridCell(5, 4), GridCell(4, 4), GridCell(3, 4), GridCell(3, 3), GridCell(2, 3), GridCell(1, 3), GridCell(1, 4), GridCell(2, 4), GridCell(2, 5), GridCell(3, 5), GridCell(4, 5), GridCell(5, 5)],
      checkpointStep: 18,
      checkpointCell: GridCell(5, 2),
    ),
    PuzzleLevel(
      id: 36,
      chapter: 'Mastery',
      title: 'Monolith',
      rows: 7,
      cols: 6,
      blocks: [GridCell(0, 5), GridCell(1, 1), GridCell(1, 5), GridCell(2, 1), GridCell(2, 5), GridCell(5, 1), GridCell(5, 5), GridCell(6, 5)],
      solution: [GridCell(1, 3), GridCell(1, 2), GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(1, 4), GridCell(2, 4), GridCell(3, 4), GridCell(3, 5), GridCell(4, 5), GridCell(4, 4), GridCell(4, 3), GridCell(3, 3), GridCell(2, 3), GridCell(2, 2), GridCell(3, 2), GridCell(3, 1), GridCell(4, 1), GridCell(4, 2), GridCell(5, 2), GridCell(5, 3), GridCell(5, 4), GridCell(6, 4), GridCell(6, 3), GridCell(6, 2), GridCell(6, 1), GridCell(6, 0), GridCell(5, 0), GridCell(4, 0), GridCell(3, 0), GridCell(2, 0), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1)],
      checkpointStep: 18,
      checkpointCell: GridCell(4, 1),
    ),
    PuzzleLevel(
      id: 37,
      chapter: 'Mastery',
      title: 'Winding Spire',
      rows: 7,
      cols: 6,
      blocks: [GridCell(0, 5), GridCell(3, 0), GridCell(3, 1), GridCell(4, 0), GridCell(5, 0), GridCell(5, 2), GridCell(6, 0)],
      solution: [GridCell(5, 5), GridCell(6, 5), GridCell(6, 4), GridCell(6, 3), GridCell(6, 2), GridCell(6, 1), GridCell(5, 1), GridCell(4, 1), GridCell(4, 2), GridCell(3, 2), GridCell(2, 2), GridCell(1, 2), GridCell(1, 1), GridCell(2, 1), GridCell(2, 0), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(1, 4), GridCell(1, 3), GridCell(2, 3), GridCell(3, 3), GridCell(4, 3), GridCell(5, 3), GridCell(5, 4), GridCell(4, 4), GridCell(4, 5), GridCell(3, 5), GridCell(3, 4), GridCell(2, 4), GridCell(2, 5), GridCell(1, 5)],
      checkpointStep: 18,
      checkpointCell: GridCell(0, 1),
    ),
    PuzzleLevel(
      id: 38,
      chapter: 'Mastery',
      title: 'Silent Vault',
      rows: 7,
      cols: 6,
      blocks: [GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(0, 5), GridCell(1, 5), GridCell(2, 3), GridCell(2, 5), GridCell(3, 3)],
      solution: [GridCell(5, 2), GridCell(5, 1), GridCell(4, 1), GridCell(3, 1), GridCell(3, 2), GridCell(4, 2), GridCell(4, 3), GridCell(5, 3), GridCell(5, 4), GridCell(4, 4), GridCell(4, 5), GridCell(5, 5), GridCell(6, 5), GridCell(6, 4), GridCell(6, 3), GridCell(6, 2), GridCell(6, 1), GridCell(6, 0), GridCell(5, 0), GridCell(4, 0), GridCell(3, 0), GridCell(2, 0), GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(1, 1), GridCell(2, 1), GridCell(2, 2), GridCell(1, 2), GridCell(1, 3), GridCell(1, 4), GridCell(2, 4), GridCell(3, 4), GridCell(3, 5)],
      checkpointStep: 18,
      checkpointCell: GridCell(6, 0),
    ),
    PuzzleLevel(
      id: 39,
      chapter: 'Mastery',
      title: 'Horizon Knot',
      rows: 7,
      cols: 6,
      blocks: [GridCell(0, 2), GridCell(0, 3), GridCell(0, 4), GridCell(0, 5), GridCell(2, 2), GridCell(6, 0), GridCell(6, 1)],
      solution: [GridCell(6, 3), GridCell(6, 2), GridCell(5, 2), GridCell(5, 3), GridCell(5, 4), GridCell(6, 4), GridCell(6, 5), GridCell(5, 5), GridCell(4, 5), GridCell(4, 4), GridCell(3, 4), GridCell(3, 5), GridCell(2, 5), GridCell(1, 5), GridCell(1, 4), GridCell(2, 4), GridCell(2, 3), GridCell(1, 3), GridCell(1, 2), GridCell(1, 1), GridCell(0, 1), GridCell(0, 0), GridCell(1, 0), GridCell(2, 0), GridCell(3, 0), GridCell(4, 0), GridCell(5, 0), GridCell(5, 1), GridCell(4, 1), GridCell(4, 2), GridCell(4, 3), GridCell(3, 3), GridCell(3, 2), GridCell(3, 1), GridCell(2, 1)],
      checkpointStep: 18,
      checkpointCell: GridCell(1, 3),
    ),
    PuzzleLevel(
      id: 40,
      chapter: 'Mastery',
      title: 'Final Thread',
      rows: 7,
      cols: 6,
      blocks: [GridCell(1, 4), GridCell(2, 0), GridCell(4, 1), GridCell(5, 1), GridCell(5, 3), GridCell(6, 3)],
      solution: [GridCell(1, 0), GridCell(0, 0), GridCell(0, 1), GridCell(0, 2), GridCell(1, 2), GridCell(1, 1), GridCell(2, 1), GridCell(3, 1), GridCell(3, 0), GridCell(4, 0), GridCell(5, 0), GridCell(6, 0), GridCell(6, 1), GridCell(6, 2), GridCell(5, 2), GridCell(4, 2), GridCell(4, 3), GridCell(4, 4), GridCell(5, 4), GridCell(6, 4), GridCell(6, 5), GridCell(5, 5), GridCell(4, 5), GridCell(3, 5), GridCell(3, 4), GridCell(2, 4), GridCell(2, 5), GridCell(1, 5), GridCell(0, 5), GridCell(0, 4), GridCell(0, 3), GridCell(1, 3), GridCell(2, 3), GridCell(2, 2), GridCell(3, 2), GridCell(3, 3)],
      checkpointStep: 19,
      checkpointCell: GridCell(5, 4),
    ),
  ];

  static String todayKey([DateTime? date]) {
    final d = date ?? DateTime.now();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static PuzzleLevel dailyForDate([DateTime? date]) {
    final key = todayKey(date);
    var seed = 17;
    for (final code in key.codeUnits) {
      seed = (seed * 31 + code) & 0x7fffffff;
    }
    final rng = Random(seed);
    const rows = 6;
    const cols = 5;
    const targetLen = 25;
    while (true) {
      final start = GridCell(rng.nextInt(rows), rng.nextInt(cols));
      final path = <GridCell>[start];
      final visited = <GridCell>{start};
      var attempts = 0;
      bool walk() {
        if (path.length == targetLen) return true;
        attempts++;
        if (attempts > 500) return false;
        final curr = path.last;
        final dirs = <GridCell>[
          GridCell(curr.row - 1, curr.col),
          GridCell(curr.row + 1, curr.col),
          GridCell(curr.row, curr.col - 1),
          GridCell(curr.row, curr.col + 1),
        ].where((c) => c.row >= 0 && c.row < rows && c.col >= 0 && c.col < cols && !visited.contains(c)).toList();
        dirs.shuffle(rng);
        for (final nxt in dirs) {
          visited.add(nxt);
          path.add(nxt);
          if (walk()) return true;
          path.removeLast();
          visited.remove(nxt);
        }
        return false;
      }
      if (walk()) {
        final blocks = <GridCell>[];
        for (var r = 0; r < rows; r++) {
          for (var c = 0; c < cols; c++) {
            final cell = GridCell(r, c);
            if (!visited.contains(cell)) blocks.add(cell);
          }
        }
        final mid = path.length ~/ 2;
        return PuzzleLevel(
          id: 9000,
          chapter: 'Daily Weave',
          title: 'Daily Weave · $key',
          rows: rows,
          cols: cols,
          blocks: blocks,
          solution: path,
          checkpointStep: mid + 1,
          checkpointCell: path[mid],
          isDaily: true,
          dailyDateKey: key,
        );
      }
    }
  }
}
