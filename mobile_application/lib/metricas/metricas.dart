
import 'package:flutter/material.dart';
import 'package:mobile_application/metricas/graficas.dart';

enum DataSource { url, office }

class Metricas extends StatefulWidget {
  const Metricas({super.key});

  @override
  State<Metricas> createState() => _MetricasState();
}

class _MetricasState extends State<Metricas> {
  // Variables para el rango de fechas
  DateTime? _startDate;
  DateTime? _endDate;

  DataSource _rangoSelection = DataSource.url;

  // Método para seleccionar una fecha (inicio o fin)
  Future<void> _pickDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métricas'),
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
             Text(
              'Total: 200 Bytes',
              style: TextStyle(fontSize: 23,
              fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
          
        ),
        const SizedBox(height: 10),
            // Sección "Rango de Fechas"
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                
                    // Opciones: URL o Archivos Office
                    DropdownButton<DataSource>(
                      value: _rangoSelection,
                      items: DataSource.values.map((DataSource option) {
                        return DropdownMenuItem<DataSource>(
                          value: option,
                          child: Text(option == DataSource.url ? 'URL' : 'Archivos Office'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _rangoSelection = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
            
                    // Selección de fechas de inicio y fin
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => _pickDate(isStart: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple[100],
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(_startDate == null
                              ? 'Fecha inicio'
                              : _startDate!.toLocal().toString().split(' ')[0]),
                        ),
                        ElevatedButton(
                          onPressed: () => _pickDate(isStart: false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple[100],
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(_endDate == null
                              ? 'Fecha fin'
                              : _endDate!.toLocal().toString().split(' ')[0],
                        ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Gráfica "Rango de Fechas"
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Graficas(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
