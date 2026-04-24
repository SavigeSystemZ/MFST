# Soak baselines

This folder stores accepted soak `results.json` snapshots used by
`scripts/release-gate.sh` and `scripts/compare-soak-results.sh`.

- `latest.json` — current accepted baseline for strict non-regression checks.

## Update policy

Only update `latest.json` when:

1. Gate 8 soak run passes (`validation.fail = 0`, `restore.fail = 0`), and
2. Any latency regression is explicitly reviewed/accepted by the human.

Recommended flow:

```bash
./_Meta_Fiction_System/scripts/release-gate.sh --count 100 --parallel 8 --update-baseline
```
