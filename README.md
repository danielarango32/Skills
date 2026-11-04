# Skills personales — Gemini CLI + Antigravity

Esta carpeta es la **fuente única** de mis skills. Vive en `~/.gemini/skills` (donde las lee **Gemini CLI**) y `~/.gemini/config/skills` es un enlace a ella (donde las lee **Antigravity**). Así ambas herramientas usan las mismas skills, sin duplicados.

## Equipo nuevo (Windows)

Requisito: Git (`winget install --id Git.Git -e`). La primera vez, Git abrirá el navegador para iniciar sesión en GitHub.

```powershell
git clone https://github.com/<usuario>/gemini-skills.git "$HOME\.gemini\skills"
powershell -ExecutionPolicy Bypass -File "$HOME\.gemini\skills\install.ps1" -AutoUpdate
```

Si `~/.gemini/skills` ya existía, clona en otra carpeta y ejecuta el script desde ahí; él mueve la carpeta vieja a `~/.gemini/backups/` y clona en el sitio correcto:

```powershell
git clone https://github.com/<usuario>/gemini-skills.git "$env:TEMP\gemini-skills"
powershell -ExecutionPolicy Bypass -File "$env:TEMP\gemini-skills\install.ps1" -AutoUpdate
```

`-AutoUpdate` hace `git pull` automáticamente cada vez que inicias sesión en Windows.

## Equipo nuevo (macOS / Linux)

```bash
git clone https://github.com/<usuario>/gemini-skills.git ~/.gemini/skills
bash ~/.gemini/skills/install.sh
```

## Después de crear o editar una skill

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\.gemini\skills\sync.ps1" -Message "Describe el cambio"
```

## Estructura

Cada skill es una carpeta con un `SKILL.md` (frontmatter `name` y `description`) más recursos opcionales. Los archivos de la raíz (`install.*`, `sync.ps1`, este README) no son skills y las herramientas los ignoran.
