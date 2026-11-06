# Introduction to Terraform on Google Cloud: Day 2 lab files

Prepared for Jack Henry & Associates. Day 2 covers reusable configurations
and controlled changes: a documented module, a justified environment
separation approach, a completed drift and import exercise, and a reviewed
plan for a second region.

These files are added to the repository you used on Day 1. Nothing from
Day 1 is replaced. You keep working in the same root configuration, with
the same state in your GCS bucket:

```
labs/L01-build-and-parameterize/     your ledgerlite root (Day 1 and Day 2)
```

The Day 2 guide calls this directory **the ledgerlite root**.

## What was added

| Path | Purpose |
| --- | --- |
| `labs/L04-collections-and-lifecycle/` | L04 (M07 and M08): starter snippets, expression worksheet, what-if variable files, plan-reading excerpts |
| `labs/L05-modules-and-environments/` | L05 (M09 and M10): module skeleton, supplied `moved` mapping, workspace sandbox, environment layouts |
| `labs/L06-drift-and-import/` | L06 (M11): drift case cards, change record, import starter block |
| `labs/L07-second-region/` | L07 (M12): a second root configuration for `us-east1` with its own state location |
| `scripts/day2-preflight.sh` | Start-of-day check: backend, workspace, state, and a clean plan |
| `scripts/plan-summary.sh` | Turns a saved plan into a short review table |
| `VERSIONS-DAY2.md` | Tested tool versions for Day 2 and the features that need a newer release |

## Day 2 flow

```
M07  console experiments, typed collection, dynamic block     L04 Part A
M08  for_each fleet, collection change, -replace              L04 Part B
M09  extract app_instance, moved block, documented interface  L05 Part A
M10  workspace check, environment layout decision             L05 Part B
M11  drift decision, import an existing firewall rule         L06
M12  second root for us-east1, reviewed plan, handoff         L07
```

## Rules for the day

1. Read every plan before you apply it. Say the address and the action out loud to your pair.
2. Apply only what the guide tells you to apply. Several plans today are for reading only.
3. Work only in your assigned lab project. Never create a service account key.
4. If you fall more than five minutes behind, ask for the module checkpoint. Every lab can resume from one.
