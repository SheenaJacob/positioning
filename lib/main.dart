import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:positioning/services/service_locator.dart';

import 'view_models/positioning_view_model.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indoor Positioning Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: IndoorPositioning(),
    );
  }
}

class IndoorPositioning extends StatelessWidget {
  IndoorPositioning({super.key});

  final _viewModel = PositioningViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Indoor Positioning Demo'),
      ),
      body: Observer(
        builder: (_) {
          return Column(
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'import_wgs84') {
                        final FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['json']);
                        if (result != null && result.files.isNotEmpty) {
                          _viewModel.importFile(result.files.first.path!);
                        }
                      }
                    },
                    itemBuilder: (BuildContext ctx) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'import_wgs84',
                          child: ListTile(
                            leading: Icon(Icons.import_export),
                            title: Text('Import Wgs84 Config'),
                          ),
                        ),
                      ];
                    },
                  )),
              Expanded(
                child: Center(
                  child: Text(_viewModel.position == null
                      ? 'No position'
                      : 'Latitude: ${_viewModel.position!.lat} \nLongitude: ${_viewModel.position!.lon} \nAccuracy: ${_viewModel.position!.acc}'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    _viewModel.isConnected
                        ? _viewModel.stopPositioning()
                        : _viewModel.startPositioning();
                  },
                  child: Text(
                    _viewModel.isConnected
                        ? 'Stop Positioning'
                        : 'Start Positioning',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
