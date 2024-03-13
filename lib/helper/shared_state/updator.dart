import 'package:flutter_riverpod/flutter_riverpod.dart';

final futureStateUpdator =
    StateNotifierProvider<FutureStateUpdator, bool>((ref) {
  return FutureStateUpdator();
});

class FutureStateUpdator extends StateNotifier<bool> {
  FutureStateUpdator() : super(false);

  void update() {
    state = !state;
  }
}
