# Telematics Platform Architecture

## Environment Strategy

### DEV
Purpose:
- Low-cost testing
- Developer validation

Cluster:
- Telematics_Dev_AKS

Sizing:
- Small
- Single nodepool

### STAGE
Purpose:
- Production-like validation

Cluster:
- Telematics_Stage_AKS

Sizing:
- Mirrors current production architecture

## Shared Resources

- Azure Container Registry
- Key Vault (Dev)
- Key Vault (Stage)

## Kubernetes

Ingress:
- ingress-nginx

SSL:
- cert-manager

Redis:
- Environment-specific deployment