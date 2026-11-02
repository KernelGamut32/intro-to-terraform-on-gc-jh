# L03: Review secrets and IAM (M06)

**Do not apply anything in this directory.** The `flawed/` configuration is a
sanitized review exercise. Every secret value in it is synthetic.

Your tasks, in order:

1. Read `flawed/` and `flawed/permissions.md`. Mark every place a secret or an
   excessive permission appears.
2. Remove the embedded secret from the configuration. Replace it with a
   runtime reference: the workload reads the secret itself at startup.
3. Restrict one excessive grant to the narrowest role and scope that still
   lets the deployment work.
4. Complete `worksheet.md`: which artifacts need controlled access, and which
   identity needs which permission.

Compare with the instructor's corrected design during the review.
