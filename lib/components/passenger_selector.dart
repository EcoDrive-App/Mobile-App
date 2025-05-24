import 'package:flutter/material.dart';
import 'package:mobile_app/types/vehicle.dart';

class PassengerSelector extends StatelessWidget {
  final Vehicle vehicle;
  final int currentPassengers;
  final ValueChanged<int> onPassengerCountChanged;

  const PassengerSelector({
    super.key,
    required this.vehicle,
    required this.currentPassengers,
    required this.onPassengerCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.outline.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pasajeros',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Decrease button
              IconButton(
                onPressed: currentPassengers > 1
                    ? () => onPassengerCountChanged(currentPassengers - 1)
                    : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: currentPassengers > 1
                      ? theme.primary
                      : theme.onSurface.withValues(alpha: 0.3),
                ),
              ),
              // Passenger count
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currentPassengers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
              ),
              // Increase button
              IconButton(
                onPressed: currentPassengers < vehicle.maxCapacity
                    ? () => onPassengerCountChanged(currentPassengers + 1)
                    : null,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: currentPassengers < vehicle.maxCapacity
                      ? theme.primary
                      : theme.onSurface.withValues(alpha: 0.3),
                ),
              ),
              const Spacer(),
              // Max capacity indicator
              Text(
                'Máximo: ${vehicle.maxCapacity}',
                style: TextStyle(
                  color: theme.onSurface.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}