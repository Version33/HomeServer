#!/usr/bin/env bash
# Test connectivity to Jellyfin at each layer

echo "=== 1. Test Jellyfin inside its container ==="
incus exec jellyfin -- curl -v http://localhost:8096 2>&1 | head -20
echo ""

echo "=== 2. Test from VM to Jellyfin container IP ==="
curl -v http://10.0.100.12:8096 2>&1 | head -20
echo ""

echo "=== 3. Test Caddy proxy to Jellyfin ==="
curl -v -H "Host: jellyfin.local" http://localhost:80 2>&1 | head -20
echo ""

echo "=== 4. Check Caddy service status ==="
systemctl status caddy --no-pager
echo ""

echo "=== 5. Check Caddy is listening on port 80 ==="
ss -tulpn | grep -E ':(80|443)'
echo ""

echo "=== 6. Check Caddy logs ==="
journalctl -u caddy -n 30 --no-pager
echo ""

echo "=== 7. List all running containers ==="
incus list
echo ""

echo "=== 8. Check if Jellyfin process is running ==="
incus exec jellyfin -- ps aux | grep jellyfin
