#!/usr/bin/env bash
# Instala o actualiza las skills personales para Gemini CLI y Antigravity (macOS / Linux).
#   - Gemini CLI lee   ~/.gemini/skills
#   - Antigravity lee  ~/.gemini/config/skills  -> enlace simbolico a ~/.gemini/skills
# Las carpetas previas se mueven a ~/.gemini/backups/ (nunca se borran).
#
# Uso:
#   git clone https://github.com/<usuario>/gemini-skills.git ~/.gemini/skills
#   bash ~/.gemini/skills/install.sh
set -euo pipefail

GEMINI_DIR="$HOME/.gemini"
SKILLS_DIR="$GEMINI_DIR/skills"
AGY_CONFIG="$GEMINI_DIR/config"
AGY_SKILLS="$AGY_CONFIG/skills"
BACKUP_DIR="$GEMINI_DIR/backups"
STAMP="$(date +%Y%m%d-%H%M%S)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_URL="${1:-}"

backup() {
  mkdir -p "$BACKUP_DIR"
  mv "$1" "$BACKUP_DIR/$2-$STAMP"
  echo "    Copia de seguridad: $BACKUP_DIR/$2-$STAMP"
}

command -v git >/dev/null || { echo "Git no esta instalado." >&2; exit 1; }

if [[ -z "$REPO_URL" && -d "$SCRIPT_DIR/.git" ]]; then
  REPO_URL="$(git -C "$SCRIPT_DIR" remote get-url origin 2>/dev/null || true)"
fi

mkdir -p "$GEMINI_DIR" "$AGY_CONFIG"

echo "==> Skills de Gemini CLI en $SKILLS_DIR"
if [[ -d "$SKILLS_DIR/.git" ]]; then
  git -C "$SKILLS_DIR" pull --ff-only
else
  [[ -n "$REPO_URL" ]] || { echo "Falta la URL: bash install.sh https://github.com/<usuario>/gemini-skills.git" >&2; exit 1; }
  [[ -e "$SKILLS_DIR" ]] && backup "$SKILLS_DIR" gemini-skills
  git clone "$REPO_URL" "$SKILLS_DIR"
fi

echo "==> Skills de Antigravity en $AGY_SKILLS"
if [[ -L "$AGY_SKILLS" ]]; then
  if [[ "$(readlink "$AGY_SKILLS")" == "$SKILLS_DIR" ]]; then
    echo "    El enlace ya existe."
  else
    rm "$AGY_SKILLS"
    ln -s "$SKILLS_DIR" "$AGY_SKILLS"
    echo "    Enlace actualizado."
  fi
else
  [[ -e "$AGY_SKILLS" ]] && backup "$AGY_SKILLS" antigravity-skills
  ln -s "$SKILLS_DIR" "$AGY_SKILLS"
  echo "    Enlace creado: $AGY_SKILLS -> $SKILLS_DIR"
fi

echo
echo "Listo. Reinicia Antigravity y Gemini CLI para que detecten las skills."
