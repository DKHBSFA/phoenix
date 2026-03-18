import 'package:flutter/material.dart';

import '../../../app/design_tokens.dart';
import '../../../core/database/tables.dart';

class StatsGrid extends StatelessWidget {
  final int sets;
  final String repsLabel;
  final int tempoEcc;
  final int tempoCon;
  final String equipment;

  const StatsGrid({
    super.key,
    required this.sets,
    required this.repsLabel,
    required this.tempoEcc,
    required this.tempoCon,
    required this.equipment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor =
        isDark ? PhoenixColors.darkTextTertiary : PhoenixColors.lightTextTertiary;
    final valueColor =
        isDark ? PhoenixColors.darkTextPrimary : PhoenixColors.lightTextPrimary;
    final dividerColor =
        isDark ? PhoenixColors.darkBorder : PhoenixColors.lightBorder;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: dividerColor),
          bottom: BorderSide(color: dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatCell(
              value: '$sets × $repsLabel',
              label: 'Sets',
              valueColor: valueColor,
              labelColor: labelColor,
            ),
          ),
          Container(width: 1, height: 36, color: dividerColor),
          Expanded(
            child: _StatCell(
              value: '${tempoEcc}s / ${tempoCon}s',
              label: 'Tempo',
              valueColor: valueColor,
              labelColor: labelColor,
            ),
          ),
          Container(width: 1, height: 36, color: dividerColor),
          Expanded(
            child: _StatCell(
              value: _equipmentLabel(equipment),
              label: 'Equip',
              valueColor: valueColor,
              labelColor: labelColor,
            ),
          ),
        ],
      ),
    );
  }

  String _equipmentLabel(String eq) {
    switch (eq) {
      case Equipment.gym:
        return 'Palestra';
      case Equipment.home:
        return 'Casa';
      case Equipment.bodyweight:
        return 'Corpo';
      case Equipment.all:
        return 'Tutti';
      default:
        return eq;
    }
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color labelColor;

  const _StatCell({
    required this.value,
    required this.label,
    required this.valueColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}
