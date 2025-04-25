import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      debugPrint('📋 onEvent: ${bloc.runtimeType} - $event');
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      debugPrint('🔄 onTransition: ${bloc.runtimeType} - $transition');
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('❌ onError: ${bloc.runtimeType} - $error');
      debugPrint('$stackTrace');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change change) {
    if (kDebugMode) {
      debugPrint('💡 onChange: ${bloc.runtimeType} - $change');
    }
    super.onChange(bloc, change);
  }
}
