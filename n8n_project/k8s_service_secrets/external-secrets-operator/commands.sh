helm repo add external-secrets https://charts.external-secrets.io
helm repo update

helm install external-secrets external-secrets/external-secrets \
  --namespace external-secrets --create-namespace

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

vault kv put secret/hello password=sup3rs3cret