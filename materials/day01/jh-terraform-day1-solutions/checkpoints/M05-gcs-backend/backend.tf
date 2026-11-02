# Added in L02 (M05). The bucket is created by the instructor's bootstrap
# script, outside this configuration, with Object Versioning enabled and
# access restricted to the lab identity.
#
# Backend blocks cannot use variables, so the values are literal. A team would
# typically keep this file per environment directory (dev/, test/) with a
# distinct prefix in each.

terraform {
  backend "gcs" {
    bucket = "jh-tf-state-lab-07-4f2a"
    prefix = "labs/lab-07"
  }
}
