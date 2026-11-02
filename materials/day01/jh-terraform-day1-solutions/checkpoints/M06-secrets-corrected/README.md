# Corrected design (L03 answer)

Review only. This directory shows the corrected shape of the flawed
configuration. It is not a drop-in for the L01 deployment; the L01 instance
already follows most of these practices.

What changed and why:

| Flaw | Correction |
| --- | --- |
| Service account key file referenced by the provider | Removed. The provider uses ADC; automation uses WIF. |
| Secret values as variable defaults and in `terraform.tfvars` | Removed. The configuration carries the secret **name** only. |
| `secret_data` persisted in state and plans | The secret is created and seeded outside this configuration, or seeded with `secret_data_wo` from an ephemeral variable (see D06). |
| Secret in instance metadata | Removed. The startup script reads the secret from Secret Manager using the attached runtime identity. |
| Outputs revealing the secret | Removed. `sensitive = true` only redacts display. |
| Runner as project Owner | Four narrow roles at the narrowest scope. |
| Runtime SA as project Editor | `roles/secretmanager.secretAccessor` on one secret. |
| Group with Storage Admin on the project | `roles/storage.objectAdmin` on the state bucket only. |
| External IP on the instance | Removed; access goes through IAP. |
