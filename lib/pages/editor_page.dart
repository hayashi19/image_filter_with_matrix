import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_filter_with_matrix/controller/controller.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).padding.left + 10,
        top: MediaQuery.of(context).padding.top + 10,
        right: MediaQuery.of(context).padding.right + 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // const FilterMenu(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              PickButton(),
              SizedBox(width: 10),
              SaveButton()
            ],
          ),
          const SizedBox(height: 10),
          const Expanded(
            flex: 1,
            child: ImagePreview(),
          ),
          const SizedBox(height: 10),
          const MatrixMenu(),
        ],
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController());
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey.shade800,
      child: Obx(() {
        if (controller.imagesList.isNotEmpty) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Obx(
              () => ColorFiltered(
                colorFilter: ColorFilter.matrix(controller.matrixFilterValue),
                child: ListView.separated(
                  padding: const EdgeInsets.all(0),
                  itemCount: controller.imagesList.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      controller.imagesList[index],
                      fit: BoxFit.contain,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: Text("No image"),
          );
        }
      }),
    );
  }
}

class MatrixMenu extends StatelessWidget {
  const MatrixMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController());
    return Obx(
      () {
        if (controller.isUseMatrix.value) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade800,
              child: Column(
                children: const <Widget>[
                  MatrixHeader(),
                  Divider(
                    height: 32,
                    color: Colors.blueGrey,
                    thickness: 2,
                  ),
                  MatrixField(),
                ],
              ),
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey.shade800,
            child: const MatrixHeader(),
          );
        }
      },
    );
  }
}

class MatrixHeader extends StatelessWidget {
  const MatrixHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text("Image Matrix"),
        Material(
          color: Colors.transparent,
          child: Ink(
            color: Colors.grey.shade700,
            child: Tooltip(
              message: "Toggle the matrix filter",
              textStyle: const TextStyle(color: Colors.white, fontSize: 10),
              decoration: BoxDecoration(color: Colors.grey.shade700),
              child: InkWell(
                onTap: () => controller.isUseMatrix.value =
                    !controller.isUseMatrix.value,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Obx(
                    () => Text(
                      controller.isUseMatrix.value ? "Close" : "Show",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MatrixField extends StatelessWidget {
  const MatrixField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController());
    return Obx(
      () => Visibility(
        visible: controller.isUseMatrix.value,
        child: Expanded(
          child: Obx(
            () => GridView.builder(
              itemCount: controller.matrixFilterValue.length,
              padding: const EdgeInsets.all(0),
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(5),
                  color: Colors.grey.shade700,
                  child: Center(
                    child: TextField(
                      controller: controller.matrixFilterController[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: (index + 1).toString(),
                      ),
                      onChanged: (newValue) => controller.changeMatrix(
                        index,
                        newValue,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FilterMenu extends StatelessWidget {
  const FilterMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController());
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.grey.shade800,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade700,
              child: const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration.collapsed(
                  hintText: "Value",
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.filterListMenu
                    .map(
                      (element) => Material(
                        color: Colors.transparent,
                        child: Obx(
                          () => Ink(
                            color:
                                controller.filterListMenuValue.value == element
                                    ? Colors.grey.shade700
                                    : Colors.transparent,
                            child: InkWell(
                              onTap: () => controller.changeMenu(element),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  element,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PickButton extends StatelessWidget {
  const PickButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController());
    return Expanded(
      child: Ink(
        color: Colors.grey.shade800,
        child: Tooltip(
          message: "Pick image from gallery",
          textStyle: const TextStyle(color: Colors.white, fontSize: 10),
          decoration: BoxDecoration(color: Colors.grey.shade700),
          child: InkWell(
            onTap: () => controller.getImage(),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Pick",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FilterController controller = Get.put(FilterController());
    return Expanded(
      child: Ink(
        color: Colors.grey.shade800,
        child: Tooltip(
          message: "Save all processed images to gallery",
          textStyle: const TextStyle(color: Colors.white, fontSize: 10),
          decoration: BoxDecoration(color: Colors.grey.shade700),
          child: InkWell(
            onTap: () => controller.saveImage(),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Save",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
