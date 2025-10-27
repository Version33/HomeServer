#!/usr/bin/env bash
# Diagnostic script for Incus container issues

echo "=== VM Disk Space ==="
df -h /
echo ""

echo "=== Container Storage Pool ==="
df -h /var/lib/incus/storage-pools/default
echo ""

echo "=== Jellyfin Config Volume ==="
df -h /var/lib/incus-containers/jellyfin/config
echo ""

echo "=== Container List ==="
incus list
echo ""

echo "=== Jellyfin Container Config ==="
incus config show jellyfin
echo ""

echo "=== Jellyfin Container Disk Devices ==="
incus config device show jellyfin
echo ""

echo "=== Jellyfin Container Disk Usage (inside container) ==="
incus exec jellyfin -- df -h
echo ""

echo "=== Jellyfin Logs (last 20 lines) ==="
incus exec jellyfin -- tail -20 /config/log/log_*.log 2>/dev/null || echo "No logs found"
