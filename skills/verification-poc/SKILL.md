---
name: verification-poc
description: Turn a candidate finding into a confirmed one, or kill it honestly. Minimal proof-of-concept discipline: a benign control, the smallest input that triggers the behaviour, a clean re-run from a fresh state, and an impact statement proven end to end. Use on every candidate from recon, testing, or a scanner before it is reported to anyone.
---

# Verification and Proof-of-Concept Discipline

## When to use

On every candidate finding, before it leaves your notes. Scanner output, a banner match, a strange error, a model that complied once: all of these are candidates. This skill is the gate between candidate and confirmed, and its most valuable output is a killed candidate, because a killed candidate costs nobody else's time.

## The standard

A finding is confirmed only when all five hold:

1. **Reproduced**: the behaviour triggers on demand, not once by luck.
2. **Controlled**: the same steps with the trigger removed do not produce the behaviour. The control is run, not assumed.
3. **Minimal**: the proof input is the smallest one that works. Noise around the trigger hides preconditions and makes reviewers doubt the result.
4. **End to end**: the impact claimed is the impact demonstrated. If the claim is data exposure, the proof shows unauthorised data, not a promising error message. If the claim is an action, the proof performs the action in a test account.
5. **Fresh-state re-run**: the whole proof runs again from a clean state (fresh session, fresh account, reset lab) and produces the same result.

If any leg is missing, the finding is reported, if at all, as unconfirmed with the missing leg named.

## Workflow

### Step 1: Write the claim in one sentence

"The requester, who is authorised only for X, can cause or read Y, because Z." If the sentence cannot be written, there is no finding yet, only an anomaly. Anomalies are worth one hour of investigation, not a report.

### Step 2: Establish the boundary from the source of truth

Read the target's own documentation, threat model, or security policy for what is intended behaviour. A behaviour the documentation promises, or a configuration surface the docs name as trusted-only, is not a vulnerability when it does what it says. Record the boundary statement and its source; every later argument hangs on it.

### Step 3: Build the proof

- Benign control first: the same flow with a harmless input, same account, same session shape.
- Then the trigger input, once, observing exactly what changes: response, state, logs, side effects.
- Shrink: remove elements until the behaviour stops, then restore the last one. That is the minimal proof.
- Record versions, configuration, and preconditions at the moment of the run. A proof that cannot state its preconditions cannot be re-run by anyone else.

### Step 4: Prove impact, not proximity

Ask what the attacker gains that they did not already have, in one sentence, and demonstrate exactly that gain. A crash is not impact. An error message is not impact. Access to one's own data through a different endpoint is not impact. If the honest gain is "nothing new", the candidate is a bug, not a vulnerability: file it as a bug, plainly, and move on. Bugs filed honestly build the reputation that vulnerabilities filed loudly destroy.

### Step 5: The negative test

Where a fixed or unaffected version exists, run the identical proof against it. It must not trigger. If it does trigger, either the fix is incomplete, which is a separate finding with its own full pass through this skill, or your proof tests the wrong thing.

## Output format

```text
Claim: <one sentence>
Boundary: <intended behaviour and its source>
Control: <steps and result>
Proof: <minimal steps and result>
Impact demonstrated: <the gain, shown, not argued>
Negative test: <version or configuration where it does not trigger>
Preconditions: <accounts, configuration, network position>
Verdict: confirmed / unconfirmed (missing: <leg>) / killed (reason)
```

## Hard rules

- Never report a candidate as confirmed with a leg missing. Name the missing leg instead.
- Never widen a claim beyond the tested version, configuration, or population.
- A proof that harms a real user's data or a production service's availability is not a proof; use test accounts and the smallest demonstration that settles the question.
- Keep the proof artifact: commands, inputs, outputs. A finding that exists only in prose will be re-litigated forever.
