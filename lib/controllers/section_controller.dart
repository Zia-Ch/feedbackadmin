import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/section_api.dart';
import '../models/feedback/section_model.dart';

final allSectionProvider = FutureProvider((ref) {
  final sectionController = ref.watch(sectionControllerProvider.notifier);
  return sectionController.getAllSections();
});

final sectionControllerProvider =
    StateNotifierProvider<SectionController, AsyncValue>((ref) {
  return SectionController(
    sectionApi: ref.watch(
      sectionApiProvider,
    ),
  );
});

class SectionController extends StateNotifier<AsyncValue> {
  final SectionApi _sectionApi;

  SectionController({required SectionApi sectionApi})
      : _sectionApi = sectionApi,
        super(
          const AsyncData(null),
        );

  Future<List<Section>> getAllSections() async {
    final res = await _sectionApi.getAllSections();
    final List<Section> result = [];

    res.fold((l) {
      throw l.message;
    }, (r) {
      for (var element in r) {
        result.add(Section.fromMap(element.data));
      }

      return result;
    });

    return result;
  }

  /* Future<Section> getSectionById(String id) async {
    final res = await _sectionApi.getSectionById(id);
    if (res.isRight()) {
      return Section.fromMap(res.getOrElse(() => {}));
    } else {
      throw res.fold((l) => l, (r) => r);
    }
  }*/
}
