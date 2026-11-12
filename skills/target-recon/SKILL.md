---
name: target-recon
description: Map an authorised target's attack surface before any exploitation. Passive sources first, then counted, structured active enumeration that ends in a surface ledger and scored leads. Use at the start of any lab, CTF, or authorised engagement, and again after every new credential, foothold, or network position.
---

# Target Recon and Attack-Surface Mapping

## When to use

At the start of an engagement, and again every time the vantage point changes: a new credential, a foothold, a new subnet, a new role in an application. Recon is a loop, not a phase you finish once.

## Rules before anything runs

1. Confirm the target is in scope: a lab, a CTF machine, or a system covered by written authorisation. Write the scope line down before the first packet.
2. Passive before active, quiet before loud. Every active step is justified by a passive observation or by the need to complete the count.
3. The output of this skill is a ledger, not a scroll of tool output. Raw output is saved to files and referenced by path; the ledger holds findings.

## Workflow

### Step 1: Passive collection

Collect what the target and the public record already say, without touching the target where that is possible:

- DNS: A, AAAA, MX, TXT, and the zone's shape. Certificate transparency logs for subdomains. Passive DNS where available.
- Public code and documents: the organisation's public repositories, leaked configuration in public gists or package metadata, documentation, API references, status pages.
- Technology fingerprints from public artefacts: job postings, error pages in search caches, public headers recorded by scanners.
- For an LLM application: the public documentation of what the model can reach. Tools, data sources, file access, browsing, code execution. The tool list is the attack surface; write it down verbatim.

Record every passive fact with its source. A fact without a source is a rumour and is labelled as one.

### Step 2: Counted active enumeration

Map 100 percent of the reachable surface and count it, so coverage can be stated rather than felt.

- Hosts and ports: two-stage scanning. Stage 1 finds open ports across the full range. Stage 2 fingerprints versions and scripts on the open set only. Save every scan in a structured file, named by target and stage.
- UDP: the top ports by default, escalated when TCP is thin, when difficulty is high, or when any UDP service answers. Boxes exist whose only foothold was a UDP service while TCP showed almost nothing.
- Web surface: crawl before fuzzing. Extract JavaScript files, endpoints, forms, and API routes. Check the standard artefact paths: .git, .env, backup suffixes, API schema files, source maps, debug and metrics endpoints.
- Per service, in this fixed order: fingerprint certainty first (a banner is a claim, not a proof), anonymous and default access, version recorded, misconfiguration check, authenticated abuse where credentials exist. A specialised tool runs per service, or the waiver is written down with its reason.

### Step 3: The surface ledger

One entry per surface element, each with: what it is, where it was observed, the raw output path, and its enumeration status: not run, run clean, or run hit. A service is done when its entry says exhausted and every step in the per-service order is ticked. Anything less is an open lead, and the ledger says so.

### Step 4: Score the leads

Score every lead before exploitation begins:

    Priority = (E x C x R) / (H x (1 + K))

- E, evidence strength, 0 to 3: 0 banner only; 1 version matches a known vulnerability class; 2 misconfiguration or anomaly directly observed; 3 a working primitive partially demonstrated.
- C, chain value, 0 to 3: 0 dead-end information; 1 foothold likely; 2 foothold plus credentials or lateral movement; 3 a direct path to the objective.
- R, reuse, 0.5 to 2: does success here unlock other services, hosts, or data.
- H, horizon, 1 to 3: guessed steps to payoff.
- K, novelty cost, 0 to 2: 0 technique in your notes; 2 requires learning or custom development.

A lead at E=3 pre-empts scoring and is worked now. Ties break toward the lead whose failure teaches the most for the least cost.

## Output format

```text
Scope: <one line>
Surface count: <N hosts, M services, K web endpoints>
Ledger: <path>
Top leads, scored:
1. <lead> E=<e> C=<c> R=<r> H=<h> K=<k> Priority=<p> :: <one-line basis>
Unexplored surface: <explicit list, or "none known">
```

## Hard rules

- Never call a service exhausted without the ledger line.
- Never promote a banner or a scanner verdict to a finding. That is the verification skill's job.
- Never let scan volume substitute for the count. Ten thousand lines of output with no ledger is a failed recon.
