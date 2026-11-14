import 'package:flutter_test/flutter_test.dart';
import 'package:pathweave/core/constants/puzzle_levels.dart';

void main() {
  test('All 40 campaign puzzle levels are valid Hamiltonian paths', () {
    expect(PuzzleLevels.campaign.length, 40);

    for (final level in PuzzleLevels.campaign) {
      expect(level.solution.length, level.openCount);
      expect(level.solution.toSet().length, level.openCount);

      for (final cell in level.solution) {
        expect(level.isBlocked(cell), isFalse);
        expect(cell.row >= 0 && cell.row < level.rows, isTrue);
        expect(cell.col >= 0 && cell.col < level.cols, isTrue);
      }

      for (var i = 1; i < level.solution.length; i++) {
        expect(level.solution[i - 1].isAdjacentTo(level.solution[i]), isTrue);
      }

      if (level.checkpointCell != null && level.checkpointStep != null) {
        expect(
          level.solution[level.checkpointStep! - 1],
          equals(level.checkpointCell),
        );
      }
    }
  });

  test('Daily puzzle generator produces deterministic valid board', () {
    final d1 = PuzzleLevels.dailyForDate(DateTime(2026, 11, 14));
    final d2 = PuzzleLevels.dailyForDate(DateTime(2026, 11, 14));
    expect(d1.solution, equals(d2.solution));
    expect(d1.solution.length, d1.openCount);
  });
}
