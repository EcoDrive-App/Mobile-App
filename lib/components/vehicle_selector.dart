import 'package:flutter/material.dart';
import 'package:mobile_app/types/types.dart';

class VehicleSelector extends StatelessWidget {
  final List<VehicleType> vehicleTypes;
  final VehicleType? selectedVehicle;
  final ValueChanged<VehicleType> onVehicleSelected;
  final ColorScheme theme;

  const VehicleSelector({
    super.key,
    required this.vehicleTypes,
    required this.selectedVehicle,
    required this.onVehicleSelected,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 30),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: theme.onSurface.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Selecciona tu vehículo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Vehicle selector
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: vehicleTypes.length,
              itemBuilder: (context, index) {
                final vehicle = vehicleTypes[index];
                final isSelected = selectedVehicle == vehicle;

                return GestureDetector(
                  onTap: () => onVehicleSelected(vehicle),
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.primary.withValues(alpha: 0.1) : theme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? theme.primary : theme.outline.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          vehicle.icon,
                          size: 28,
                          color: isSelected ? theme.primary : theme.onSurface,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          vehicle.name,
                          style: TextStyle(
                            color: isSelected ? theme.primary : theme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Botón de confirmación
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedVehicle != null ? theme.primary : theme.onSurface.withValues(alpha: 0.1),
                foregroundColor: selectedVehicle != null ? theme.onPrimary : theme.onSurface.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: selectedVehicle != null ? () {} : null,
              child: Text(
                selectedVehicle != null
                    ? 'Iniciar viaje en ${selectedVehicle!.name}'
                    : 'Selecciona un vehículo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}