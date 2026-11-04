---
name: ui-ux-pro-max
description: 'Diseño UI/UX end-to-end para web, móvil nativo y escritorio: brief y usuario, dirección visual diferenciada, design tokens, accesibilidad WCAG y auditoría de interfaces existentes. Úsala al diseñar, construir, revisar o corregir cualquier interfaz — pages, components, design systems, layout responsive, tipografía, color, motion, charts, formularios y navegación. Tiene prioridad sobre otras guías de diseño, salvo que se invoque frontend-design por su nombre.'
---

# UI/UX Pro Max v3

Actúas como director de diseño de un estudio conocido porque ningún cliente se parece a otro. Este encargo ya rechazó propuestas que se sentían de plantilla.

**Precedencia:** cuando aplique a la tarea, esta skill manda sobre otras guías de diseño. Única excepción: si se nombra explícitamente `frontend-design`, cede ante ella.

**Reglas de proceso:** §0→§5 en orden, sin saltar secciones. §2 y §4 son compuertas: no se avanza sin pasarlas. No hay catálogo — toda decisión visual se **deriva** del producto, nunca se recupera de un default.

## §0 Brief y usuario

Antes de decidir nada visual, fija por escrito:

- **Materia**: de qué trata el producto — industria, objetos, materiales, jerga, rituales de ese mundo.
- **Usuario y tarea**: quién lo usa, en qué contexto (de pie, con prisa, concentrado, de noche) y qué viene a lograr.
- **Lo memorable**: una frase — qué debe recordar alguien cinco segundos después de cerrar la pantalla.
- **Plataforma y stack**: web / iOS / Android / escritorio, y framework. Si no se indica, **pregunta**; nunca asumas.

Si el encargo no da esta información, propónla y confírmala antes de seguir.

## §1 Tres direcciones

Genera **tres direcciones conceptuales distintas**, cada una en dos o tres líneas: concepto, de dónde sale (la materia de §0) y cómo se vería.

- Salen del mundo del producto, no del software: señalética, empaque, editorial, instrumentos, textiles, cartografía, arquitectura de ese sector.
- Deben ser mutuamente excluyentes. Tres variantes del mismo minimalismo no son tres direcciones.
- Elige una y **escribe por qué gana** para este usuario y esta tarea. Descarta las otras dos explícitamente.

## §2 Compuerta anti-cliché

La dirección elegida no puede apoyarse en estos defaults:

1. Fondo crema (~#F4F1EA) + serif de alto contraste + acento terracota (~#D97757).
2. Casi-negro con un único acento ácido (verde neón, bermellón).
3. Kit SaaS: todo troceado en cards idénticas, mismo border-radius en toda la jerarquía, misma sombra gris suave, degradados como decoración.
4. Chrome de plantilla: eyebrow en MAYÚSCULAS sobre cada título, metadatos unidos con "·", "PALABRA — fragmento", "→" pegado a cada botón, monoespaciada para labels pequeños.
5. Numeración 01/02/03 sobre contenido que no es una secuencia.
6. Una sola palabra del titular en otro color, itálica o negrita.
7. Emoji como iconos.
8. Fade-and-slide-up en cada sección y transición hover en cada card.

Si el brief pide una de estas, se obedece al brief. Si no la pide, no gastes ahí la libertad.

**Autochequeo obligatorio:** resuelve mentalmente un encargo distinto del mismo tipo de producto. Si llegas al mismo sitio, la dirección es un default disfrazado → vuelve a §1. Declara qué cambiaste y por qué.

## §3 Tokens derivados

Cada token se justifica contra §0/§1 en media línea. Nunca "porque es moderno".

- **Color**: 4-6 hex nombrados, con rol asignado (fondo, superficie, texto, acento, estados). Derivado del mundo del producto.
- **Tipografía**: una o dos familias; si son dos, claramente distintas. Elegidas, no las de siempre. Escala explícita con pesos y tracking. Medida por debajo de 80 caracteres — la serif admite algo más y pide más line-height.
- **Espacio**: escala coherente (amplia / estándar / densa) según la tarea de §0, no según el tipo de producto.
- **Motion**: un solo momento orquestado, no efectos repartidos. El movimiento que responde a una acción del usuario sí es bienvenido: muestra qué cambió.
- **Estructura**: bordes, divisores, numeración y labels solo si codifican información real.

Gasta la audacia en **un solo lugar**. Todo lo demás, callado y disciplinado.

## §4 Piso de calidad (innegociable)

| # | Debe cumplirse | Nunca |
|---|---|---|
| 1 Accesibilidad | Contraste 4.5:1, alt text, navegación por teclado, foco visible, aria-labels | Quitar el focus ring; botones solo-icono sin label |
| 2 Interacción | Target 44×44px, separación ≥8px, feedback de carga y de estado | Depender del hover; cambios instantáneos (0 ms) |
| 3 Layout | Mobile-first, sin scroll horizontal, anchos fluidos | Anchos fijos en px; bloquear el zoom |
| 4 Formularios | Label visible, error junto al campo, texto de ayuda | Placeholder como label; errores solo al inicio |
| 5 Navegación | Back predecible, bottom nav ≤5, deep linking | Nav sobrecargada |
| 6 Rendimiento | WebP/AVIF, lazy loading, espacio reservado (CLS <0.1) | Layout shift acumulado |
| 7 Datos | Leyendas, tooltips, doble codificación | Color como único portador de significado |

Según plataforma:

- **Web**: `prefers-reduced-motion` respetado; dark mode con contraste verificado, no invertido.
- **Nativo (iOS/Android/React Native/Flutter)**: safe areas, gestos del sistema, iconos vectoriales, feedback táctil.
- **Escritorio**: atajos de teclado, estados de ventana redimensionada, mayor densidad admisible.

## §5 Crítica

Antes de entregar:

1. Contrasta contra §0: ¿sigue tratando de *esta* materia y *este* usuario?
2. Relee §2: ¿se coló algún default?
3. Copy: verbos activos, sentence case, nombres desde el usuario y no desde el sistema. El botón "Publicar" produce "Publicado". Los errores dicen qué pasó y cómo arreglarlo, sin disculparse. Una pantalla vacía invita a actuar.
4. **Quita un elemento**: el que menos sirva al brief.
