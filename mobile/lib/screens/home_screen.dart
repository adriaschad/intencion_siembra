import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../models/planting_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PlantingForm>? _plantingForms;
  bool _loading = true;
  String? _error;
  final String _producerId = 'producer123'; // TODO: Get from auth

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final apiService = context.read<ApiService>();
      final forms = await apiService.getPlantingForms(producerId: _producerId);
      
      // Check for upcoming harvests and show notifications
      final notificationService = context.read<NotificationService>();
      await notificationService.checkUpcomingHarvests(
        forms.map((f) => f.toJson()).toList()
      );
      
      setState(() {
        _plantingForms = forms;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intención de Siembra'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'sampling',
            onPressed: () {
              Navigator.pushNamed(context, '/sampling-form');
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Muestreo'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'replanting',
            onPressed: () {
              Navigator.pushNamed(context, '/replanting-form');
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.grass),
            label: const Text('Resiembra'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_plantingForms == null || _plantingForms!.isEmpty) {
      return const Center(
        child: Text('No hay boletas de siembra'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _plantingForms!.length,
        itemBuilder: (context, index) {
          final form = _plantingForms![index];
          return _buildPlantingFormCard(form);
        },
      ),
    );
  }

  Widget _buildPlantingFormCard(PlantingForm form) {
    final daysUntilHarvest = form.expectedHarvestDate != null
        ? form.expectedHarvestDate!.difference(DateTime.now()).inDays
        : null;

    final showHarvestAlert = daysUntilHarvest != null && 
                              daysUntilHarvest <= 7 && 
                              daysUntilHarvest >= 0 &&
                              form.confirmedHarvestDate == null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    form.variety.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(form.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('${form.farmName} - Lote ${form.lotNumber}'),
            if (form.valveNumber != null)
              Text('Válvula: ${form.valveNumber}'),
            Text('Área: ${form.area.toStringAsFixed(2)} ha'),
            const SizedBox(height: 8),
            if (form.expectedHarvestDate != null) ...[
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Cosecha esperada: ${_formatDate(form.expectedHarvestDate!)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              if (daysUntilHarvest != null && daysUntilHarvest >= 0)
                Text(
                  'En $daysUntilHarvest días',
                  style: TextStyle(
                    fontSize: 12,
                    color: daysUntilHarvest <= 7 ? Colors.orange : Colors.grey,
                    fontWeight: daysUntilHarvest <= 7 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
            ],
            if (showHarvestAlert) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          '⚠️ Próxima Cosecha',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Por favor confirme la fecha de cosecha o asigne una nueva fecha.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _showConfirmHarvestDialog(form),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Confirmar Fecha'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'approved':
        color = Colors.green;
        label = 'Aprobado';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Pendiente';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rechazado';
        break;
      case 'harvested':
        color = Colors.blue;
        label = 'Cosechado';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _showConfirmHarvestDialog(PlantingForm form) async {
    DateTime selectedDate = form.expectedHarvestDate ?? DateTime.now();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Fecha de Cosecha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Finca: ${form.farmName}'),
            Text('Lote: ${form.lotNumber}'),
            Text('Variedad: ${form.variety.name}'),
            const SizedBox(height: 16),
            const Text('Fecha de cosecha:'),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  Text(
                    _formatDate(selectedDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Cambiar Fecha'),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<ApiService>().confirmHarvestDate(form.id, selectedDate);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fecha de cosecha confirmada')),
          );
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
