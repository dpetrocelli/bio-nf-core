#!/bin/bash
set -euo pipefail

NAMESPACE="vault"
RELEASE_NAME="vault"
VALUES_FILE="values-dev.yml"

echo "🚀 Installing Vault via Helm..."
helm repo add hashicorp https://helm.releases.hashicorp.com || true
helm repo update

if ! helm list -n $NAMESPACE | grep -q "$RELEASE_NAME"; then
  helm install $RELEASE_NAME hashicorp/vault -n $NAMESPACE --create-namespace -f $VALUES_FILE
else
  echo "⚠️ Vault already installed. Skipping install."
fi

echo "⏳ Waiting for Vault pod to enter 'Running' state..."
while true; do
  STATUS=$(kubectl get pod -n $NAMESPACE -l app.kubernetes.io/name=vault -o jsonpath="{.items[0].status.phase}")
  if [[ "$STATUS" == "Running" ]]; then
    echo " → Pod status: $STATUS"
    break
  fi
  sleep 2
done

POD_NAME=$(kubectl get pod -n $NAMESPACE -l app.kubernetes.io/name=vault -o jsonpath="{.items[0].metadata.name}")

echo "🔍 Checking Vault initialization status..."
if kubectl exec -n "$NAMESPACE" "$POD_NAME" -- env VAULT_ADDR=http://127.0.0.1:8200 vault status | grep -q 'Initialized.*true'; then
  echo "✅ Vault is already initialized. Skipping init."
else
  echo "🔐 Initializing Vault..."
  INIT_OUTPUT=$(kubectl exec -n "$NAMESPACE" "$POD_NAME" -- env VAULT_ADDR=http://127.0.0.1:8200 vault operator init -key-shares=5 -key-threshold=3 -format=json)
  echo "$INIT_OUTPUT" > vault-init.json
  echo "$INIT_OUTPUT" | jq -r '.root_token' > vault-root-token.txt
fi

if [ ! -f vault-init.json ]; then
  echo "❌ vault-init.json not found. Cannot unseal."
  exit 1
fi

echo "🔓 Unsealing Vault..."
for i in 0 1 2; do
  UNSEAL_KEY=$(jq -r ".unseal_keys_b64[$i]" vault-init.json)
  kubectl exec -n "$NAMESPACE" "$POD_NAME" -- env VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal "$UNSEAL_KEY"
done

echo "✅ Vault is now unsealed and ready."
