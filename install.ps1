<#
.SYNOPSIS
  Instala o actualiza las skills personales para Gemini CLI y Antigravity (Windows).

.DESCRIPTION
  - Gemini CLI lee las skills desde      ~/.gemini/skills
  - Antigravity lee las skills desde     ~/.gemini/config/skills
  Este script deja el repositorio clonado en ~/.gemini/skills (fuente unica de verdad)
  y crea un junction ~/.gemini/config/skills -> ~/.gemini/skills, de modo que ambas
  herramientas ven exactamente las mismas skills sin duplicarlas.
  Cualquier carpeta previa se mueve a ~/.gemini/backups/ (nunca se borra).

.PARAMETER RepoUrl
  URL del repositorio. Si se omite, se toma del 'origin' del repo donde vive este script.

.PARAMETER AutoUpdate
  Crea un acceso directo en Inicio de Windows que hace 'git pull' al iniciar sesion.

.EXAMPLE
  git clone https://github.com/<usuario>/gemini-skills.git "$HOME\.gemini\skills"
  powershell -ExecutionPolicy Bypass -File "$HOME\.gemini\skills\install.ps1" -AutoUpdate
#>
[CmdletBinding()]
param(
    [string]$RepoUrl,
    [switch]$AutoUpdate
)

$ErrorActionPreference = 'Stop'

$geminiDir   = Join-Path $HOME '.gemini'
$skillsDir   = Join-Path $geminiDir 'skills'
$agyConfig   = Join-Path $geminiDir 'config'
$agySkills   = Join-Path $agyConfig 'skills'
$backupDir   = Join-Path $geminiDir 'backups'
$stamp       = Get-Date -Format 'yyyyMMdd-HHmmss'

function Write-Step([string]$Message) { Write-Host "==> $Message" -ForegroundColor Cyan }

function Move-ToBackup([string]$Path, [string]$Label) {
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    $destination = Join-Path $backupDir "$Label-$stamp"
    Move-Item -LiteralPath $Path -Destination $destination
    Write-Host "    Copia de seguridad: $destination" -ForegroundColor Yellow
}

function Invoke-GitQuiet {
    # En PowerShell 5.1, redirigir stderr de un comando nativo con 'Stop' lanza excepcion.
    $ErrorActionPreference = 'Continue'
    & git @args 2>$null
}

function Get-NormalizedPath([string]$Path) {
    return [System.IO.Path]::GetFullPath($Path).TrimEnd('\')
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git no esta instalado. Instalalo con: winget install --id Git.Git -e  (y vuelve a abrir la terminal)'
}

if (-not $RepoUrl -and $PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot '.git'))) {
    $RepoUrl = (Invoke-GitQuiet -C $PSScriptRoot remote get-url origin)
}

New-Item -ItemType Directory -Force -Path $geminiDir, $agyConfig | Out-Null

# 1) Repositorio en ~/.gemini/skills (Gemini CLI)
Write-Step "Skills de Gemini CLI en $skillsDir"
if (Test-Path (Join-Path $skillsDir '.git')) {
    Invoke-GitQuiet -C $skillsDir rev-parse --abbrev-ref --symbolic-full-name '@{u}' | Out-Null
    if ($LASTEXITCODE -eq 0) {
        git -C $skillsDir pull --ff-only
        if ($LASTEXITCODE -ne 0) { throw 'git pull fallo. Revisa cambios locales con: git -C ~/.gemini/skills status' }
    } else {
        Write-Host '    El repo aun no tiene remoto configurado; se omite git pull.' -ForegroundColor Yellow
    }
} else {
    if (-not $RepoUrl) { throw 'No se encontro la URL del repo. Ejecuta: install.ps1 -RepoUrl https://github.com/<usuario>/gemini-skills.git' }
    if (Test-Path $skillsDir) { Move-ToBackup $skillsDir 'gemini-skills' }
    git clone $RepoUrl $skillsDir
    if ($LASTEXITCODE -ne 0) { throw "git clone fallo para $RepoUrl" }
}

# 2) Junction ~/.gemini/config/skills -> ~/.gemini/skills (Antigravity)
Write-Step "Skills de Antigravity en $agySkills"
$existing = Get-Item -LiteralPath $agySkills -Force -ErrorAction SilentlyContinue
$alreadyLinked = $false
if ($existing -and $existing.LinkType) {
    $currentTarget = @($existing.Target)[0]
    if ($currentTarget -and (Get-NormalizedPath $currentTarget) -eq (Get-NormalizedPath $skillsDir)) {
        $alreadyLinked = $true
    } else {
        # Delete() sin recursion elimina solo el enlace, nunca el contenido del destino.
        $existing.Delete()
    }
} elseif ($existing) {
    Move-ToBackup $agySkills 'antigravity-skills'
}

if ($alreadyLinked) {
    Write-Host '    El enlace ya existe.'
} else {
    New-Item -ItemType Junction -Path $agySkills -Target $skillsDir | Out-Null
    Write-Host "    Enlace creado: $agySkills -> $skillsDir"
}

# 3) Actualizacion automatica al iniciar sesion (opcional)
if ($AutoUpdate) {
    Write-Step 'Actualizacion automatica al iniciar sesion'
    $startup  = [Environment]::GetFolderPath('Startup')
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut((Join-Path $startup 'gemini-skills-sync.lnk'))
    $shortcut.TargetPath  = (Get-Command powershell.exe).Source
    $shortcut.Arguments   = "-NoProfile -WindowStyle Hidden -Command `"git -C '$skillsDir' pull --ff-only`""
    $shortcut.WindowStyle = 7
    $shortcut.Description = 'Sincroniza las skills de Gemini CLI y Antigravity'
    $shortcut.Save()
    Write-Host "    Acceso directo creado en: $startup"
}

$count = @(Get-ChildItem -Path $skillsDir -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }).Count
Write-Host ''
Write-Host "Listo: $count skills disponibles. Reinicia Antigravity y Gemini CLI para que las detecten." -ForegroundColor Green
