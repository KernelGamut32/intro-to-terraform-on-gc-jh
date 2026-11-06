# What-if: CR-2052 follow-up asks for a third instance. Plan only.
#   terraform plan -var-file=../L04-collections-and-lifecycle/what-if/add-report.tfvars
instances = {
  api = {
    machine_type = "e2-micro"
    zone         = "us-central1-a"
    labels       = { tier = "service" }
  }
  batch = {
    machine_type = "e2-micro"
    zone         = "us-central1-b"
    labels       = { tier = "jobs", schedule = "nightly" }
  }
  report = {
    machine_type = "e2-micro"
    zone         = "us-central1-a"
    labels       = { tier = "jobs", schedule = "monthly" }
  }
}
