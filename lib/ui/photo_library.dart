import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_image_selector/core/models/photo_model.dart';
import 'package:riverpod_image_selector/core/riverpods.dart';
import 'package:riverpod_image_selector/ui/photo_card.dart';

class PhotoLibrary extends HookConsumerWidget {
  const PhotoLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Photo>> photos = ref.watch(photoStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
      ),
      body: photos.when(
        data: (data) => GridView.count(
          crossAxisCount: 2,
          children: List.generate(
              data.length,
              (index) => PhotoCard(
                    photo: data[index],
                  )),
        ),
        loading: () => const Center(child: Text('Loading...')),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }
}
