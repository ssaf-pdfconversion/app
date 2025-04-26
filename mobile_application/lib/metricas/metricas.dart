
import 'package:flutter/material.dart';
import 'package:mobile_application/metricas/graficas.dart';
import 'package:mobile_application/metricas/metricas_service.dart';
import 'package:mobile_application/usuarios/cerrar_sesion.dart';

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
  double? _total;
  bool? grafica;
  List<ChartData> _chartData = [];

  DataSource _rangoSelection = DataSource.url;


  @override
  void initState() {
    super.initState();
    _getTotal();
  }
  // Método para obtener el total de métricas
  Future<void> _getTotal() async {
    final total = await MetricService().metricTotal();
    setState(() {
      _total = total;
    });
  }

  Future<void> _getStatistics() async {
    if (_startDate != null && _endDate != null) {
      List<ChartData> result = await MetricService().statistics(_startDate!, _endDate!, _rangoSelection.name);
      if (result.isNotEmpty) { 
        setState(() {
          grafica = true;
          _chartData = result;
        });
      } else {
        setState(() {
          grafica = false;
        });// Manejar error
      }
    } else {
      setState(() {
        grafica = false;
      });// Manejar error de fechas no seleccionadas
    }
  }
  // Método para seleccionar una fecha (inicio o fin)
  Future<void> _pickDate({ required bool isStart }) async {
  final DateTime today = DateTime.now();
  
  // Defaults del diálogo
  DateTime firstDate = DateTime(2000);
  DateTime lastDate  = today;
  DateTime initialDate = today;

  if (isStart) {
    // --- Picker de START ---
    // 1) El tope máximo es un día antes de _endDate (si existe), o hoy si no.
    if (_endDate != null) {
      lastDate = _endDate!.subtract(const Duration(days: 1));
    }

    // 2) InitialDate: o el valor previo de _startDate, o ese lastDate ajustado
    initialDate = _startDate ?? lastDate;

    // 3) Clamps: nos aseguramos de que initialDate esté en [firstDate, lastDate]
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(lastDate))  initialDate = lastDate;

  } else {
    // --- Picker de END ---
    // 1) El tope inferior es un día después de _startDate (si existe)
    if (_startDate != null) {
      firstDate = _startDate!.add(const Duration(days: 1));
    }

    // 2) InitialDate: o el valor previo de _endDate, o hoy
    initialDate = _endDate ?? today;

    // 3) Clamps: nos aseguramos de que initialDate esté en [firstDate, today]
    if (initialDate.isBefore(firstDate)) initialDate = firstDate;
    if (initialDate.isAfter(today))     initialDate = today;

    // lastDate ya es `today` por defecto
  }

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (picked != null) {
    setState(() {
      if (isStart) {
        _startDate = picked;
        // Si após elegir startDate rompemos la lógica con endDate, la reseteamos
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
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
         actions: [
          CerrarSesion()
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Total de MB convertidos:',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            _total == null
          ? CircularProgressIndicator()
          : _total == -1.0
          ? Text(
              'Información no disponible',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            )
          // si todo va bien, mostrar total
          : Text(
              '$_total MB',
              style: TextStyle(
                fontSize: 23,
              ),
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

                    Text(
              'MB convertidos por día en un intervalo de tiempo:',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),                
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
                    ElevatedButton(
                      onPressed: () {
                        _getStatistics();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      
                      child: const Text('Obtener estadísticas'),
                    ),
                    const SizedBox(height: 10),
                    grafica == false ? Text('Datos no disponibles')
                    : SizedBox(
                      child: buildBarChart(_chartData), // Gráfica de barras
                    )                   // Gráfica "Rango de Fechas"
                    
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
