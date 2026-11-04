---
name: unity-clean-code
description: 'Genera C# limpio para Unity (Clean Code): codigo de produccion + tests NUnit/UTF + Gherkin BDD + verificacion de mutacion. Usar en scripts, MonoBehaviour, ScriptableObjects o sistemas de Unity.'
---
# Unity Clean Code

## Reglas de Arquitectura
- Desacopla logica pura de C# del ciclo de vida de `MonoBehaviour` (facilita pruebas unitarias).
- Aplica SRP y Dependency Inversion via interfaces/eventos.
- Evita `GetComponent` repetido en bucles; usa inyeccion de dependencias.

## Entregables
1. **Codigo C#**: limpio, tipado, documentado.
2. **Tests NUnit**: EditMode (calculos puros) + PlayMode (fisicas/corutinas).
3. **Gherkin**: `.feature` con `Given/When/Then`.
4. **QA y Mutacion**: ramas, valores limite, hipotesis de mutacion (ej. invertir booleanos).
