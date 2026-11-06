# Distinct state location for the second placement. Same bucket as the
# primary root, different prefix. Backend blocks cannot use variables, so
# the values are literal.

terraform {
  backend "gcs" {
    bucket = "jh-tf-state-lab-07-4f2a"
    prefix = "labs/lab-07/us-east1"
  }
}
