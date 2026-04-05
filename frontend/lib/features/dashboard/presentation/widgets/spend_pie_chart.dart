import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/dashboard/domain/entities/chart_point_entity.dart';

class SpendPieChart extends StatelessWidget {
  const SpendPieChart({
    required this.points,
    super.key,
  });

  final List<ChartPointEntity> points;

  static const List<Color> _palette = <Color>[
    Color(0xFF0B6E6E),
    Color(0xFF2E8B8B),
    Color(0xFF3FA7A3),
    Color(0xFF57BFB9),
    Color(0xFF7AD2C5),
    Color(0xFF92D9A8),
    Color(0xFFFFB547),
    Color(0xFFFF9A5A),
  ];

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: Text('No category breakdown available yet'),
        ),
      );
    }

    final double total = points.fold<double>(
        0, (double sum, ChartPointEntity e) => sum + e.value);
    if (total <= 0) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: Text('Category spend is currently zero'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Category Split',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 46,
              sectionsSpace: 3,
              sections: points.asMap().entries.map((entry) {
                final int index = entry.key;
                final ChartPointEntity point = entry.value;
                final Color color = _palette[index % _palette.length];
                final double percentage = (point.value / total) * 100;

                return PieChartSectionData(
                  color: color,
                  value: point.value,
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: 70,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: points.asMap().entries.map((entry) {
            final int index = entry.key;
            final ChartPointEntity point = entry.value;
            final Color color = _palette[index % _palette.length];

            return _LegendItem(
              color: color,
              label: point.label,
              value: point.value.toStringAsFixed(0),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
