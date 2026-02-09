import 'package:flutter/material.dart';

/// App Logo Widget
/// Displays the EduConnect logo with customizable size
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool useWhiteLogo;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.useWhiteLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      useWhiteLogo ? 'assets/EDUCONNECTw.png' : 'assets/EDUCONNECT.jpg',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(Icons.school, color: Colors.white, size: 40),
          ),
        );
      },
    );
  }
}

/// App Logo Circle (for profile, avatar, etc.)
class AppLogoCircle extends StatelessWidget {
  final double radius;
  final bool useWhiteLogo;

  const AppLogoCircle({super.key, this.radius = 40, this.useWhiteLogo = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: AppLogo(
          width: radius * 1.8,
          height: radius * 1.8,
          useWhiteLogo: useWhiteLogo,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// App Logo with Text (for splash, login, etc.)
class AppLogoWithText extends StatelessWidget {
  final double logoHeight;
  final double spacing;
  final bool useWhiteLogo;

  const AppLogoWithText({
    super.key,
    this.logoHeight = 100,
    this.spacing = 16,
    this.useWhiteLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(height: logoHeight, useWhiteLogo: useWhiteLogo),
        SizedBox(height: spacing),
        Text(
          'EduConnect',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: useWhiteLogo ? Colors.white : const Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'University & Admission Management',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: useWhiteLogo
                ? Colors.white.withOpacity(0.8)
                : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
