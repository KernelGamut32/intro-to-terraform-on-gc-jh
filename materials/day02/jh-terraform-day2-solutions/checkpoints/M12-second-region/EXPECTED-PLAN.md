# Expected results: L07 (M12)

All output is representative. Identifiers and hidden-attribute counts vary.

## Initialization

```
$ terraform init

Initializing the backend...

Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing modules...
- app in ../L01-build-and-parameterize/modules/app_instance
Initializing provider plugins...
- Reusing previous version of hashicorp/google from the dependency lock file
- Installing hashicorp/google v8.10.0...
- Installed hashicorp/google v8.10.0 (signed by HashiCorp)

Terraform has been successfully initialized!
```

The version shown is the one recorded in the lock file copied from the
primary root, so both roots run the same provider release. Without the
copy, init prints `Finding hashicorp/google versions matching ...` with
both requirements combined (`~> 8.0` from this root and `>= 8.0` from the
module) and selects the newest 8.x release, which may be newer than the
one the primary root uses.

```
$ jq '.backend.config | {bucket, prefix}' .terraform/terraform.tfstate
{
  "bucket": "jh-tf-state-lab-07-4f2a",
  "prefix": "labs/lab-07/us-east1"
}
```

## The reviewed plan

```
$ terraform plan -out=region2.tfplan

data.terraform_remote_state.primary: Reading...
data.google_compute_image.app: Reading...
data.terraform_remote_state.primary: Read complete after 1s
data.google_compute_image.app: Read complete after 1s [id=projects/debian-cloud/global/images/debian-13-trixie-v20261014]

  # google_compute_subnetwork.app will be created
  + resource "google_compute_subnetwork" "app" {
      + ip_cidr_range            = "10.20.0.0/24"
      + name                     = "ledgerlite-subnet-us-east1"
      + network                  = "projects/jh-tf-lab-07/global/networks/ledgerlite-vpc"
      + private_ip_google_access = true
      + region                   = "us-east1"
        # (other attributes, many known after apply)
    }

  # module.app.google_compute_instance.this will be created
  + resource "google_compute_instance" "this" {
      + machine_type = "e2-small"
      + name         = "ledgerlite-app-us-east1"
      + zone         = "us-east1-b"
      + labels       = {
          + "app"         = "ledgerlite"
          + "cost_center" = "cc-4477"
          + "environment" = "dev"
          + "managed_by"  = "terraform"
          + "placement"   = "us-east1"
          + "team"        = "platform-services"
        }
      + tags         = [
          + "ledgerlite-app",
        ]
        # (other attributes, many known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

No network and no firewall rule is created. Both are global, both belong to
the primary root, and both already cover an instance with the
`ledgerlite-app` tag in any region of the VPC.

## Plan as data

```
$ ../../scripts/plan-summary.sh region2.tfplan
Plan summary for region2.tfplan
Workspace: default

ACTION  ADDRESS                                  LOCATION    NOTE
create  google_compute_subnetwork.app            us-east1
create  module.app.google_compute_instance.this  us-east1-b

Totals: 2 to add, 0 to change, 0 to destroy, 0 to replace, 0 to import, 0 moved
```

## The primary deployment is untouched

```
$ cd ../L01-build-and-parameterize
$ terraform plan
No changes. Your infrastructure matches the configuration.
```

## The guardrail

```
$ terraform plan -var region=us-central1 -var zone=us-central1-a

Error: Resource precondition failed

  on main.tf line NN, in resource "google_compute_subnetwork" "app":
  NN:       condition     = var.region != local.primary_region
    |----------------
    | local.primary_region is "us-central1"
    | var.region is "us-central1"

The second placement must use a different region from the primary
deployment.
```

## Optional extension: apply

```
$ terraform apply region2.tfplan

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

app_port = 8080
instance_name = "ledgerlite-app-us-east1"
instance_zone = "us-east1-b"
internal_ip = "10.20.0.2"
inventory = {
  ...
}
project_id = "jh-tf-lab-07"
shared_network = "ledgerlite-vpc"
subnet_name = "ledgerlite-subnet-us-east1"
tunnel_command = "gcloud compute start-iap-tunnel ledgerlite-app-us-east1 8080 --local-host-port=localhost:8080 --zone us-east1-b --project jh-tf-lab-07"
```

```
$ gcloud storage ls gs://jh-tf-state-lab-07-4f2a/labs/lab-07/
gs://jh-tf-state-lab-07-4f2a/labs/lab-07/default.tfstate
gs://jh-tf-state-lab-07-4f2a/labs/lab-07/us-east1/
```

Two roots, two states, one shared network: the primary state object, and
the `us-east1/` prefix that holds the second root's `default.tfstate`. Open the tunnel with
`terraform output -raw tunnel_command`; the page reports zone `us-east1-b`.

Before leaving, unless the instructor asks you to keep it:

```
$ terraform plan -destroy -out=destroy.tfplan
Plan: 0 to add, 0 to change, 2 to destroy.
$ terraform apply destroy.tfplan
```
