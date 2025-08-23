import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'dart:io';
import 'adverts_repository.dart';
import 'paginated_adverts.dart';

class MyAdvertsSearchController extends StateNotifier<String?> {
  MyAdvertsSearchController() : super(null);

  void setQuery(String value) {
    final trimmed = value.trim();
    state = trimmed.isEmpty ? null : trimmed;
  }

  void clear() => state = null;
}

final myAdvertsSearchControllerProvider =
    StateNotifierProvider<MyAdvertsSearchController, String?>((ref) => MyAdvertsSearchController());

final filteredMyAdvertsProvider = Provider<AsyncValue<PaginatedAdverts>>((ref) {
  final search = (ref.watch(myAdvertsSearchControllerProvider) ?? '').trim().toLowerCase();
  final mine = ref.watch(myAdvertsProvider);
  return mine.whenData((page) {
    if (search.isEmpty) return page;
    final filtered = page.items.where((a) {
      final title = a.title.toLowerCase();
      final category = a.category.toLowerCase();
      return title.contains(search) || category.contains(search);
    }).toList();
    return PaginatedAdverts(items: filtered, totalPages: page.totalPages);
  });
});

class CreateAdvertController extends StateNotifier<AsyncValue<Advert?>> {
  CreateAdvertController(this._ref) : super(const AsyncValue.data(null));
  
  final Ref _ref;
  
  Future<void> createAdvert(Advert advert, {File? imageFile}) async {
    state = const AsyncValue.loading();
    try {
      final result = await _ref.read(advertsRepositoryProvider.notifier).create(advert, imageFile: imageFile);
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  void reset() {
    state = const AsyncValue.data(null);
  }
}

final createAdvertControllerProvider = StateNotifierProvider<CreateAdvertController, AsyncValue<Advert?>>((ref) {
  return CreateAdvertController(ref);
});


