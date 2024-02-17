import 'package:flutter_bloc/flutter_bloc.dart';

import 'logger.dart';

class AppBlocObserver extends BlocObserver {
  final String nextLine = '\n';

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    showLog(
        'onCreate => ${bloc.runtimeType} created${nextLine}initState => ${bloc.state}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    showLog(
        'onChange => ${bloc.runtimeType} changed${nextLine}currentState => ${change.currentState}${nextLine}nextState => ${change.nextState}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    showLog(
        'onEvent => ${bloc.runtimeType} event added${nextLine}event => $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    showLog(
        'onTransition => ${bloc.runtimeType} transition added${nextLine}transition => $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    showLog(
        'onError => ${bloc.runtimeType} error occured${nextLine}error => $error');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    showLog('onClose => ${bloc.runtimeType} closed');
  }
}
