import 'package:flutter_test/flutter_test.dart';
import 'package:nexasoft_incidencias/model/incidencia.dart';
import 'package:nexasoft_incidencias/services/gestor_incidencias.dart';

void main() {
  late GestorIncidencias gestor;

  setUp(() {
    gestor = GestorIncidencias();
    gestor.incidencias = [
      Incidencia(
        id: 'INC-1',
        titulo: 'WiFi intermitente',
        descripcion: 'La red se desconecta.',
        cliente: 'Clínica del Prado',
        categoria: 'Redes',
        estado: 'En proceso',
        prioridad: 'Alta',
        fecha: '2026-10-01',
      ),
      Incidencia(
        id: 'INC-2',
        titulo: 'WiFi sin conexión',
        descripcion: 'No hay acceso a la red.',
        cliente: 'Grupo Loma',
        categoria: 'Redes',
        estado: 'Pendiente',
        prioridad: 'Baja',
        fecha: '2026-10-02',
      ),
      Incidencia(
        id: 'INC-3',
        titulo: 'Correo no disponible',
        descripcion: 'El servicio de correo está restablecido.',
        cliente: 'Almacenes del Centro',
        categoria: 'Software',
        estado: 'Resuelta',
        prioridad: 'Media',
        fecha: '2026-10-03',
      ),
    ];
  });

  test('combina búsqueda por texto, estado y prioridad', () {
    final resultados = gestor.buscar(
      'wifi',
      estado: 'En proceso',
      prioridad: 'Alta',
    );

    expect(resultados.map((incidencia) => incidencia.id), ['INC-1']);
  });

  test('devuelve coincidencias de texto que cumplen ambos filtros', () {
    final resultados = gestor.buscar(
      'WiFi',
      estado: 'Pendiente',
      prioridad: 'Baja',
    );

    expect(resultados.map((incidencia) => incidencia.id), ['INC-2']);
  });

  test('los filtros Todas conservan la búsqueda de texto', () {
    final resultados = gestor.buscar('WiFi');

    expect(resultados.map((incidencia) => incidencia.id), ['INC-1', 'INC-2']);
  });

  test('los filtros Todas sin texto devuelven todas las incidencias', () {
    expect(gestor.buscar('').length, 3);
  });
}
