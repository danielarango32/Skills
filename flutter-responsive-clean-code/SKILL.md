---
name: flutter-responsive-clean-code
description: 'Genera Flutter/Dart de produccion responsive por defecto (movil, tablet/foldable, web, desktop) con un widget por archivo, Riverpod o BLoC/Cubit, Gherkin, widget tests y golden tests con aserciones anti-mutacion. Usar en pantallas, widgets, layouts o features de Flutter. Cuándo usarla: Features, pantallas y widgets de produccion. NO para prototipos, spikes o snippets sueltos de menos de 50 lineas.'
---

# Flutter Responsive Clean Code v1.0

**DIRECTIVA:** Todo widget generado es responsive y testeable. Un widget publico = un archivo. Siempre entregar los 4 bloques cuando aplique.

---

## 1. Filtro de aplicabilidad

**✅ GAUNTLET COMPLETO:** pantallas, widgets reutilizables, design system, estado/controllers, repositorios, routing, capa de datos.

**⚠️ ADAPTADO:** widgets puramente decorativos (sin logica → golden test + reglas responsive, sin Gherkin); extensiones/helpers (100% unit test, sin golden).

**❌ SIN GAUNTLET (explicar por que):** prototipos, `main.dart` de arranque, scripts de build, archivos generados (`*.g.dart`, `*.freezed.dart`), ejercicios de aprendizaje.

---

## 2. Estructura de archivos (obligatoria)

Feature-first, **un widget publico por archivo**, nombre de archivo = `snake_case` del widget:

```
lib/src/
  core/responsive/breakpoints.dart        # WindowSize + umbrales
  core/responsive/responsive_layout.dart  # builder compact/medium/expanded
  features/<feature>/
    domain/<entity>.dart
    application/<feature>_controller.dart | <feature>_bloc.dart
    presentation/<feature>_screen.dart
    presentation/widgets/<widget>.dart    # 1 archivo por widget
test/features/<feature>/...               # espeja lib/
test/goldens/<widget>_<window_size>.png
```

Reglas: nada de widgets anidados en el mismo archivo salvo helpers privados (`_Foo`) usados solo ahi y ≤2 por archivo. **Prohibido** `Widget _buildX()` como metodo: extraer a widget con `const` constructor. Exportar por barrel solo a nivel de feature.

---

## 3. Reglas responsive (no negociables)

**Breakpoints** (Material 3 window size classes): compact `<600` · medium `600–839` · expanded `840–1199` · large `≥1200`. Definidos como constantes en `breakpoints.dart`, nunca literales en la UI.

1. **Sin tamaños fijos.** Nada de `width: 320`. Usar `Expanded`/`Flexible`, `FractionallySizedBox`, `AspectRatio`, `ConstrainedBox`. `SizedBox` solo para spacing tokenizado.
2. **Constraints locales > tamaño de pantalla.** Dentro de un widget hijo usar `LayoutBuilder`; `MediaQuery.sizeOf(context)` solo en el scaffold/shell.
3. **Nunca `MediaQuery.of(context)` completo.** Usar los accessors granulares: `sizeOf`, `textScalerOf`, `viewInsetsOf`, `paddingOf`, `platformBrightnessOf` (evita rebuilds innecesarios).
4. **Texto escalable.** Sin contenedores de alto fijo alrededor de texto; layout valido hasta `TextScaler.linear(2.0)`. `maxLines` + `overflow` explicitos. `FittedBox` solo para numeros/badges.
5. **Navegacion adaptativa.** `NavigationBar` (compact) → `NavigationRail` (medium/expanded) → `NavigationDrawer` (large). Un solo widget de contenido compartido.
6. **Ancho maximo de contenido** en web/desktop (`ConstrainedBox(maxWidth: 1200)` centrado) para evitar lineas de texto ilegibles.
7. **Foldables:** leer `MediaQuery.of(context).displayFeatures` y evitar dibujar contenido critico sobre la bisagra en layouts de dos paneles.
8. **Teclado y notch:** `SafeArea` en bordes de pantalla + `viewInsetsOf(context).bottom` para formularios; scroll obligatorio en cualquier columna de inputs.
9. **Input por plataforma:** touch target ≥48dp en movil, ≥24dp con puntero; estados hover/focus y atajos (`Shortcuts`/`Actions`) en web y desktop. `defaultTargetPlatform`/`kIsWeb`, nunca `dart:io Platform` en codigo compartido.
10. **Listas y scroll:** `ListView.builder`/slivers (`CustomScrollView`); prohibido `shrinkWrap: true` dentro de otro scroll. Grids con `SliverGridDelegateWithMaxCrossAxisExtent`, no con `crossAxisCount` fijo.
11. **Imagenes:** `cacheWidth`/`cacheHeight` derivados de constraints y `MediaQuery.devicePixelRatioOf`.
12. **Orientacion:** solo con `OrientationBuilder` cuando el layout cambia de verdad; si no, el breakpoint basta.

---

## 4. Estado y arquitectura

Detectar el paquete del proyecto (`pubspec.yaml`); si no existe, preguntar una vez y por defecto Riverpod.

**Riverpod (2.x/3.x):** `ConsumerWidget`/`ConsumerStatefulWidget`; `ref.watch` solo para datos que pintan, `ref.read` en callbacks; estado async con `AsyncValue` y `when(data/loading/error)`. Providers generados o `NotifierProvider`; nunca logica en `build`.

**BLoC/Cubit:** eventos y estados inmutables (`Equatable`/`freezed`); `BlocBuilder` con `buildWhen`, `BlocListener` para side effects; `context.read<X>()` en callbacks. Un bloc por feature, sin dependencias de Flutter dentro del bloc.

**Comun:** widgets sin I/O ni logica de negocio, inyeccion por constructor/provider, `const` en todo constructor posible, `dispose` de controllers, errores tipados (no `catch (e)` generico).

---

## 5. Formato de salida obligatorio

### [GHERKIN]
Minimo 4 escenarios: happy path, breakpoint compact, breakpoint expanded, error/estado vacio.
```gherkin
Feature: <feature>
  Scenario: Layout compacto en movil
    Given una pantalla de 375 px de ancho
    When se renderiza <Widget>
    Then se muestra la version de una columna con NavigationBar
```

### [ARCHIVOS]
Arbol de los archivos creados/modificados con una linea de proposito cada uno.

### [CODE]
Codigo por archivo, en bloques separados con la ruta como titulo. Clean Code: nombres reveladores, funciones de responsabilidad unica, sin numeros magicos, complejidad ciclomatica ≤3, validacion en los bordes, `analysis_options.yaml` estricto (`flutter_lints` + `prefer_const_constructors`, `avoid_print`).

### [TESTS]
- **Widget tests por breakpoint:** 360, 600, 840 y 1280 px usando `tester.view.physicalSize` + `addTearDown(tester.view.reset)`.
- **Golden tests:** uno por window size class relevante.
- **Anti-mutacion:** el borde exacto del breakpoint (`599.9` vs `600`) falla si `<` muta a `<=`; constantes de breakpoint verificadas por valor; operadores de calculo de columnas probados en ambos lados.
- **Accesibilidad:** test con `TextScaler.linear(2.0)` sin overflow (`expect(tester.takeException(), isNull)`), semantics labels presentes.
- **Estado:** 100% de cobertura en controller/bloc (happy, loading, error, transiciones), sin interdependencia entre tests.
- Cobertura objetivo: 100% logica y estado · 90% widgets · golden por breakpoint.

---

## 6. Ejemplo minimo verificable

```dart
// lib/src/core/responsive/breakpoints.dart
enum WindowSize { compact, medium, expanded, large }

abstract final class Breakpoints {
  static const double medium = 600;
  static const double expanded = 840;
  static const double large = 1200;

  static WindowSize of(double width) {
    if (width < medium) return WindowSize.compact;
    if (width < expanded) return WindowSize.medium;
    if (width < large) return WindowSize.expanded;
    return WindowSize.large;
  }
}
```

```dart
// test/core/responsive/breakpoints_test.dart
void main() {
  test('limite exacto compact/medium', () {
    expect(Breakpoints.of(599.9), WindowSize.compact);
    expect(Breakpoints.of(600), WindowSize.medium); // falla si < muta a <=
  });
}
```

```dart
// test/support/pump_at_width.dart
Future<void> pumpAtWidth(WidgetTester tester, double width, Widget child) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = Size(width, 900);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pumpAndSettle();
}
```

---

## 7. Verificacion antes de responder

Con CLI disponible: `dart analyze` + `flutter test --coverage` y reportar `[✓ N tests | ✓ X% cobertura | ✓ 0 issues]`. Sin CLI: recorrer mentalmente cada `build`, verificar que ningun widget dependa de tamaños fijos y marcar dudas como `[⚠ verificar: ...]`.

**Checklist:** un widget publico por archivo · 0 valores fijos de layout · `MediaQuery` granular · breakpoints desde constantes · texto a 2.0x sin overflow · navegacion adaptativa · `const` donde aplica · 4 bloques presentes · tests en los 4 anchos · aserciones de borde anti-mutacion · sin `shrinkWrap` anidado.
