import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_image_selector/core/models/photo_model.dart';

final photosProvider = FutureProvider<List<Photo>>((ref) async {
  final response = await http.get(Uri.parse(
      'https://api.unsplash.com/photos?page=1&client_id=OmR7Oo_LH-mf3iNXekLJ90SjuV2rQhmtlAk2ymQ-bf0'));
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as List<dynamic>;
    return json.map((data) => Photo.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load photos');
  }
});
final photoStateProvider =
    StateNotifierProvider<PhotosState, AsyncValue<List<Photo>>>(
        (ref) => PhotosState(ref));

class PhotosState extends StateNotifier<AsyncValue<List<Photo>>> {
  PhotosState(this._ref) : super(const AsyncValue.loading()) {
    _fetchData();
  }
  final Ref _ref;

  Future<void> _fetchData() async {
    state = const AsyncValue.loading();
    // todoListProvider is of type FutureProvider
    _ref.watch(photosProvider).when(data: (data) {
      state = AsyncValue.data(data);
    }, error: (err, stackTrace) {
      state = AsyncValue.error(err, stackTrace);
    }, loading: () {
      state = const AsyncValue.loading();
    });
  }

  void updateState(Photo photo) {
    List<Photo> tempList = [];
    for (Photo listPhoto in state.value!) {
      if (listPhoto == photo) {
        listPhoto.isDownloading = !photo.isDownloading;
      }
      tempList.add(listPhoto);
    }
    state = AsyncValue.data(tempList);
  }
}
