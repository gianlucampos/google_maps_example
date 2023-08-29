import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_example/back/models/custom_placeholder.dart';
import 'package:google_maps_example/front/map/map_controller.dart';
import 'package:google_maps_example/front/map/widgets/image_picker_widget.dart';
import 'package:google_maps_example/front/store/app_store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceholderModal extends StatelessWidget {
  PlaceholderModal({super.key, required LatLng coordenates})
      : _coordenates = coordenates;

  final LatLng _coordenates;
  final _formKey = GlobalKey<FormState>();
  final _controller = GetIt.I.get<MapController>();
  final _appStore = GetIt.I.get<AppStore>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ImagePickerWidget(),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        validator: _textValidator,
                        controller: _nameController,
                        textAlignVertical: TextAlignVertical.top,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          hintText: 'Marker name',
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.transparent, height: 15),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        validator: _textValidator,
                        controller: _adressController,
                        textAlignVertical: TextAlignVertical.top,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          hintText: 'Adress',
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.transparent, height: 15),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          if (_appStore.selectedImage == null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Ok'),
                                    )
                                  ],
                                  content: const Text(
                                      'Image is necessary, choose one please!')),
                            );
                            return;
                          }
                          final placeholder = CustomPlaceholder(
                            name: _nameController.text,
                            adress: _adressController.text,
                            imagePath: _appStore.selectedImage!.path,
                            latitude: _coordenates.latitude,
                            longitude: _coordenates.longitude,
                          );
                          _controller.addMarker(placeholder);
                          Navigator.of(context).pop();
                          // _appStore.setSelectedImage(null);
                        },
                        child: const Text('Add marker'),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
