# What-if: the api instance is no longer needed. Plan only.
#   terraform plan -var-file=../L04-collections-and-lifecycle/what-if/remove-api.tfvars
instances = {
  batch = {
    machine_type = "e2-micro"
    zone         = "us-central1-b"
    labels       = { tier = "jobs", schedule = "nightly" }
  }
}
