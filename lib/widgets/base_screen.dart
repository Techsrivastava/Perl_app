import 'package:flutter/material.dart';
import 'package:university_app_2/widgets/app_drawer.dart';

/// A base screen widget that provides common functionality and layout
/// for all screens in the app.
class BaseScreen extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final bool showDrawer;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final List<Widget>? actions;

  const BaseScreen({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = false,
    this.showDrawer = false,
    this.scaffoldKey,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current route if in a navigation context
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
      ),
      drawer: showDrawer 
          ? AppDrawer(
              currentRoute: currentRoute,
              onNavigate: (route) {
                // Close the drawer if it's open
                if (scaffoldKey?.currentState?.isDrawerOpen ?? false) {
                  Navigator.of(context).pop();
                }
                // Handle navigation if needed
                // This can be overridden by the parent widget if needed
              },
            ) 
          : null,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
