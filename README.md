# SnapFortress v2

**Sovereign Career Infrastructure. No abstraction tax.**

> You built it. You proved it. You shouldn't have to prove it again.

## Overview

SnapFortress v2 is a deterministic, cryptographically-audited career compilation pipeline. It compiles raw career documents into a verified Abstract Syntax Tree and projects them into context-adapted quantum personas — provably grounded in your real experience.

**The abstraction tax**: Every time you apply for a job, navigate a gatekeeping system, or prove yourself to a new institution — that's the tax. Time, energy, dignity, paid over and over for the same verified truth. SnapFortress ends it.

## Components

### 1. Career Compiler (`career-compiler/`)

Ingests raw career documents → deterministic OCT token stream → verified Resume AST → WORM-audited Bifrost log.

```bash
career-cli build \
  --input resume.pdf \
  --target ReentryResume \
  --output verified.pdf
```

**Stack:** Rust (OCT ingestion, Bifrost, CLI) · Haskell (AST compiler, exhaustive validation) · Prolog (routing protocol, meta-evaluation) · Lisp (fabrication engine)

### 2. Persona Engine (`persona-engine/`)

Compiles verified AST into quantum superposition of context-adapted personas. Each persona is a deterministic projection — every utterance traces to a verified AST node. Entropy ceiling: 0.20 nats.

```bash
career-cli persona superposition \
  --ast ast.json \
  --contexts TechnicalInterview:SystemsArchitecture:Senior \
             BehavioralInterview:Amazon \
             SalaryNegotiation:StaffEngineer \
  --output superposition.json
```

### 3. TwinMesh (`twinmesh/`)

A sovereign digital twin that co-evolves through subtle daily interaction — not forced interviews. Peer twins form a self-healing mesh network. Trust-weighted knowledge exchange. Full operator sovereignty.

## Integrity Properties

| Property | Guarantee |
|---|---|
| Zero ML drift | OCT ingestion is deterministic rule-based classification |
| Cryptographic proof | Blake3-hashed, Ed25519-signed, WORM-appended |
| No hallucination | Every template slot resolves only to verified AST data |
| Local first | Air-gap capable, no cloud dependency for core compilation |
| Operator sovereignty | Skill amplitudes operator-adjustable; sharing policy configurable |

## Audit Chain

```bash
career-cli verify-audit
career-cli export-audit --output audit_chain.jsonl
```

## Built by

[SNAPKITTYWEST](https://github.com/SNAPKITTYWEST) — Sovereign stack. Public interest tech.
