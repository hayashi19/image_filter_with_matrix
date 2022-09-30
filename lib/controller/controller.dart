import 'dart:io';
import 'dart:typed_data';

import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widget_to_image/widget_to_image.dart';

class FilterController extends GetxController {
  var imagesList = <File>[].obs;
  var isUseMatrix = true.obs;
  var matrixFilterValue = <double>[].obs;
  var matrixFilterController = <TextEditingController>[].obs;
  var filterListMenu = <String>[
    "Brightness",
    "Contrast",
    "Hue",
    "Saturation",
    "Color Overlay",
    "Grayscale",
    "Invert",
    "Sephia"
  ].obs;
  var filterListMenuValue = "Brightness".obs;
  changeMenu(String newValue) => filterListMenuValue.value = newValue;
  var filterValue = 0.0.obs;
  changeFilterValue(double newValue) => filterValue.value = newValue;

  var matrixFilterGenratorValue = ColorFilterGenerator(
    name: "filter",
    filters: [],
  ).obs;

  var isLoading = false.obs;

  Future getImage() async {
    try {
      if (await Permission.storage.request().isGranted) {
        final List<XFile>? images = await ImagePicker().pickMultiImage();
        if (images!.isEmpty) return;

        for (var element in images) {
          imagesList.add(File(element.path));

          element.printInfo();
          imagesList.printInfo();
        }
      } else {
        return;
      }
    } catch (e) {
      e.printError();
    }
  }

  Future changeMatrix(int index, String newValue) async {
    try {
      if (imagesList.isNotEmpty) {
        matrixFilterValue[index] = double.tryParse(newValue) ?? 0.0;
        matrixFilterValue[index].printInfo();

        matrixFilterValue.refresh();
      }
    } catch (e) {
      e.printError();
    }
  }

  Future changeMatrixWithGenerator(int choosedFilter) async {
    try {
      switch (filterListMenuValue.value) {
        case "Brightness":
          break;
        default:
      }

      matrixFilterGenratorValue.value = ColorFilterGenerator(
        name: "",
        filters: [],
      );
    } catch (e) {
      e.printError();
    }
  }

  Future saveImage() async {
    try {
      isLoading.value = true;

      if (imagesList.isNotEmpty) {
        for (var i = 0; i < imagesList.length; i++) {
          ByteData byteData = await WidgetToImage.widgetToImage(ColorFiltered(
            colorFilter: ColorFilter.matrix(matrixFilterValue),
            child: Image.file(
              imagesList[i],
              fit: BoxFit.contain,
            ),
          ));

          byteData.toString().printInfo();

          final result = await ImageGallerySaver.saveImage(
            byteData.buffer.asUint8List(
              byteData.offsetInBytes,
              byteData.lengthInBytes,
            ),
            name: "img$i${DateTime.now().millisecondsSinceEpoch}",
          );

          result.toString().printInfo();
        }
      } else {
        isLoading.value = false;
        return;
      }

      isLoading.value = false;
    } catch (e) {
      e.printError();
    }
  }

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    for (var i = 0; i < 20; i++) {
      if (i % 6 == 0) {
        matrixFilterValue.add(1.toDouble());
      } else {
        matrixFilterValue.add(0.toDouble());
      }
      matrixFilterController.add(TextEditingController());
    }

    for (var i = 0; i < matrixFilterValue.length; i++) {
      matrixFilterController[i].text = matrixFilterValue[i].round().toString();
    }
  }
}
