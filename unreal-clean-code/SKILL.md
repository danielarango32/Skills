---
name: unreal-clean-code
description: 'Genera C++ robusto y performante para Unreal (Clean Code): codigo + Automation Tests/Catch2 + Gherkin + analisis de mutacion. Usar en Gameplay Framework, Subsystems, GAS o mecanicas de Unreal.'
---
# Unreal Clean Code

## Reglas de Arquitectura
- `AActor` delgados; delega logica a `UActorComponent`/`USubsystem`.
- Respeta convenciones de nombres (A, U, F, I, E, T) y `const` correctness.
- Protege memoria con `UPROPERTY()`, `TSharedPtr`/`TWeakObjectPtr`.

## Entregables
1. **Codigo C++** (.h/.cpp): interfaz e implementacion separadas.
2. **Automation Tests**: `IMPLEMENT_SIMPLE_AUTOMATION_TEST` o Automation Framework.
3. **Gherkin**: comportamiento de gameplay y replicacion.
4. **QA y Mutacion**: fugas de memoria, punteros nulos, mutacion.
