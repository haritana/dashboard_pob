import 'dart:typed_data';
import 'package:dashboard_pob/const/constanta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({required this.fileNameController, super.key});
  final TextEditingController fileNameController;
  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  final _controllerTranformation = TransformationController();
  Uint8List? _imageBytes;
  final GlobalKey _repaintKey = GlobalKey();
  Color pickerColor = Color(0xFF3EAAE9);
  Color currentColor = Color(0xFF3EAAE9);

  bool isEmptyText = false;
  bool option = true;

  List<String> images = [
    'assets/image/bg1.png',
    'assets/image/bg2.png',
    'assets/image/bg3.png',
    'assets/image/bg4.png',
  ];
  String selectedImage = 'assets/image/bg1.png';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _exportImage() async {
    try {
      RenderRepaintBoundary? boundary = _repaintKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        showSnackbarResponse(message: 'Error: Could not find boundary');
        return;
      }

      final pixelRatio = View.of(context).devicePixelRatio;
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        showSnackbarResponse(
          message: 'Error cannot convert image',
        );
        return;
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();
      upload(data: pngBytes);
    } catch (e) {
      showSnackbarResponse(message: 'Failed to export image $e');
    }
  }

  void upload({required Uint8List data}) async {
    final fileName = widget.fileNameController.text.trim();

    setState(() {
      isEmptyText = fileName.isEmpty;
    });

    if (isEmptyText || data.isEmpty) return;

    try {
      final uri = Uri.parse('$urlServer/upload');

      final lowerFileName = fileName.toLowerCase();
      final isValidExtension =
          RegExp(r'\.(jpg|jpeg|png|bmp)$').hasMatch(lowerFileName);
      final safeFileName = isValidExtension ? fileName : '$fileName.jpg';

      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          data,
          filename: safeFileName,
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        showSnackbarResponse(message: '✅ Upload Success');
      } else {
        showSnackbarResponse(
            message: '❌ Upload Failed: ${response.statusCode}');
      }
    } catch (e) {
      showSnackbarResponse(message: '❌ Upload Error: $e');
    } finally {
      setState(() {
        widget.fileNameController.clear();
        _imageBytes = null;
        _controllerTranformation.value = Matrix4.identity();
      });
    }
  }

  void showSnackbarResponse({
    required String message,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void openColorpicker() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        bool tempOption = option;
        String tempSelectedImage = selectedImage;

        return Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      radiobg(
                        title: 'Image',
                        value: true,
                        groupValue: tempOption,
                        onChanged: (val) {
                          setModalState(() {
                            tempOption = true;
                          });
                        },
                      ),
                      radiobg(
                        title: 'Color',
                        value: false,
                        groupValue: tempOption,
                        onChanged: (val) {
                          setModalState(() {
                            tempOption = false;
                          });
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  tempOption
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            final imagePath = 'assets/image/bg${index + 1}.png';
                            final isSelected = imagePath == tempSelectedImage;

                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  tempSelectedImage = imagePath;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child:
                                    Image.asset(imagePath, fit: BoxFit.cover),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: (color) {
                              setState(() {
                                pickerColor = color;
                              });
                            },
                            displayThumbColor: true,
                            portraitOnly: true,
                          ),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        option = tempOption;
                        selectedImage = tempSelectedImage;
                      });
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Pilih"),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controllerTranformation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  RepaintBoundary(
                    key: _repaintKey,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: option ? null : pickerColor,
                        border: Border.all(
                          width: .5,
                          color: Colors.black,
                        ),
                        image: option
                            ? DecorationImage(
                                image: AssetImage(selectedImage),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: InteractiveViewer(
                        transformationController: _controllerTranformation,
                        maxScale: 50.0,
                        minScale: 0.01,
                        boundaryMargin: const EdgeInsets.all(300),
                        child: _imageBytes != null
                            ? Image.memory(
                                _imageBytes!,
                                scale: 20,
                              )
                            : Image.asset(
                                'assets/image/blank.png',
                              ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      openColorpicker();
                    },
                    icon: Icon(
                      Icons.color_lens,
                      size: 30,
                      color: const Color(0xFF1C75C9),
                      shadows: [
                        Shadow(
                          color: Colors.white,
                          offset: Offset(1, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.fileNameController,
                          onChanged: (value) => setState(() {
                            isEmptyText = false;
                          }),
                          style: bodyStyle,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorText:
                                isEmptyText ? 'FtItemId cannot be empty' : null,
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _pickImage,
                        icon: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.folder_open,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: _exportImage,
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.lightBlue,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                  iconAlignment: IconAlignment.start,
                  icon: Icon(
                    Icons.upload,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Upload Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget radiobg({
    required String title,
    required bool value,
    required bool groupValue,
    required Function(bool?) onChanged,
  }) =>
      Row(
        children: [
          Text(title),
          RadioGroup(
            groupValue: groupValue,
            onChanged: onChanged,
            child: Radio(
              value: value,
            ),
          ),
        ],
      );
}
