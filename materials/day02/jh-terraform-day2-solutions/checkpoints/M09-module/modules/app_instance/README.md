# app_instance

Creates one ledgerlite application instance on Compute Engine: no external IP
address, a boot disk from the image the caller selects, the runtime service
account the caller supplies, and a startup page rendered from this module's
template.

Owner: Platform Services (fictional team for the course scenario).

## Usage

```hcl
module "app" {
  source = "./modules/app_instance"

  name                  = "ledgerlite-app"
  zone                  = "us-central1-a"
  subnetwork            = google_compute_subnetwork.app.id
  boot_image            = data.google_compute_image.app.self_link
  service_account_email = "ledgerlite-app@jh-tf-lab-07.iam.gserviceaccount.com"
  network_tags          = ["ledgerlite-app"]
  labels                = { app = "ledgerlite", environment = "dev" }

  app = {
    name        = "ledgerlite"
    port        = 8080
    version     = "1.0.0"
    environment = "dev"
    team        = "platform-services"
  }
}
```

A runnable example is in `examples/basic/`.

## Inputs

| Name | Type | Default | Required | Description |
| --- | --- | --- | --- | --- |
| `name` | `string` | none | yes | Instance name, unique within the project and zone |
| `zone` | `string` | none | yes | Zone for the instance, in the same region as the subnetwork |
| `subnetwork` | `string` | none | yes | ID or self link of the subnetwork |
| `boot_image` | `string` | none | yes | Self link of the boot image |
| `service_account_email` | `string` | none | yes | Runtime service account attached to the instance |
| `app` | `object({ name, port, version, environment, team })` | none | yes | Application settings rendered into the startup page |
| `machine_type` | `string` | `"e2-small"` | no | One of `e2-micro`, `e2-small`, `e2-medium` |
| `network_tags` | `list(string)` | `[]` | no | Network tags; firewall rules select instances by tag |
| `labels` | `map(string)` | `{}` | no | Labels applied to the instance |

## Outputs

| Name | Description |
| --- | --- |
| `instance_name` | Name of the instance |
| `instance_zone` | Zone of the instance |
| `instance_id` | Server-assigned numeric ID |
| `internal_ip` | Internal IP address |
| `machine_type` | Machine type |
| `self_link` | Self link of the instance |

## Behavior to know before you change an input

| Change | Effect on the instance |
| --- | --- |
| `labels` | Updated in place |
| `network_tags` | Updated in place |
| `machine_type` | Updated in place, but the provider must stop the instance; the apply fails unless stopping is allowed |
| `name`, `zone`, `boot_image` | Forces replacement |
| Anything in `app` | Changes the rendered startup script, which forces replacement |

## What this module does not do

- It does not configure a provider or a backend. The calling root module does.
- It does not create networks, subnets, or firewall rules.
- It does not choose the image. Image selection is an environment decision.

## Requirements

Terraform 1.11 or later and the `hashicorp/google` provider 8.0 or later.
