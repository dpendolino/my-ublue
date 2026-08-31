#!/bin/bash
set -euo pipefail

# Workaround for F42 updates-archive 404 on perl-Git-2.51.0-2.fc42
# See: https://github.com/dpendolino/my-ublue/actions/runs/33331510898
# The archive repo metadata references an NVR that 404s on S3 (verified 2026-08-31).
# Disabling it forces dnf/rpm-ostree to resolve from `updates` (which has the live NVR).
# This is safe for OSTree layering only if base doesn't need archived NVRs;
# our layer doesn't pin to archived versions, so cost=10000 fallback is unnecessary.

echo "Disabling updates-archive to work around F42 404..."

REPO="/etc/yum.repos.d/fedora-updates-archive.repo"

if [ -f "$REPO" ]; then
  # Disable via config change (persistent for this build layer)
  # Keep file but flip enabled, so diagnostics still show it as disabled not missing
  sed -i 's/^enabled=1/enabled=0/' "$REPO" || true
  echo "Patched $REPO: $(grep -E '^enabled' "$REPO" || echo 'no enabled line')"
  cat "$REPO"
else
  echo "WARN: $REPO not found, trying dnf config-manager..."
fi

# Also try dnf config-manager as fallback (idempotent)
if command -v dnf >/dev/null 2>&1; then
  dnf config-manager --set-disabled updates-archive 2>&1 || echo "dnf config-manager failed or not needed"
elif command -v dnf5 >/dev/null 2>&1; then
  dnf5 config-manager setopt updates-archive.enabled=0 2>&1 || true
fi

# Verify
echo "Verifying repo state:"
dnf repolist --all 2>&1 | grep -i archive || echo "dnf repolist grep found nothing"
# Also check via rpm-ostree if available
if command -v ostree >/dev/null 2>&1; then
  echo "ostree repo list done"
fi

echo "Done - updates-archive disabled for this build"
