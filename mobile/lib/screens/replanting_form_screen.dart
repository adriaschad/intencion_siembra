import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/planting_form.dart';
import '../models/replanting_form.dart';

class ReplantingFormScreen extends StatefulWidget {
  const ReplantingFormScreen({super.key});

  @override
  State<ReplantingFormScreen> createState() => _ReplantingFormScreenState();
}

class _ReplantingFormScreenState extends State<ReplantingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _additionalSeedsController = TextEditingController();
  final _reasonController = TextEditingController();
  final _affectedAreaController = TextEditingController();
  final _observationsController = TextEditingController();
  
  List<PlantingForm>? _plantingForms;
  PlantingForm? _selectedForm;
  bool _loading = true;
  bool _submitting = false;
  
  final String _producerId = 'producer123';

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
      final replantingForm = ReplantingForm(
        plantingForm: _selectedForm!.id,
        farmName: _selectedForm!.farmName,
        lotNumber: _selectedForm!.lotNumber,
        variety: _selectedForm!.variety.id,
        replantingDate: DateTime.now(),
        additionalSeedsUsed: int.parse(_additionalSeedsController.text),
        reason: _reasonController.text.isEmpty ? null : _reasonController.text,
        affectedArea: _affectedAreaController.text.isEmpty
            ? null
            : double.parse(_affectedAreaController.text),
        observations: _observationsController.text.isEmpty
            ? null
            : _observationsController.text,
        producerId: _producerId,
      );

      await context.read<ApiService>().createReplantingForm(replantingForm);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resiembra guardada exitosamente')),
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
        title: const Text('Boleta de Resiembra'),
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
                          child: Text(
                            '${form.farmName} - ${form.lotNumber} (${form.variety.name})',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedForm = value);
                      },
                      validator: (value) => value == null ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _additionalSeedsController,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad de Semillas Adicionales *',
                        border: OutlineInputBorder(),
                        helperText: 'Número de semillas utilizadas para resiembra',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requerido';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Ingrese un número válido mayor a 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Razón de la Resiembra',
                        border: OutlineInputBorder(),
                        helperText: 'Ej: Baja germinación, plagas, clima, etc.',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _affectedAreaController,
                      decoration: const InputDecoration(
                        labelText: 'Área Afectada (hectáreas)',
                        border: OutlineInputBorder(),
                        helperText: 'Opcional',
                        suffixText: 'ha',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return 'Ingrese un número válido';
                          }
                          if (double.parse(value) < 0) {
                            return 'El área no puede ser negativa';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                            : const Text('Guardar Resiembra'),
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
    _additionalSeedsController.dispose();
    _reasonController.dispose();
    _affectedAreaController.dispose();
    _observationsController.dispose();
    super.dispose();
  }
}
