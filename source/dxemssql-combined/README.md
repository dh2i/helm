# DH2i SQL Server Combined Image

This chart deploys a SQL Server availability group managed by DxEnterprise clustering technology. 

## Prerequisites

- A secret on your Kubernetes cluster that contains SQL Server credentials (MSSQL_SA_PASSWORD) and your DxEnterprise cluster password (DX_PASSKEY)
- A DxEnterprise license key with availability group management features and tunnels enabled
- A built [DxE + MSSQL combined container image](https://support.dh2i.com/docs/v22.0/guides/dxenterprise/containers/building-dxemssql-qsg) pushed to a repository of your choice.
- Optional: DxAdmin installed on a Windows machine. Installation instructions for DxAdmin can be found in [DH2i documentation](https://support.dh2i.com/docs/v22.0/guides/dxenterprise/installation/dxadmin-qsg)

# Additional Information

Before creating an availability group, reference SQL Server's [quorum considerations](https://support.dh2i.com/docs/kbs/sql_server/availability_groups/quorum-considerations-for-sql-server-availability-groups) when determining the quantity of replicas to deploy.