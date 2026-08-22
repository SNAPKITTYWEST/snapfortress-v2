# SnapFortress v2

[![MIT License](https://img.shields.io/badge/license-MIT-7c5cfc?style=flat-square)](LICENSE)
[![GitHub Pages](https://img.shields.io/badge/site-live-4ade80?style=flat-square)](https://snapkittywest.github.io/snapfortress-v2/)
[![SNAPKITTYWEST](https://img.shields.io/badge/by-SNAPKITTYWEST-a78bfa?style=flat-square)](https://github.com/SNAPKITTYWEST)
[![Status](https://img.shields.io/badge/status-building-38bdf8?style=flat-square)](#)

> **You built it. You proved it. You shouldn't have to prove it again.**

Not an AI resume writer. Not a chatbot. Not LinkedIn with an AI layer.

SnapFortress is a system for turning messy career history into a **portable, evidence-backed, cryptographically auditable capability record** — then compiling that record into any employment context. Phone, browser, terminal, API. Works offline. You own everything.

---

## The complete flow

```
              YOUR HISTORY
                   │
                   ▼
          ┌─────────────────┐
          │ CAREER COMPILER │  ← reads your documents
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ EVIDENCE GRAPH  │  ← every claim linked to a source
          └────────┬────────┘
                   │
             ┌─────┴─────┐
             │           │
          VERIFIED    UNKNOWN
             │           │
             ▼           ✗   ← blocked. cannot proceed downstream.
       ┌──────────┐
       │ PERSONA  │
       │  ENGINE  │
       └────┬─────┘
            │
            ▼
       JOB / INTERVIEW
            │
            ▼
       VERIFIED OUTPUT
            │
            ▼
       CRYPTOGRAPHIC
          RECEIPT
```

The critical rule:

```
UNVERIFIED CLAIM
      ↓
   BLOCKED
      ↓
NOT AVAILABLE TO PERSONA
```

This is not a setting you can turn off. It is the system.

---

## Before and after

**Input:**

```
resume.pdf
────────────────────────────────
Senior Accountant, 2019–2023
Managed monthly close process
Reduced reconciliation time by 40%
Built Excel reporting dashboards
────────────────────────────────
```

**After Career Compiler runs:**

```
SKILL: Financial Reporting
EVIDENCE: resume.pdf → page 2
STATE: VERIFIED ✓

SKILL: Process Automation (Excel)
EVIDENCE: resume.pdf → page 2
STATE: VERIFIED ✓

SKILL: Reconciliation Optimization
EVIDENCE: resume.pdf → page 3
METRIC: "40%" — no corroborating document
STATE: UNVERIFIED ✗
```

**Persona: Technical Interview**

```
Question: Tell me about improving a process.

ALLOWED:
  Financial reporting work      ✓
  Monthly close process         ✓
  Reconciliation work           ✓

BLOCKED:
  The 40% metric                ✗  (no evidence)
  Invented technical experience ✗  (not in source)
  Invented employers            ✗  (not in source)
```

The persona answers using only what is verified. The metric gets flagged, not invented.

---

## The cryptographic chain

```
SOURCE DOCUMENT
      ↓
   CLAIM
      ↓
EVIDENCE REFERENCE
      ↓
  CLAIM HASH
      ↓
PREVIOUS RECORD HASH
      ↓
   BLAKE3
      ↓
ED25519 SIGNATURE
      ↓
 AUDIT RECORD  ← append only. cannot be modified.
```

What an audit record looks like:

```json
{
  "index": 4,
  "claim": "financial_reporting",
  "source": "resume.pdf",
  "location": "page:2",
  "state": "verified",
  "hash": "a3f9c2e1d8b047...",
  "previous": "7b21af9034c8e2...",
  "signature": "ed25519:3d9a17...",
  "operator_id": "operator",
  "timestamp_ns": 1753142400000000000
}
```

If any record in the chain is modified, signature verification fails for every record after it. The chain is self-auditing.

---

## Integrity Contract

```
SNAPFORTRESS INTEGRITY CONTRACT

 1. Claims require evidence.
 2. Evidence requires provenance.
 3. Unverified claims cannot become verified claims.
 4. Persona output may only reference verified claims.
 5. Missing evidence produces UNKNOWN — not a best guess.
 6. Contradictory evidence produces CONFLICT — not a resolution.
 7. Cryptographic records are append-only.
 8. Users control disclosure.
 9. Verification failure blocks downstream output.
10. No component may silently fabricate career history.
```

These are not goals. They are enforced constraints baked into the pipeline.

---

## 60-second demo

```bash
# 1. install
npm install snapfortress-v2

# 2. compile your career record
sf compile --input resume.pdf --output record.sf

# 3. inspect what was verified
sf inspect record.sf

# SKILL: financial_reporting  STATE: verified   SOURCE: page:2
# SKILL: process_automation   STATE: verified   SOURCE: page:2
# METRIC: 40%_reduction       STATE: unknown    SOURCE: none
# SKILL: blockchain_dev       STATE: blocked    SOURCE: contradicted

# 4. generate a persona
sf persona --record record.sf --context technical-interview

# 5. ask it a question
sf ask "Tell me about a time you improved a process."

# 6. verify the audit chain
sf audit record.sf

# ✓ 12 records verified
# ✓ Chain intact
# ✓ Signatures valid
```

**In the browser — no install:**

```js
import { SnapFortress } from 'https://snapkittywest.github.io/snapfortress-v2/sdk.js'

const sf = new SnapFortress()
await sf.load('resume.pdf')

const persona = await sf.persona('technical-interview')
console.log(persona.present('Tell me about yourself'))
```

**On your phone — paste into browser console:**

```js
const { SnapFortress } = await import('https://snapkittywest.github.io/snapfortress-v2/sdk.js')
const sf = new SnapFortress()
sf.quickStart()
```

---

## SDK reference

```js
import { SnapFortress } from 'snapfortress-v2'

const sf = new SnapFortress()

// load your history
await sf.load('resume.pdf')
await sf.load('resume.docx')
await sf.load({ text: '...' })

// compile a career record
const record = await sf.compile()
record.verified()       // list of verified claims
record.unknown()        // list of unverifiable claims
record.blocked()        // list of contradicted claims
record.auditChain()     // full cryptographic chain
record.download()       // save as signed .sf file

// build a persona
const persona = await sf.persona('technical-interview')
const persona = await sf.persona('behavioral-interview')
const persona = await sf.persona('salary-negotiation')
const persona = await sf.persona('reentry-resume')

// use the persona
persona.present('Tell me about yourself')
persona.present('Why should we hire you?')
persona.present('Tell me about a challenge you overcame')

// daily twin
const twin = await sf.twin()
twin.morningBriefing()
twin.breakDown('prep for interview at Stripe')
twin.sync()
```

---

## Reentry mode

SnapFortress is built for the hardest case first: people coming home from incarceration, long gaps, informal work, self-taught skills, unfinished education.

The system treats every history as valid input:

```
employment gap          ✓ processed
justice involvement     ✓ processed
informal work           ✓ processed
certificates            ✓ processed
side projects           ✓ processed
volunteer work          ✓ processed
self-taught skills      ✓ processed
unfinished education    ✓ processed
```

The transformation:

```
FRAGMENTED HISTORY
        ↓
EVIDENCE EXTRACTION
        ↓
TRANSFERABLE SKILLS
        ↓
VERIFIED SKILL GRAPH
        ↓
TARGET JOB
        ↓
COMPILED CAREER PROFILE
```

The persona engine does not know or care about gaps. It knows what is verified. It presents what is verified. Anything you actually did is evidence. Evidence becomes claims. Claims become capability.

```bash
sf compile --input history.txt --mode reentry
sf persona --context reentry-resume
sf ask "What relevant experience do you have for this warehouse coordinator role?"
```

---

## Workforce reality

```
AI is changing entry-level work.

That creates two simultaneous problems:

REENTRY
People returning from incarceration, gaps, displacement
need a way to prove capability despite broken paper trails.

DISPLACEMENT
People whose roles are being automated
need a way to continuously prove and redeploy their skills
as the ground shifts underneath them.
```

SnapFortress is infrastructure for both. The same verified capability record that helps someone re-enter the workforce after five years away also helps someone whose job title just stopped existing prove what they can actually do.

The abstraction tax hits hardest at the edges. That is where we build first.

---

## TwinMesh architecture

```
                    USER
                      │
                      ▼
               PERSONAL TWIN
                 /    |    \
                /     |     \
               ▼      ▼      ▼
          SKILLS   HISTORY   GOALS
             │        │        │
             └────────┼────────┘
                      ▼
                VERIFIED STATE
                      │
             ┌────────┴────────┐
             ▼                 ▼
         PERSONA            TWINMESH
             │                 │
             ▼                 ▼
       JOB / INTERVIEW     PEER SIGNALS
                               │
                        trust-weighted
                        anonymized
                        opt-in only
```

**What does not leave your control:**

- Your source documents
- Your verified career record
- Your audit chain
- Your persona output

What the mesh exchanges (only if you enable it): anonymized skill signals and job-market patterns from consenting peers. You see aggregate insights. No one sees your record.

---

## Verification test suite

```
✓ verified claim accepted by persona
✓ unverified claim rejected at persona boundary
✓ missing evidence produces UNKNOWN, not fabrication
✓ contradictory evidence produces CONFLICT, not resolution
✓ persona cannot access blocked claim
✓ modified claim invalidates signature
✓ modified chain fails verification at tampered record
✓ all subsequent records fail after tamper point
✓ offline verification succeeds without network
✓ reentry profile compiles from informal history
✓ targeted resume contains only admissible claims
✓ gap in employment history does not block compilation
✓ self-taught skill with project evidence passes verification
✓ invented employer rejected — no matching evidence
✓ invented metric rejected — no corroborating document
```

The most important tests are the negative ones. The system's value is not that it generates a career profile. It is that you can prove what happens when someone tries to make it generate something it cannot prove. It blocks. It logs. It does not guess.

---

## Repository

```
snapfortress-v2/
│
├── career-compiler/
│   ├── oct-ingestion/     ← Rust: document → token stream
│   ├── ast-compiler/      ← Haskell: token stream → evidence graph
│   ├── routing-protocol/  ← Prolog: agent traversal logic
│   ├── fabrication-engine/← Lisp: multi-target compilation
│   ├── bifrost-bridge/    ← Rust: WORM audit chain
│   └── schemas/           ← JSON Schema definitions
│
├── persona-engine/
│   ├── src/               ← Rust: runtime
│   └── persona_routing.pl ← Prolog: collapse + context logic
│
├── twinmesh/
│   ├── src/               ← Rust: mesh runtime
│   └── subtle_logic.pl    ← Prolog: interaction + consensus
│
├── docs/                  ← GitHub Pages site
├── sdk.js                 ← browser/CDN entry point
└── LICENSE
```

---

## Built by

[SNAPKITTYWEST](https://github.com/SNAPKITTYWEST) — sovereign stack, public interest tech.

[Live site](https://snapkittywest.github.io/snapfortress-v2/) · [License](LICENSE) · [Career Compiler](career-compiler/) · [Persona Engine](persona-engine/) · [TwinMesh](twinmesh/)
