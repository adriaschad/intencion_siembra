import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/planting_form.dart';
import '../models/sampling_form.dart';

class SamplingFormScreen extends StatefulWidget {
  const SamplingFormScreen({super.key});

  @override
  State<SamplingFormScreen> createState() => _SamplingFormScreenState();
}

class _SamplingFormScreenState extends State<SamplingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _observationsController = TextEditingController();
  
  List<PlantingForm>? _plantingForms;
  PlantingForm? _selectedForm;
  List<BrixReading> _brixReadings = [BrixReading(value: 0, location: '')];
  List<XFile> _photos = [];
  bool _loading = true;
  bool _submitting = false;
  
  final String _producerId = 'producer123';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadPlantingForms();
  }

  Future<void> _loadPlantingForms() async {
    try {
      final apiService = context.read<ApiService>();
      final forms = await apiService.getPlantingForms(producerId: _producerId);
      setState(() {
        _plantingForms = forms;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    setState(() {
      _photos.addAll(images);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedForm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione una boleta de siembra')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final samplingForm = SamplingForm(
        plantingForm: _selectedForm!.id,
        farmName: _selectedForm!.farmName,
        lotNumber: _selectedForm!.lotNumber,
        valveNumber: _selectedForm!.valveNumber,
        variety: _selectedForm!.variety.id,
        samplingDate: DateTime.now(),
        brixReadings: _brixReadings,
        observations: _observationsController.text,
        producerId: _producerId,
      );

      await context.read<ApiService>().createSamplingForm(
        samplingForm,
        _photos.map((p) => p.path).toList(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Muestreo guardado exitosamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muestreo de Fruta'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seleccione la boleta de siembra',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<PlantingForm>(
                      value: _selectedForm,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Seleccionar boleta',
                      ),
                      items: _plantingForms?.map((form) {
                        return DropdownMenuItem(
                          value: form,
                          child: Text('${form.farmName} - ${form.lotNumber} (${form.variety.name})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedForm = value);
                      },
                      validator: (value) => value == null ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Lecturas de Brix',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._brixReadings.asMap().entries.map((entry) {
                      final index = entry.key;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Valor Brix',
                                    suffixText: '°Bx',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  initialValue: _brixReadings[index].value.toString(),
                                  onChanged: (value) {
                                    _brixReadings[index] = BrixReading(
                                      value: double.tryParse(value) ?? 0,
                                      location: _brixReadings[index].location,
                                    );
                                  },
                                  validator: (value) =>
                                      value == null || value.isEmpty ? 'Requerido' : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Ubicación',
                                    border: OutlineInputBorder(),
                                  ),
                                  initialValue: _brixReadings[index].location,
                                  onChanged: (value) {
                                    _brixReadings[index] = BrixReading(
                                      value: _brixReadings[index].value,
                                      location: value,
                                    );
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: _brixReadings.length > 1
                                    ? () {
                                        setState(() {
                                          _brixReadings.removeAt(index);
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _brixReadings.add(BrixReading(value: 0, location: ''));
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar lectura'),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Fotos',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Tomar/Seleccionar Fotos'),
                    ),
                    if (_photos.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('${_photos.length} foto(s) seleccionada(s)'),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photos.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.file(
                                    File(_photos[index].path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _photos.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _observationsController,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _submitting
                            ? const CircularProgressIndicator()
                            : const Text('Guardar Muestreo'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _observationsController.dispose();
    super.dispose();
  }
}
