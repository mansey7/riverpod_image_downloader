import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_image_selector/core/models/photo_model.dart';
import 'package:riverpod_image_selector/core/riverpods.dart';
import 'package:riverpod_image_selector/core/services/toast_service.dart';

class PhotoCard extends HookConsumerWidget {
  final Photo photo;

  const PhotoCard({
    Key? key,
    required this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => download(photo, ref, context),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Expanded(
            flex: 1,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              fit: StackFit.loose,
              children: [
                Positioned.fill(
                    child: Image.network(photo.url, fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                      child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null));
                })),
                Positioned.fill(
                    child: photo.isDownloading
                        ? BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: const Opacity(
                                opacity: 0.85,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          )
                        : const SizedBox.shrink()),
              ],
            )),
      ),
    );
  }

  void _updateState(
    Photo photo,
    WidgetRef ref,
  ) =>
      ref.read(photoStateProvider.notifier).updateState(photo);

  Future<void> download(
      Photo photo, WidgetRef ref, BuildContext context) async {
    _updateState(photo, ref);
    final response = await http.get(Uri.parse(photo.downloadUrl));
    final imageFile = File(
        '${(await getApplicationDocumentsDirectory()).path}/${photo.id}.png');
    await imageFile.writeAsBytes(response.bodyBytes);
    await GallerySaver.saveImage(imageFile.path);
    _updateState(photo, ref);
    if (context.mounted) ToastService().showCustomToast(context);
  }
}
