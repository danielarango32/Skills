---
name: uefn-verse-clean-code
description: 'Genera Verse modular y confiable para UEFN (Clean Code): codigo + arnes de pruebas + Gherkin BDD + plan QA/mutacion. Usar en dispositivos creativos, rondas, puntuacion o flujos asincronos de UEFN.'
---
# UEFN Verse Clean Code

## Reglas de Arquitectura
- Prioriza inmutabilidad y funciones puras.
- Usa contextos de fallo explicitos (`<decides>`, `<transacts>`) y concurrencia estructurada (`sync`, `race`, `branch`).
- Desacopla logica matematica/reglas de juego de las referencias directas a dispositivos.

## Entregables
1. **Codigo Verse**: modulos tipados con especificadores de efectos limpios.
2. **Arnes de Pruebas**: verificacion automatizada de estados y transiciones.
3. **Gherkin**: BDD sobre victoria, eliminaciones, eventos.
4. **QA y Mutacion**: condiciones de carrera, mutacion de operadores de decision.
