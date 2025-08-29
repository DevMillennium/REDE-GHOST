#!/bin/bash
# Backup de Resultados

BACKUP_DIR="~/bug_hunting/backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup de resultados
cp -r ~/bug_hunting/results/* "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.cache/bug_hunting/* "$BACKUP_DIR/" 2>/dev/null || true

# Backup de logs
cp *.log "$BACKUP_DIR/" 2>/dev/null || true
cp *.json "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ Backup criado em: $BACKUP_DIR"
