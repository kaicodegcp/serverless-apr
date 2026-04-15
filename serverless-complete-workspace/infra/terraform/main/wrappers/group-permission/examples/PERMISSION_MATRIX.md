# Databricks Permission Matrix by Persona

## Object: Unity Catalog (catalog / schema / table)

| Permission | Workspace Admin/SP | Ops/Monitoring | Data Engineering | Analyst | Deployer/CI-CD |
|---|---|---|---|---|---|
| **Catalog** | ALL_PRIVILEGES | USE_CATALOG, BROWSE | USE_CATALOG, CREATE_SCHEMA | USE_CATALOG, BROWSE | USE_CATALOG, CREATE_SCHEMA |
| **Schema** | ALL_PRIVILEGES | USE_SCHEMA, SELECT | USE_SCHEMA, SELECT, MODIFY, CREATE_TABLE, CREATE_FUNCTION | USE_SCHEMA, SELECT | USE_SCHEMA, CREATE_TABLE, CREATE_FUNCTION, MODIFY |
| **Table** | ALL_PRIVILEGES | SELECT | SELECT, MODIFY | SELECT | SELECT, MODIFY |

## Object: Workspace-Level Resources (notebooks, queries, pipelines, warehouses, experiments)

| Permission Level | Workspace Admin/SP | Ops/Monitoring | Data Engineering | Analyst | Deployer/CI-CD |
|---|---|---|---|---|---|
| **Notebooks** | CAN_MANAGE | CAN_READ | CAN_RUN | CAN_READ | CAN_MANAGE |
| **SQL Queries** | CAN_MANAGE | CAN_VIEW | CAN_RUN | CAN_RUN | CAN_MANAGE |
| **Pipelines** | CAN_MANAGE | CAN_VIEW | CAN_RUN | CAN_VIEW | CAN_MANAGE |
| **SQL Warehouses** | CAN_MANAGE | CAN_MONITOR | CAN_USE | CAN_USE | CAN_MANAGE |
| **MLflow Experiments** | CAN_MANAGE | CAN_READ | CAN_EDIT | CAN_READ | CAN_MANAGE |

## Object: Account / Workspace Assignment

| Level | Workspace Admin/SP | Ops/Monitoring | Data Engineering | Analyst | Deployer/CI-CD |
|---|---|---|---|---|---|
| **Workspace Permission** | ADMIN | USER | USER | USER | USER |

## Notes

- `ALL_PRIVILEGES` grants full access including the ability to grant to others.
- `USE_CATALOG` / `USE_SCHEMA` are required for accessing child objects.
- `BROWSE` allows listing catalogs/schemas without accessing data.
- Workspace-level permissions (notebooks, queries, etc.) use `databricks_permissions` resource.
- UC-level permissions (catalog, schema, table) use `databricks_grant` resource.
- Account-level workspace assignment uses `databricks_mws_permission_assignment`.
- Some permission levels may not be directly supported on all objects.
  For example, `CAN_MONITOR` is specific to SQL warehouses.

## Mapping Persona Intents to Terraform

| Persona Intent | UC Grants | Workspace Permissions | Account Assignment |
|---|---|---|---|
| **Full Manage** | ALL_PRIVILEGES | CAN_MANAGE | ADMIN |
| **Read / View** | SELECT, USE_SCHEMA, USE_CATALOG, BROWSE | CAN_READ / CAN_VIEW | USER |
| **Run / Write** | SELECT, MODIFY, CREATE_TABLE | CAN_RUN / CAN_EDIT | USER |
| **Deploy / Automate** | CREATE_TABLE, CREATE_FUNCTION, MODIFY | CAN_MANAGE | USER |
