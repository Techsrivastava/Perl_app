import 'package:flutter/material.dart';
import 'package:university_app_2/config/theme.dart';

class AppBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    return Container(
      height: isSmallScreen ? 65 : 75,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE0E0E0).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.space_dashboard_rounded,
            label: 'Dashboard',
            isSelected: widget.currentIndex == 0,
            onTap: () => widget.onTap(0),
            isSmallScreen: isSmallScreen,
          ),
          _NavItem(
            icon: Icons.library_books_rounded,
            label: 'Courses',
            isSelected: widget.currentIndex == 1,
            onTap: () => widget.onTap(1),
            isSmallScreen: isSmallScreen,
          ),
          _NavItem(
            icon: Icons.group_rounded,
            label: 'Students',
            isSelected: widget.currentIndex == 2,
            onTap: () => widget.onTap(2),
            isSmallScreen: isSmallScreen,
          ),
          _NavItem(
            icon: Icons.work_rounded,
            label: 'Consult.',
            isSelected: widget.currentIndex == 3,
            onTap: () => widget.onTap(3),
            isSmallScreen: isSmallScreen,
          ),
          _NavItem(
            icon: Icons.account_balance_rounded,
            label: 'Univ.',
            isSelected: widget.currentIndex == 4,
            onTap: () => widget.onTap(4),
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSmallScreen;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isSmallScreen,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _colorAnimation =
        ColorTween(
          begin: AppTheme.mediumGray,
          end: AppTheme.primaryBlue,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void didUpdateWidget(covariant _NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _animationController.reset();
      _animationController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            splashColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
            highlightColor: AppTheme.primaryBlue.withOpacity(0.05),
            child: ClipRect(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: widget.isSmallScreen ? 2 : 6,
                  horizontal: widget.isSmallScreen ? 2 : 4,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: widget.isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      child: Container(
                        width: widget.isSmallScreen ? 40 : 50,
                        height: widget.isSmallScreen ? 40 : 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryBlue.withOpacity(0.2),
                              AppTheme.primaryBlue.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(widget.isSmallScreen ? 4 : 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.isSelected
                                ? AppTheme.primaryBlue.withOpacity(0.15)
                                : Colors.transparent,
                            boxShadow: widget.isSelected
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryBlue.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Icon(
                              widget.icon,
                              size: widget.isSmallScreen ? 18 : 24,
                              color: widget.isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.mediumGray,
                            ),
                          ),
                        ),
                        SizedBox(height: widget.isSmallScreen ? 0 : 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontSize: widget.isSmallScreen ? 8 : 11,
                            fontWeight: widget.isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: widget.isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.mediumGray,
                            letterSpacing: widget.isSelected ? 0.2 : 0,
                          ),
                          child: Text(
                            widget.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        if (widget.isSelected)
                          Container(
                            margin: EdgeInsets.only(
                              top: widget.isSmallScreen ? 0 : 3,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                              width: widget.isSmallScreen ? 22 : 26,
                              height: widget.isSmallScreen ? 2 : 2.5,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryBlue.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
