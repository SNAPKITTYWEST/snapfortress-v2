# SnapFortress v2

[![MIT License](https://img.shields.io/badge/license-MIT-7c5cfc?style=flat-square)](LICENSE)
[![GitHub Pages](https://img.shields.io/badge/site-live-4ade80?style=flat-square)](https://snapkittywest.github.io/snapfortress-v2/)
[![SNAPKITTYWEST](https://img.shields.io/badge/by-SNAPKITTYWEST-a78bfa?style=flat-square)](https://github.com/SNAPKITTYWEST)
[![Status](https://img.shields.io/badge/status-building-38bdf8?style=flat-square)](#)

> **You built it. You proved it. You shouldn't have to prove it again.**

Your career, compiled once. Verified forever. Presented anywhere — phone, browser, terminal, API. No gatekeepers. No abstraction tax.

---

## Try it right now

**In your browser** — no install needed:

```js
import { SnapFortress } from 'https://cdn.jsdelivr.net/npm/snapfortress-v2/dist/sdk.js'

const sf = new SnapFortress()
await sf.load('your-resume.pdf')

const persona = await sf.persona('technical-interview')
console.log(persona.present('Tell me about yourself'))
```

**On your phone** — paste this into any browser console:

```js
const { SnapFortress } = await import('https://snapkittywest.github.io/snapfortress-v2/sdk.js')
const sf = new SnapFortress()
sf.quickStart()
```

**npm:**

```bash
npm install snapfortress-v2
```

**CDN:**

```html
<script type="module" src="https://snapkittywest.github.io/snapfortress-v2/sdk.js"></script>
```

---

## What it does in plain terms

You upload your resume once. SnapFortress reads it, verifies every skill and job you've listed, and builds a locked, cryptographically-signed version of your career. Then it can speak *as you* — adapting to whatever situation you're in — without ever making up a single thing.

Going into a technical interview? It surfaces your engineering work.  
Negotiating salary? It pulls your metrics and impact numbers.  
Coming back from a gap, reentry, time away? It finds every transferable skill and leads with those.

Every word it says traces back to something you actually did. No hallucination. No exaggeration. Just you — verified.

---

## SDK quick reference

```js
import { SnapFortress } from 'snapfortress-v2'

const sf = new SnapFortress()

// Load your career documents
await sf.load('resume.pdf')              // PDF
await sf.load('resume.docx')             // Word
await sf.load({ text: '...' })           // plain text
await sf.load({ linkedin: 'your-url' }) // LinkedIn URL

// Build a persona for your situation
const persona = await sf.persona('technical-interview')
const persona = await sf.persona('behavioral-interview')
const persona = await sf.persona('salary-negotiation')
const persona = await sf.persona('reentry-resume')

// Use it
persona.present('Tell me about a time you led a team')
persona.present('Why should we hire you?')
persona.present('What are your strengths?')

// Get a verified resume for a specific target
const resume = await sf.compile('reentry-resume')
resume.download()           // save as PDF
resume.json()               // raw verified data
resume.auditChain()         // cryptographic proof

// TwinMesh — your daily co-pilot
const twin = await sf.twin()
twin.morningBriefing()      // what to focus on today
twin.breakDown('prep for interview at Stripe')
twin.sync()                 // exchange insights with peer network
```

---

## Three components

### Career Compiler
Reads your documents and builds a verified data structure of your career. Every skill, every job, every metric — tagged as proved or unproved. Nothing unverified goes downstream.

### Persona Engine
Takes that verified data and builds context-adapted versions of you. Technical interview. Salary negotiation. Reentry resume. Each one only says things that are actually true about you.

### TwinMesh
A digital twin that learns from your daily interactions — not forced interviews. Connects with peer twins to share knowledge. Gives you a morning briefing, helps you prep, reflects with you at day's end.

---

## Integrity

| | |
|---|---|
| Zero ML drift | Rule-based parsing only — no neural network randomness |
| Cryptographic proof | Blake3 + Ed25519 — every claim signed and chained |
| No hallucination | Hard constraint: every word traces to your actual documents |
| Works offline | Core pipeline runs local — no cloud required |
| You own it | Full sovereignty — you control what gets shared and with whom |

---

## Built by

[SNAPKITTYWEST](https://github.com/SNAPKITTYWEST) — sovereign stack, public interest tech.

[Live site](https://snapkittywest.github.io/snapfortress-v2/) · [License](LICENSE) · [Career Compiler](career-compiler/) · [Persona Engine](persona-engine/) · [TwinMesh](twinmesh/)
