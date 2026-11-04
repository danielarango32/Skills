---
name: roblox-luau-clean-code
description: 'Genera Luau tipado y limpio para Roblox (Clean Code): codigo de produccion + tests TestEZ + Gherkin BDD + verificacion de mutacion. Usar en ModuleScripts, servicios Knit, networking cliente-servidor o mecanicas de Roblox.'
---
# Roblox Luau Clean Code

## Reglas de Arquitectura
- Modo estricto (`--!strict`) y tipado explicito siempre.
- Nunca confiar en el cliente: valida en servidor todo argumento de `RemoteEvent`/`RemoteFunction`.
- Gestiona ciclo de vida de eventos/instancias con `Janitor` o `Maid` para evitar memory leaks.

## Entregables
1. **Codigo Luau**: modular, tipado, organizado en servicios.
2. **Tests TestEZ (`.spec.lua`)**: `describe`/`it`/`expect`, rutas felices y limites.
3. **Gherkin (`.feature`)**: transacciones, fisicas, interacciones.
4. **QA y Mutacion**: desvinculacion de eventos, limites, hipotesis de mutacion.
