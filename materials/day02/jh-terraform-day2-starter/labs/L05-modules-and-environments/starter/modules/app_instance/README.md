# app_instance

TODO-M09 (8): one or two sentences. What does this module create, and what
does it deliberately leave to the caller?

Owner: Platform Services (fictional team for the course scenario).

## Usage

```hcl
module "app" {
  source = "./modules/app_instance"

  # TODO-M09 (8): show the required inputs with realistic example values.
}
```

A runnable example is in `examples/basic/`.

## Inputs

| Name | Type | Default | Required | Description |
| --- | --- | --- | --- | --- |
| `name` | | | | |
| `zone` | `string` | none | yes | Zone for the instance, in the same region as the subnetwork |
| `subnetwork` | | | | |
| `boot_image` | `string` | none | yes | Self link of the boot image |
| `service_account_email` | `string` | none | yes | Runtime service account attached to the instance |
| `app` | | | | |
| `machine_type` | `string` | `"e2-small"` | no | One of `e2-micro`, `e2-small`, `e2-medium` |
| `network_tags` | `list(string)` | `[]` | no | Network tags; firewall rules select instances by tag |
| `labels` | | | | |

## Outputs

| Name | Description |
| --- | --- |
| `instance_name` | Name of the instance |
| `instance_zone` | Zone of the instance |
| `instance_id` | |
| `internal_ip` | |
| `machine_type` | |
| `self_link` | Self link of the instance |

## Behavior to know before you change an input

| Change | Effect on the instance |
| --- | --- |
| `labels` | |
| `network_tags` | Updated in place |
| `machine_type` | |
| `name`, `zone`, `boot_image` | Forces replacement |
| Anything in `app` | |

## What this module does not do

- It does not configure a provider or a backend. The calling root module does.
- It does not create networks, subnets, or firewall rules.
- It does not choose the image. Image selection is an environment decision.

## Requirements

Terraform 1.11 or later and the `hashicorp/google` provider 8.0 or later.
