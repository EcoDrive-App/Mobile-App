import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PermissionWarning extends StatefulWidget {
  final VoidCallback onPermissionGranted;
  const PermissionWarning({super.key, required this.onPermissionGranted});

  @override
  State<PermissionWarning> createState() => _PermissionWarningState();
}

class _PermissionWarningState extends State<PermissionWarning> {
  bool _isLoading = false;

  Future<void> _handlePermission() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      widget.onPermissionGranted();
    }


    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.tertiary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.onSurface.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Permítenos acceder a tu ubicación para brindarte una mejor experiencia",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: theme.onTertiary,
                  ),
                ),
                const SizedBox(height: 16),
                // Activate button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _isLoading ? null : _handlePermission,
                    style: TextButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: theme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.onPrimary),
                          ),
                        )
                      : const Text(
                          "Permitir ubicación",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
          // Image
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.map_rounded,
                color: theme.primary,
                size: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}