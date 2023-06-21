import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/batch_api.dart';
import '../helper/enums/data_table_actions.dart';
import '../helper/enums/delete_actions.dart';
import '../models/feedback/batch_model.dart';

final getAllBatchProvider = FutureProvider((ref) {
  final batchController = ref.watch(batchControllerProvider.notifier);
  return batchController.getAllBatches();
});

final batchControllerProvider =
    StateNotifierProvider<BatchController, AsyncValue>((ref) {
  return BatchController(
    batchApi: ref.watch(
      batchApiProvider,
    ),
  );
});

class BatchController extends StateNotifier<AsyncValue> {
  final BatchApi _batchApi;

  BatchController({required BatchApi batchApi})
      : _batchApi = batchApi,
        super(
          const AsyncData(null),
        );

  Future<List<Batch>> getAllBatches() async {
    final res = await _batchApi.getAllBatchs();
    final List<Batch> result = [];

    res.fold((l) {
      throw l.message;
    }, (r) {
      for (var element in r) {
        result.add(Batch.fromMap(element.data));
      }

      return result;
    });

    return result;
  }

  Future<Batch> getBatchById(String id) async {
    final res = await _batchApi.getBatchById(id);
    res.fold((l) => l, (r) => Batch.fromMap(r));
    return Batch(
      id: id,
      batch: '',
    );
  }

  Future<bool> submitAddBatchForm(
    DataTableAction action,
    String? id,
    String batch,
  ) async {
    const AsyncValue.loading();
    final Batch batchModel = Batch(
      batch: batch,
      id: id ?? '',
    );

    if (action == DataTableAction.edit) {
      _updateBatchData(batchModel);
    } else if (action == DataTableAction.add) {
      await _addBatch(batchModel);
    }

    return state.hasError == false;
  }

  Future<void> _addBatch(Batch batch) async {
    final res = await _batchApi.addBatch(batch);

    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  Future<bool> delete(
    DeleteAction action,
    String id,
  ) async {
    //if (action == DeleteAction.logically) {
    //await _deleteBatchLogically(id);
    //} else if (action == DeleteAction.permanantly) {
    await _deleteBatchPermanantly(id);
    //}
    return state.hasError == false;
  }

  Future<void> _updateBatchData(Batch batch) async {
    final res = await _batchApi.updateBatchData(batch);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }

  /*Future<void> _deleteBatchLogically(String id) async {
    final res = await _batchApi.deleteBatchLogically(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }*/

  Future<void> _deleteBatchPermanantly(String id) async {
    final res = await _batchApi.deleteBatchPermanantly(id);
    res.fold((l) {
      state = AsyncError(l.message, l.stackTrace);
    }, (r) {
      state = AsyncData(r);
    });
  }
}
