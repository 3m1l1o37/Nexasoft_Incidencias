import '../data/almacen_local.dart';
import '../model/incidencia.dart';

class GestorIncidencias {
  late final AlmacenLocal datos = AlmacenLocal();
  List<Incidencia> incidencias = [];
  int cantidadPendientes = 0;

  Future<void> iniciar() async {
    incidencias = await datos.leer();
    cantidadPendientes =
        incidencias.where((x) => x.estado == 'Pendiente').length;
  }

  List<Incidencia> buscar(
    String texto, {
    String estado = 'Todas',
    String prioridad = 'Todas',
  }) {
    final textoEstandar = texto.trim().toLowerCase();

    return incidencias.where((incidencia) {
      final coincideTexto = textoEstandar.isEmpty ||
          incidencia.titulo.trim().toLowerCase().contains(textoEstandar) ||
          incidencia.descripcion.trim().toLowerCase().contains(textoEstandar) ||
          incidencia.cliente.trim().toLowerCase().contains(textoEstandar);
      final coincideEstado = estado == 'Todas' || incidencia.estado == estado;
      final coincidePrioridad =
          prioridad == 'Todas' || incidencia.prioridad == prioridad;

      return coincideTexto && coincideEstado && coincidePrioridad;
    }).toList();
  }

  Incidencia? porId(String id) {
    for (var x in incidencias) {
      if (x.id == id) return x;
    }
    return null;
  }

  int contar(String estado) {
    //if (estado == 'Pendiente') return cantidadPendientes;
    return incidencias.where((x) => x.estado == estado).length;
  }

  Future<void> cambiarEstado(String id, String estado) async {
    for (var i = 0; i < incidencias.length; i++) {
      if (incidencias[i].id == id) {
        incidencias[i].estado = estado;
        break;
      }
    }
    //No se llamaba a guardar de almacen local, la funcion ya estaba hecha
    await datos.guardar(incidencias);
  }

  Future<void> crear(String titulo, String descripcion, String cliente,
      String categoria, String prioridad) async {
    final nuevo = Incidencia(
      id: 'INC-${DateTime.now().microsecondsSinceEpoch}',
      titulo: titulo,
      descripcion: descripcion,
      cliente: cliente,
      categoria: categoria,
      estado: 'Pendiente',
      prioridad: prioridad,
      fecha: DateTime.now().toIso8601String().split('T').first,
    );
    incidencias.insert(0, nuevo);
    cantidadPendientes++;
    await datos.guardar(incidencias);
  }

  Future<void> actualizar(
    String id, {
    required String titulo,
    required String descripcion,
    required String cliente,
    required String categoria,
    required String prioridad,
  }) async {
    final item = porId(id);
    if (item == null) {
      throw StateError('No se encontró la incidencia $id');
    }

    item
      ..titulo = titulo
      ..descripcion = descripcion
      ..cliente = cliente
      ..categoria = categoria
      ..prioridad = prioridad;
    await datos.guardar(incidencias);
  }

  Future<void> reiniciarDemo() async {
    await datos.restaurarDatosDeEjemplo();
    await iniciar();
  }
}
