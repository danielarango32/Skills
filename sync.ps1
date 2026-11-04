<#
.SYNOPSIS
  Sube a GitHub los cambios hechos en las skills y descarga los de otros equipos.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File "$HOME\.gemini\skills\sync.ps1" -Message "Nueva skill de Godot"
#>
[CmdletBinding()]
param(
    [string]$Message = "Actualizar skills desde $env:COMPUTERNAME"
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot

git -C $repo add -A
git -C $repo diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git -C $repo commit -m $Message
    if ($LASTEXITCODE -ne 0) { throw 'git commit fallo.' }
}

git -C $repo pull --rebase
if ($LASTEXITCODE -ne 0) { throw 'git pull --rebase fallo. Resuelve los conflictos y vuelve a ejecutar.' }

git -C $repo push
if ($LASTEXITCODE -ne 0) { throw 'git push fallo.' }

Write-Host 'Skills sincronizadas.' -ForegroundColor Green
