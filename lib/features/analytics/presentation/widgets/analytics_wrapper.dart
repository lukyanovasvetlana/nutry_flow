import 'package:flutter/material.dart';
import 'package:nutry_flow/core/services/analytics_service.dart';

/// Виджет-обертка для автоматического отслеживания экранов
class AnalyticsWrapper extends StatefulWidget {
  final Widget child;
  final String screenName;
  final String? screenClass;
  final Map<String, dynamic>? additionalParameters;

  const AnalyticsWrapper({
    super.key,
    required this.child,
    required this.screenName,
    this.screenClass,
    this.additionalParameters,
  });

  @override
  State<AnalyticsWrapper> createState() => _AnalyticsWrapperState();
}

class _AnalyticsWrapperState extends State<AnalyticsWrapper> {
  @override
  void initState() {
    super.initState();
    _trackScreenView();
  }

  void _trackScreenView() {
    // Отслеживаем просмотр экрана
    AnalyticsService.instance.logScreenView(
      screenName: widget.screenName,
      screenClass: widget.screenClass,
    );

    // Отслеживаем дополнительное событие с параметрами
    if (widget.additionalParameters != null) {
      AnalyticsService.instance.logEvent(
        name: 'screen_view',
        parameters: {
          'screen_name': widget.screenName,
          'screen_class': widget.screenClass,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...widget.additionalParameters!,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Виджет для отслеживания навигации
class AnalyticsNavigator extends StatelessWidget {
  final Widget child;
  final String currentScreenName;

  const AnalyticsNavigator({
    super.key,
    required this.child,
    required this.currentScreenName,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        // Отслеживаем навигацию
        AnalyticsService.instance.logEvent(
          name: 'navigation',
          parameters: {
            'from_screen': currentScreenName,
            'to_screen': settings.name ?? 'unknown',
            'route_type': 'generated',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          },
        );

        return MaterialPageRoute(
          builder: (context) => child,
          settings: settings,
        );
      },
    );
  }
}

/// Виджет для отслеживания жизненного цикла экрана
class AnalyticsLifecycleWrapper extends StatefulWidget {
  final Widget child;
  final String screenName;
  final VoidCallback? onScreenAppear;
  final VoidCallback? onScreenDisappear;

  const AnalyticsLifecycleWrapper({
    super.key,
    required this.child,
    required this.screenName,
    this.onScreenAppear,
    this.onScreenDisappear,
  });

  @override
  State<AnalyticsLifecycleWrapper> createState() =>
      _AnalyticsLifecycleWrapperState();
}

class _AnalyticsLifecycleWrapperState extends State<AnalyticsLifecycleWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _trackScreenAppear();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _trackScreenDisappear();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _trackScreenAppear();
        break;
      case AppLifecycleState.paused:
        _trackScreenDisappear();
        break;
      case AppLifecycleState.inactive:
        // Экран становится неактивным
        break;
      case AppLifecycleState.detached:
        // Приложение закрывается
        break;
      case AppLifecycleState.hidden:
        // Приложение скрыто
        break;
    }
  }

  void _trackScreenAppear() {
    AnalyticsService.instance.logEvent(
      name: 'screen_appear',
      parameters: {
        'screen_name': widget.screenName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    widget.onScreenAppear?.call();
  }

  void _trackScreenDisappear() {
    AnalyticsService.instance.logEvent(
      name: 'screen_disappear',
      parameters: {
        'screen_name': widget.screenName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    widget.onScreenDisappear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
