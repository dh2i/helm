# DH2i SQL Server Combined Image

This chart deploys a SQL Server availability group managed by DxEnterprise clustering technology. 

## Prerequisites

- A secret on your Kubernetes cluster that contains SQL Server credentials (MSSQL_SA_PASSWORD) and your DxEnterprise cluster password (DX_PASSKEY)
- A DxEnterprise license key
- A built [DxE + MSSQL combined container image](https://support.dh2i.com/docs/v22.0/guides/dxenterprise/containers/building-dxemssql-qsg) pushed to a repository of your choice.