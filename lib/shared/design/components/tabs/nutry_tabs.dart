import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Компонент Tabs для NutryFlow
class NutryTabs extends StatefulWidget {
  /// Список вкладок
  final List<NutryTab> tabs;

  /// Индекс выбранной вкладки
  final int initialIndex;

  /// Обработчик изменения вкладки
  final ValueChanged<int>? onTabChanged;

  /// Показывать ли индикатор
  final bool showIndicator;

  /// Цвет индикатора
  final Color? indicatorColor;

  /// Размер вкладок
  final NutryTabSize size;

  const NutryTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.showIndicator = true,
    this.indicatorColor,
    this.size = NutryTabSize.medium,
  });

  @override
  State<NutryTabs> createState() => _NutryTabsState();
}

class _NutryTabsState extends State<NutryTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() => _selectedIndex = _tabController.index);
    widget.onTabChanged?.call(_tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = _TypographyHelper();
    final spacing = _SpacingHelper();
    final borders = context.borders;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(borders.md),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: widget.showIndicator
                ? BoxDecoration(
                    color: widget.indicatorColor ?? colors.primary,
                    borderRadius: BorderRadius.circular(borders.md),
                  )
                : null,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: widget.showIndicator
                ? colors.onPrimary
                : colors.primary,
            unselectedLabelColor: colors.onSurfaceVariant,
            labelStyle: _getLabelStyle(typography),
            unselectedLabelStyle: _getLabelStyle(typography),
            tabs: widget.tabs.map((tab) {
              final index = widget.tabs.indexOf(tab);
              final isSelected = _selectedIndex == index;
              return Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: _getIconSize(spacing),
                      ),
                      SizedBox(width: spacing.xs),
                    ],
                    Text(tab.label),
                    if (tab.badge != null) ...[
                      SizedBox(width: spacing.xs),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.onPrimary.withValues(alpha: 0.3)
                              : colors.error,
                          borderRadius: BorderRadius.circular(borders.full),
                        ),
                        child: Text(
                          tab.badge!,
                          style: typography.labelSmallStyle.copyWith(
                            color: isSelected
                                ? colors.onPrimary
                                : colors.onError,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }

  TextStyle _getLabelStyle(_TypographyHelper typography) {
    switch (widget.size) {
      case NutryTabSize.small:
        return typography.labelSmallStyle;
      case NutryTabSize.medium:
        return typography.labelMediumStyle;
      case NutryTabSize.large:
        return typography.labelLargeStyle;
    }
  }

  double _getIconSize(_SpacingHelper spacing) {
    switch (widget.size) {
      case NutryTabSize.small:
        return spacing.iconSmall;
      case NutryTabSize.medium:
        return spacing.iconMedium;
      case NutryTabSize.large:
        return spacing.iconLarge;
    }
  }
}

class _TypographyHelper {
  final TextStyle labelSmallStyle = DesignTokens.typography.labelSmallStyle;
  final TextStyle labelMediumStyle = DesignTokens.typography.labelMediumStyle;
  final TextStyle labelLargeStyle = DesignTokens.typography.labelLargeStyle;
}

class _SpacingHelper {
  final double iconSmall = DesignTokens.spacing.iconSmall;
  final double iconMedium = DesignTokens.spacing.iconMedium;
  final double iconLarge = DesignTokens.spacing.iconLarge;
  final double xs = DesignTokens.spacing.xs;
}

/// Модель вкладки
class NutryTab {
  final String label;
  final Widget content;
  final IconData? icon;
  final String? badge;

  const NutryTab({
    required this.label,
    required this.content,
    this.icon,
    this.badge,
  });
}

/// Размер вкладок
enum NutryTabSize {
  small,
  medium,
  large,
}

