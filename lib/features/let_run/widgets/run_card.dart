import 'package:flutter/material.dart';
import 'package:runmate/features/let_run/models/run_data.dart';
import "../../../common/utils/constants.dart";
import '../../../models/run.dart';



class RunCard extends StatelessWidget {
  final Run? lastRun;

  const RunCard({Key? key, this.lastRun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lastRun == null) {
      return const Center(child: Text('No previous runs'));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Last Run', style: TextStyle(color: kPrimaryColor, fontSize:  20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const Spacer(),
              (lastRun != null && lastRun?.date != null) ? Text('${lastRun?.date.day}/${lastRun?.date.month}/${lastRun?.date.year}', style: const TextStyle(color: Colors.white)) : const SizedBox()
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('Steps', '${lastRun!.steps}'),
              _buildStat('Distance', '${lastRun!.distance.toStringAsFixed(2)} km'),

              _buildStat(
                'Time',
                '${lastRun!.duration.inMinutes}:${(lastRun!.duration.inSeconds % 60).toString().padLeft(2, '0')}',
              ),
              _buildStat('Calories', lastRun!.calories.toStringAsFixed(1)),
              _buildStat('Pace', '${lastRun!.averagePace.toStringAsFixed(2)}'),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor))
      ],
    );
  }
}