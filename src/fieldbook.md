---
title: The Fieldbook
---

[Back to Index](index.html)

# The Fieldbook {.unnumbered}

## Applied Cybernetic Necromancy in Haunted Infrastructure {.unnumbered}

> “The system remembers nothing.
> The bastards remember everything.“

---

# Welcome to the House {.unnumbered}

You have probably met one of these systems.

A command succeeds, but the operation does not.

The documentation describes the happy path.
The issue tracker describes the promised future.
The implementation describes neither.

An experienced operator explains that the command works, provided you:

- run another command first;
- disable one feature;
- remember which root is authoritative;
- ignore the man page in this particular case;
- and never perform the operation during a full moon.

You ask where this contract is documented.

The operator points at an IRC log from 2011, a mailing list post from
2012, or a wiki note from 2013.

This is not merely bad documentation.

You are looking at an ecosystem that stores part of its execution
model inside human memory.

The House calls that **coping infrastructure**.

When enough coping infrastructure accumulates, operators begin
functioning as missing subsystems.

The House calls those operators **bastards**.

This book is an inventory of the mechanisms that manufactures them.

Not because the words are funny.

They are funny because otherwise we would have to describe the same
failure for the fourteenth time without laughing.

---

# Where This Book Fits {.unnumbered}

Zeppe-Lin documentation is organized into three books.

**[The Handbook](handbook.html)** explains how to install, configure,
and operate the system.

**[The Codebook](codebook.html)** explains how the system is built,
maintained, and changed.

**The Fieldbook** examines how systems acquire meaning, how their
boundaries fail, how operators compensate, and how those compensations
become infrastructure.

The Handbook asks how to use the machine.

The Codebook asks how to work on the machine.

The Fieldbook asks what kind of machine --- and what kind of operators
--- the ecosystem is manufacturing.

---

# How to Read This Book {.unnumbered}

This is not an alphabetical glossary.

The terms form a causal model:

```text
authority
    ↓
boundary
    ↓
drift
    ↓
folklore
    ↓
regulation
    ↓
operator adaptation
    ↓
doctrine
```

Meaning first needs an owner.

Authority needs a boundary.

Weak boundaries allow meaning to drift.
Drift is absorbed by wrappers, rituals, local conventions, and human
memory.
Those compensations become part of the control system.
The control system manufactures operators adapted to its defects.
Eventually the adaptation acquires a moral vocabulary and calls itself
design philosophy.

That is how a bug becomes a religion.

The book therefore moves from mechanisms to consequences.

It begins by asking where truth and authority live.
It then follows what happens when their boundaries weaken: semantics
drift, folklore accumulates, operators compensate, and local survival
gradually becomes ecosystem structure.

Examples throughout the book are drawn from concrete infrastructure
autopsies: package systems, build tools, repositories, wrappers,
interfaces, documentation, and operator workflows.

They are evidence, not scripture.

No individual incident is the center of the model.
The same mechanism should remain recognizable when the component,
language, project, or historical context changes.

If a concept works only on one corpse, it is not yet a field concept.

You may read the book from beginning to end, following the causal
model, or enter through a familiar symptom and follow the surrounding
terms.

You do not need to memorize the ghosts.

Learn where they enter the building.

---

# Working Vocabulary {.unnumbered}

Before opening the first corpse, we need to agree on what several
ordinary words mean.

This is not the Fieldbook's full vocabulary.
It is only a small set of coordinates used throughout the book.

| Term | Meaning |
| --- | -------------- |
| **operator** | A person operating an installation or composing a local workflow. |
| **maintainer** | A person changing or governing shared project artifacts. |
| **component** | A bounded technical unit such as a tool, library, service, or repository process. |
| **system** | The intended technical model and the state transitions it claims to govern. |
| **infrastructure** | The concrete code, databases, repositories, scripts, and deployment surfaces implementing the system. |
| **ecosystem** | The coupled human and technical whole surrounding the system. |
| **artifact** | A bounded output expected to carry identity and truth across a boundary. |
| **semantics** | What an operation, interface, state, or artifact means. |
| **invariant** | A property mechanically preserved by the system. |
| **folklore** | Operational knowledge transmitted socially rather than mechanically. |

These distinctions matter.

A component may be correct in isolation while the system remains
incoherent.

The infrastructure may continue functioning while the ecosystem spends
operators to keep it alive.

The system may claim one semantic model while its artifacts, scripts,
and maintainers enforce another.

The word **user** is reserved for explicitly user-facing interfaces or
quoted claims.
In systems analysis, **operator** is usually more precise:
the human is not merely consuming a product but participating in its
control loop.

Likewise, **software** refers to programs or code in general.
It should not be used as shorthand for the entire ecosystem.

The ecosystem contains both human and technical nodes.

Components carry interfaces, defaults, state transitions, and
compromises hardened into executable form.

Operators carry memory, caution, habit, local knowledge, and folklore.

Neither is outside the system merely because only one of them drinks
coffee.

---

# Part I. The Foundational Tension {.unnumbered}

A system has been running for fifteen years.

Packages still install.  
Services still start.  
Upgrades usually finish.

One operator knows which configuration file must be copied before the
upgrade.
Another knows which warning can be ignored.
A third maintains a wrapper that nobody fully understands but
everybody invokes.

Remove those operators and the system stops being reliable.

Was the system stable?

Yes.

Just not by itself.

---

# Local Survivability and System-Level Coherence

Long-lived infrastructure is often judged at two different scales.

**Local survivability** asks:

> Can this installation be kept working?

**System-level coherence** asks:

> Can the ecosystem state what the operation means, preserve that
> meaning across its boundaries, and enforce the result without
> relying on hidden knowledge?

These are not the same achievement.

A local wrapper may keep one installation alive.

An overlay may repair one package.

An operator may remember that one command must always precede another.

A mailing-list post may explain the failure perfectly.

All of these can restore local survivability.

None of them necessarily restores system-level coherence.

> The machine works.  
> The ecosystem just needs several humans installed as runtime
> dependencies.

## Local Survivability

**Local survivability** is the ability of an installation or workflow
to remain operational despite unresolved defects in the shared system.

It may depend on:

* local patches;
* wrappers;
* overlays;
* undocumented command sequences;
* operator discipline;
* institutional memory;
* avoiding certain valid-looking states;
* knowing which failures are harmless.

Local survivability is real engineering value.

A workaround that keeps a production system alive is not fake merely
because it is ugly.
An operator who understands a broken boundary may prevent data loss
while a cleaner design remains unavailable.

The mistake is not surviving locally.

The mistake is confusing survival with resolution.

> A tourniquet is successful when the patient stops bleeding.  
> It becomes architecture when nobody returns for the leg.

## System-Level Coherence

**System-level coherence** is the condition in which the system's
semantics remain explicit, compatible, and mechanically defensible
across the layers that compose them.

A coherent system can answer:

* Which component owns this operation?
* Where is the authoritative state?
* Which inputs are valid?
* Which failures are expected?
* What truth crosses the boundary?
* What can callers safely assume?
* What happens when one component is replaced?
* Who rejects an invalid state?

The answers do not need to be centralized.

They need to agree.

A system may consist of many small tools and still be coherent.
Another may have one enormous orchestrator and remain incoherent.
The number of components does not decide the matter.

The question is whether their meanings compose.

## The Foundational Trade

Local survivability spends whatever is available now:

* attention;
* memory;
* shell code;
* repository convention;
* operator expertise;
* compatibility debt.

System-level coherence spends engineering effort earlier:

* explicit contracts;
* normalized state;
* invariant enforcement;
* artifact metadata;
* rejection paths;
* migration work;
* boundary design.

Neither is free.

The difference is where the bill is sent.

```text
local survivability
    pays with operators, memory, and repeated adaptation

system-level coherence
    pays with models, contracts, and enforcement
```

A project under immediate pressure may rationally choose local
survival.

A project that repeatedly makes the same choice is no longer
responding to an emergency.

It is selecting an architecture.

## Field Symptom

A command accepts an operation and exits successfully.

The resulting state is only correct if the operator already knows:

* which root supplied dependency information;
* which root received the files;
* where lifecycle scripts executed;
* and which configuration belonged to the host rather than the target.

One installation may survive because its operator understands the
split.

The command surface remains globally incoherent because it presents
several execution contexts as one operation without defining their
relationship.

Local competence has successfully concealed a missing model.

## Do Not Confuse

**Local survivability** is not the same as bad engineering.

Sometimes local repair is the only responsible action available.

**System-level coherence** is not the same as centralization.

A coherent system may distribute authority across many components,
provided their contracts and boundaries remain explicit.

**Strictness** is not automatically coherence.

A system can reject many states while enforcing the wrong model.

**Flexibility** is not automatically survivability.

An interface that accepts everything may merely postpone failure until
the operator has fewer useful facts.

## The Scaling Problem

A small ecosystem can survive substantial incoherence because a few
operators carry most of the missing context.

They remember:

* why the workaround exists;
* which assumption it protects;
* which apparent alternative is unsafe;
* what happened the last time somebody removed it.

As the ecosystem grows, those memories no longer propagate reliably.

The same workaround is copied without its rationale.

Different installations preserve different pieces.

A local truth becomes distributed folklore.

Eventually the ecosystem contains several working systems that are no
longer working for the same reasons.

> Folklore scales by losing packets.

System-level coherence becomes important not because every
installation must be identical, but because variation needs explicit
boundaries.

Without those boundaries, flexibility and drift become
indistinguishable.

## First House Law

> Survival proves that the ecosystem compensated.  
> It does not prove that the system was correct.

This distinction will recur throughout the Fieldbook.

Whenever a workaround, wrapper, convention, or expert operator keeps
something alive, ask two questions:

1. What local failure was successfully absorbed?
2. Which shared boundary remains unresolved?

The first question respects the repair.

The second prevents the repair from becoming theology.

---

# Operational Burden and the Accounting of Simplicity

A component is rewritten.

Three configuration options disappear.  
Two internal models are removed.  
The code becomes smaller.

The missing behavior reappears in:

* a wrapper;
* a repository convention;
* an installation guide;
* an operator checklist;
* and a script called `final-fixed-real.sh`.

The component is now simpler.

The operation is not.

---

## Operational Burden

**Operational burden** is the work the ecosystem must continuously
perform to keep infrastructure usable, intelligible, and coherent.

It includes work performed by components:

* validating state;
* normalizing inputs;
* preserving metadata;
* rejecting invalid operations;
* reporting authoritative results;
* migrating old representations.

It also includes work performed outside components:

* remembering command order;
* reconciling incompatible state;
* maintaining wrappers;
* reading historical discussions;
* carrying undocumented assumptions;
* repairing the same failure locally;
* teaching newcomers which documented behavior is fictional.

Operational burden is not automatically evidence of bad design.

Some burden belongs to the problem itself.

The useful question is:

> Does the burden arise from the domain, or from the way the ecosystem
> chose to represent and distribute the domain?

## Three Kinds of Complexity

Not all complexity should be treated as one cursed substance.

| Kind | Description |
| ---- | -------------- |
| **essential complexity** | Complexity inherent in the problem being solved. |
| **accidental complexity** | Complexity introduced by representation, coupling, implementation, or a missing model. |
| **optional complexity** | Complexity introduced by a feature, policy, or ambition the system could choose not to support. |

Essential complexity must be managed.

Accidental complexity should be removed when practical.

Optional complexity should be justified against the burden it creates.

This distinction prevents a common form of architectural theology:

> The problem is complicated, therefore every complication in our
> implementation is sacred.

No.

Some complications are the problem.

Some are merely the furniture arrangement in the crypt.

## Burden Migration

When one layer stops performing necessary work, that work does not
always disappear.

It may migrate:

```text
component
    ↓
caller
    ↓
wrapper
    ↓
operator
    ↓
documentation
    ↓
folklore
```

For example, a component may stop publishing structured artifact
identity.

The artifact still needs an identity.

The caller now reconstructs it from configuration.

A wrapper later reconstructs it from a filename.

An operator eventually remembers that one package uses a different
filename rule.

The original component became smaller.

The ecosystem acquired archaeology.

## Local Simplicity

**Local simplicity** is simplicity measured within one selected
boundary.

Local simplicity can be genuine.

A component with fewer responsibilities may be easier to understand,
test, and replace.
A smaller interface may expose a more honest contract.
Removing accidental complexity is real progress.

Local simplicity becomes misleading when necessary work has merely
moved outside the measured boundary.

> We removed the complexity from the program.  
> It now lives in every program that calls it.

That is not necessarily a bad trade.

It is, however, a trade.

## Entropy Export

**Entropy export** is the movement of unresolved operational burden
from one layer into another.

Common destinations include:

* operators;
* wrappers;
* overlays;
* downstream components;
* repository policy;
* documentation;
* institutional memory.

The term is metaphorical.

This is not a claim that software complexity obeys thermodynamic law.
Accidental complexity can be eliminated.
Optional complexity can be rejected.
Better models can make a system genuinely simpler.

Entropy export describes a narrower event:

> One layer preserves its simplicity by requiring another layer to
> absorb unresolved variation, ambiguity, or state reconciliation.

Export may be deliberate and legitimate.

A low-level component should not necessarily own every policy
decision.
An operator may reasonably retain control over local configuration.
A wrapper may be the correct place for site-specific behavior.

The pathology begins when the transfer is hidden, unbounded, or denied.

## Entropy Laundering

**Entropy laundering** is presenting exported operational burden as if
it had been eliminated.

Typical forms include:

* counting lines of code while ignoring mandatory shell glue;
* praising a small base system while excluding installation ritual;
* removing a model and calling every resulting edge case “operator
  choice”;
* moving validation into documentation and declaring the interface
  flexible;
* depending on expert memory while claiming the system has no policy.

> The code is simple because the operator has become complicated.

Entropy laundering is an accounting failure.

The burden remains inside the ecosystem.
It has merely been moved to a column nobody wishes to publish.

## Structural Ownership

A burden is **structurally owned** when the ecosystem can answer:

* which layer is responsible for it;
* what representation carries it;
* where it is validated;
* how failure is reported;
* what callers may assume;
* how the responsibility changes under substitution.

A burden may be assigned to an operator and still be structurally
owned.

For example, choosing a hostname is legitimately an operator decision.

The system does not need to decide what the machine should be called.
It does need to define:

* where the hostname is stored;
* what syntax is accepted;
* which components consume it;
* when a change takes effect;
* how an invalid value is rejected.

The operator owns the choice.

The system owns the contract around that choice.

Operator authority is not the same as architectural absence.

## Field Symptom

A build tool knows the exact artifact it produced.

To remain “simple”, it exposes no structured result.

An orchestrator must therefore:

1. read the build tool's configuration;
2. duplicate its naming rules;
3. inspect the output directory;
4. parse human-readable output;
5. guess which file is authoritative.

Later, another tool repeats the same reconstruction.

The builder owns the fact but refuses supplier duty.

Its local simplicity is purchased with ecosystem-wide coupling.

> One component saved an API call.  
> Five callers founded a priesthood.

## Do Not Confuse

**Small code** is not automatically entropy laundering.

A small component with a narrow, explicit contract may be excellent
architecture.

**Operator control** is not automatically exported burden.

Operators should own policy and local intent where appropriate.

**Documentation** is not automatically coping infrastructure.

Documentation is necessary even in coherent systems.
It becomes a substitute for structure when correctness depends on
remembering prose that the system could have enforced.

**A wrapper** is not automatically evidence of failure.

A wrapper may express legitimate local policy.
It becomes coping infrastructure when it repeatedly reconstructs
missing shared semantics.

**Minimalism** is not the enemy.

Unpriced externalization is.

## The Accounting Test

When a design is described as simpler, ask:

1. Which code or model disappeared?
2. Which obligation disappeared with it?
3. Which obligations still exist?
4. Where are those obligations performed now?
5. Can the new owner express and enforce them?
6. Is the transfer visible to operators and maintainers?
7. Does substitution become easier or harder?
8. Has the ecosystem become simpler, or only the selected component?

The test is not intended to forbid local simplification.

It prevents one subsystem from declaring victory while leaving the
cleanup crew outside the measurement boundary.

## Second House Law

> The ecosystem always pays.  
> The only question is where.

A clean design does not eliminate every burden.

It puts each burden somewhere that can name it, carry it, and refuse
to pretend it belongs nowhere.

---

# Part II. Semantic Authority and Boundaries {.unnumbered}

A package manager reports that a package is installed.

The package database contains no matching record.

The files exist on disk.

A wrapper reports success.

A maintainer explains that the database is authoritative, except
during upgrades, where the filesystem is authoritative, unless the
package was installed into another root, in which case the
configuration file determines what the command probably intended.

The operation has four narrators.

None of them has custody of the truth.

---

# Meaning Needs an Owner

Every operation carries meaning.

“Install this package” might mean:

* place files into a target filesystem;
* register package identity in a database;
* satisfy dependencies;
* execute lifecycle scripts;
* preserve ownership and metadata;
* make the resulting state discoverable to later operations.

The command name does not decide which of these meanings the system
owns.

The implementation does.

More precisely, meaning is determined by whichever layer can decide
what state is valid, what facts are authoritative, and what happens
when those facts disagree.

> Authority is not where the documentation points.  
> Authority is where disagreement stops.

## Semantics

**Semantics** are what an operation, interface, state, or artifact
means inside the system.

Syntax tells us that a command accepts `--root=/mnt`.

Semantics tell us:

* which operations observe the host;
* which operations mutate `/mnt`;
* where dependencies are resolved;
* where lifecycle scripts execute;
* which database records the result;
* and whether the whole command still represents one coherent
  operation.

A syntactically valid command can be semantically incoherent.

The parser may be satisfied while the system has already summoned four
different realities.

## Semantic Authority

**Semantic authority** is the ability to define, validate, or enforce
meaning.

A layer possesses semantic authority when it can answer questions such
as:

* What state currently exists?
* Which representation is authoritative?
* Is this operation valid?
* What result did the operation produce?
* Which disagreement causes failure?
* Which facts may callers rely upon?

Semantic authority is not the same as influence.

Documentation influences operator expectations.

An issue influences future design.

A wrapper influences execution.

Only a layer capable of deciding or enforcing operational truth is
authoritative for that truth.

## Semantic Authority Surface

A **semantic authority surface** is the boundary at which meaning
becomes operationally binding.

Examples include:

* a database transaction that records installed package state;
* a library API that validates and normalizes an operation;
* an artifact manifest carrying identity and provenance;
* a repository gate that rejects invalid metadata;
* an orchestrator that owns the complete execution model;
* an operator convention, when no technical layer owns the rule.

The last case matters.

If the system accepts an invalid-looking state and experienced
operators prevent it only through discipline, then the operator
community is part of the effective authority surface.

The system may deny this in its architecture diagrams.

Reality is not required to respect the diagrams.

## Source of Truth

A **source of truth** is the authoritative representation from which
other representations are derived and against which disagreements are
resolved.

A source of truth should be identifiable.

Consider package identity.

Possible representations include:

* the package database;
* archive metadata;
* the archive filename;
* the build configuration;
* the source directory name;
* human-readable output;
* repository metadata.

Several of these may describe the same package.

Only one may be authoritative for a particular operation.

If the system cannot state which one wins when they disagree, it does
not have several sources of truth.

It has several witnesses and no judge.

> Two sources of truth are usually one source of truth and one future
> incident report.

## Derived Representation

A **derived representation** is a projection generated from an
authoritative source.

A package filename may be derived from package identity.

A status line may be derived from transaction state.

A generated configuration may be derived from declarative input.

Derived representations are useful.

The pathology begins when callers treat a projection as authoritative
because the original source is inaccessible.

For example:

```text
authoritative package identity
        ↓
generated filename
        ↓
caller reparses filename
        ↓
reconstructed package identity
```

The system started with truth.

It converted truth into decoration.

Another component then reverse-engineered the decoration to recover
the truth.

This is architecture performing a round trip through typography.

## Semantic Locality

**Semantic locality** describes where a particular meaning is
permitted to live.

For example:

* archive interpretation may belong to an extraction layer;
* package identity may belong to package metadata;
* dependency policy may belong to an orchestrator;
* local machine naming may belong to the operator;
* validation of that name may belong to the system.

Different architectures choose different semantic localities.

A small-tool ecosystem may distribute authority across many
components.

A centralized system may place several meanings inside one service.

Neither arrangement is inherently coherent or incoherent.

The diagnostic question is:

> Does each meaning live somewhere capable of owning it, and can other
> layers consume it without reconstructing hidden knowledge?

## Authority Fracture

An **authority fracture** occurs when the ecosystem believes one layer
owns a meaning while operational behavior assigns that meaning
elsewhere.

Common forms include:

* documentation claims one behavior while implementation enforces
  another;
* an orchestrator appears authoritative but must infer facts from a
  subordinate tool;
* a database claims to represent state while operators trust the
  filesystem instead;
* a component accepts an operation but maintainers rely on folklore to
  define the actual valid subset;
* an artifact appears self-describing but its identity depends on
  external configuration.

Authority fracture is more dangerous than an openly missing feature.

A missing feature produces a visible absence.

A fractured authority surface produces several plausible answers.

> One missing answer is a limitation.  
> Three partially correct answers are an ecosystem.

## Field Symptom

A build component creates an artifact.

It knows:

* the artifact path;
* the package identity;
* the version;
* the architecture;
* the build result.

It prints a human-readable line:

```text
Built package foo#1.2-1.pkg.tar.gz
```

The orchestrator needs the artifact path.

Instead of receiving a structured result, it:

1. captures stdout;
2. searches for the word `Built`;
3. extracts the final field;
4. assumes the filename encodes package identity;
5. checks whether that file exists.

Which layer owns artifact identity?

The builder knows it.

The orchestrator needs it.

The filename suggests it.

The output narrates it.

No explicit authority surface carries it across the boundary.

The fact exists, but not in a form that can travel safely.

> The truth was present at the scene.  
> Unfortunately, it was wearing a sentence.

## Authority Is Operational

A project may declare a file, database, or interface authoritative.

That declaration matters only while the system resolves disagreement
through it.

Suppose documentation says the package database is authoritative, but:

* removal checks the filesystem directly;
* upgrades infer old state from filenames;
* repair scripts reconstruct records from installed files;
* operators routinely edit the database by hand.

The database remains important.

It is not the sole authority surface the ecosystem actually uses.

Authority is discovered by following conflict resolution.

Ask:

> When representations disagree, which one changes the others?

That layer is closer to authority than whichever one has the grandest
heading in the manual.

## Do Not Confuse

**Semantic authority** is not the same as centralization.

Authority may be distributed across explicit, compatible boundaries.

**Source of truth** does not mean one global database for everything.

Different facts may have different authoritative sources.

**Documentation** is not authoritative merely because it is official.

Documentation can accurately describe authority.
It does not create enforcement by typography.

**Operator knowledge** is not unreal.

When operators must preserve a rule for the system to remain correct,
their knowledge is part of the effective control structure.

The problem is not that humans participate.

The problem is pretending they do not.

**Several representations** do not automatically imply authority
fracture.

A system may have one authoritative representation and many useful
derived projections.

The fracture begins when disagreement has no explicit resolution path.

## The Authority Test

For any important fact, ask:

1. Which component first knows it?
2. Where is it stored?
3. Which representation is authoritative?
4. Which representations are derived?
5. How do callers obtain it?
6. What happens when representations disagree?
7. Which layer can reject an invalid value?
8. Can the fact cross its boundary without reconstruction?
9. Does documentation describe the actual authority surface?
10. Are operators silently completing the contract?

If these questions produce different answers from different
maintainers, the system does not merely have a documentation problem.

It has an authority topology waiting to become folklore.

## Third House Law

> Meaning belongs to the layer that can enforce it.  
> Everything else is commentary.

The next task is therefore not to centralize all meaning.

It is to give each meaning an honest owner, a visible boundary, and a
form capable of surviving the crossing.

---

# Binding Surfaces

The failure is understood.

An issue describes it precisely.

The maintainers agree with the diagnosis.

The documentation warns about the dangerous case.

An IRC discussion reconstructs the entire historical cause.

Eleven years later, the operation behaves exactly the same.

The ecosystem did not lack knowledge.

It lacked somewhere for knowledge to become structure.

---

## Binding Surface

A **binding surface** is a mechanism through which an observation,
decision, policy, or lesson can alter authoritative system behavior.

Examples include:

* an API that rejects invalid input;
* a database constraint;
* a versioned artifact schema;
* a repository gate that blocks publication;
* a test whose failure prevents release;
* a normalization layer applied before state mutation;
* a migration that rewrites an obsolete representation;
* a configuration parser that refuses ambiguous values.

A binding surface gives knowledge operational consequences.

Without one, even a perfect diagnosis may remain commentary.

> A correct observation with nowhere to bind is a well-documented
> scream.

## Observation and Control

Observation is necessary for regulation.

It is not sufficient.

A system may observe:

* failed builds;
* inconsistent metadata;
* invalid package names;
* incompatible dependency state;
* operator confusion;
* repeated support incidents.

These observations become regulatory only when they enter a path
capable of changing future state.

```text
observation
    ↓
interpretation
    ↓
decision
    ↓
binding surface
    ↓
changed behavior
```

Without the binding surface, the loop stops at interpretation.

The ecosystem learns what happened.

The system continues doing it.

## Knowledge Without Authority

Knowledge can exist in many places:

* documentation;
* issue trackers;
* commit messages;
* mailing lists;
* IRC logs;
* maintainer memory;
* postmortems;
* comments;
* local scripts.

These are memory surfaces.

They preserve or transmit information.

A memory surface becomes a binding surface only when the information
it contains can constrain authoritative behavior.

For example:

* a man page saying “package names must not contain `/`” is a memory
  surface;
* a parser rejecting package names containing `/` is a binding
  surface;
* a repository check rejecting such packages before publication is
  another binding surface.

The prose may explain the rule.

The parser and repository gate give the rule a body.

## Documentation Confesses; Issues Desire

The House uses a simple epistemic boundary:

> Documentation confesses.  
> Issues desire.

Documentation should describe what the current system actually owns:

* supported behavior;
* rejected behavior;
* limitations;
* known ambiguity;
* operational consequences.

An issue may describe:

* a proposed contract;
* a desired feature;
* a future migration;
* an unresolved contradiction;
* a cleaner model that does not yet exist.

Both are valuable.

They answer different questions.

Documentation asks:

> What reality does the project currently admit?

An issue asks:

> What reality does the project hope to construct?

Confusing the two creates hallucinated authority.

An operator reads a proposed future as a present guarantee.

A maintainer treats an acknowledged defect as if filing the issue
already repaired it.

The project acquires documentation from tomorrow and behavior from
yesterday.

## Canonizing the Contradiction

**Canonizing the contradiction** means documenting a known
inconsistency accurately before it dissolves back into folklore.

This is not repair.

It is institutional honesty.

Suppose an alternate-root operation:

* resolves dependencies against the host;
* installs files into the target;
* executes lifecycle scripts in the host context;
* records state in a target database.

The correct documentation should state those facts plainly.

A warning does not make the operation coherent.

It does prevent operators from inferring a coherence the system does
not possess.

> Documentation cannot close the wound.  
> It can stop maintainers from insisting the blood is a feature.

Canonizing a contradiction is valuable when immediate structural
repair is unavailable.

It becomes dangerous when confession is mistaken for absolution.

## Structured Hope

**Structured hope** is a concrete proposal, issue, design note, hook,
or convention that gives a desired property inspectable form without
yet binding authoritative behavior.

Examples include:

* an issue proposing structured build results;
* a document specifying a future artifact manifest;
* an optional validation script;
* a local repository hook;
* a design sketch for alternate-root semantics;
* a test that exists but does not block release.

Structured hope is better than ambient desire.

It gives the ecosystem something precise to review, dispute, refine,
and eventually implement.

It remains hope.

> Hope with headings is still hope.

## Structural Hope

**Structural hope** is sustained effort to create or strengthen the
binding surfaces through which observations can become system
evolution.

The distinction is useful:

* **structured hope** gives a desired future form;
* **structural hope** creates the path by which that form can acquire
  authority.

A well-written issue is structured hope.

A project changing its APIs, repository gates, migration process, and
review rules so issues of that class can become enforceable contracts
is structural hope.

One names the destination.

The other constructs a road not made entirely of maintainers
remembering to turn left.

## Guardrail

A **guardrail** is a binding mechanism that prevents or contains a
known failure class.

Examples include:

* refusing ambiguous command combinations;
* rejecting incomplete metadata;
* requiring an artifact manifest;
* blocking publication when dependency declarations are inconsistent;
* verifying that transaction state matches filesystem state;
* preventing lifecycle scripts from executing in an undefined context.

A guardrail is doctrine given a body.

It survives:

* operator turnover;
* forgotten rationale;
* incomplete documentation;
* maintainer mood;
* the arrival of somebody who has never read the sacred IRC log.

A guardrail need not solve the entire model.

It may simply prevent the ecosystem from entering a state known to be
unreasonably difficult to interpret.

## Memory Prosthesis

A **memory prosthesis** preserves a lesson without necessarily
enforcing it across the shared ecosystem.

Examples include:

* a local pre-commit hook;
* an optional validation script;
* a maintainer checklist;
* an editor configuration;
* a warning comment;
* a personal wrapper that detects a dangerous case.

Memory prostheses are useful.

Humans forget.
Tools that help them remember are good tools.

The distinction is one of authority and scope.

A local hook installed by one maintainer may protect that maintainer's
workflow.
It does not automatically protect:

* other clones;
* automated imports;
* release machinery;
* downstream repositories;
* operators who never installed it.

> A hook in your clone is not project law.  
> It is your future self leaving a note beside the trapdoor.

## Field Symptom: The Perfect Issue

An operator discovers that a package operation behaves differently
depending on whether a target root already contains a package
database.

The operator writes an issue containing:

* a reproducible test;
* expected behavior;
* actual behavior;
* affected codepaths;
* a proposed model;
* migration concerns;
* failure cases.

The diagnosis is accepted.

Nothing changes.

Why?

Possible reasons include:

* no component clearly owns the complete operation;
* fixing it requires incompatible changes across several repositories;
* no test blocks the old behavior;
* no artifact carries the context required to decide correctly;
* compatibility policy forbids rejection;
* the issue tracker has no path into release planning;
* every maintainer agrees in principle and owns only one fragment.

The issue is not useless.

It is structured hope and institutional memory.

But the system has no binding surface at which the diagnosis can
become one coherent change.

The problem is not lack of signal.

The signal has nowhere to land.

## Field Symptom: The Optional Hook

A maintainer writes a hook that rejects malformed package metadata.

The hook works perfectly.

The maintainer announces:

> We now prevent malformed metadata.

But the hook:

* is not installed automatically;
* runs only in local interactive commits;
* does not run during imports;
* does not protect the authoritative remote repository;
* can be bypassed by automation;
* is unknown to downstream maintainers.

The ecosystem does not yet prevent malformed metadata.

One maintainer has acquired a memory prosthesis.

That may be the correct first step.

It becomes authority laundering when the local protection is presented
as a system-wide invariant.

## Do Not Confuse

**A binding surface** is not necessarily centralized.

Several components may each bind the part of the contract they own.

**Documentation** is not useless because it cannot enforce behavior.

Accurate documentation preserves knowledge, reduces hallucination, and
supports review.
It simply performs a different function.

**An issue** is not a failed artifact because it does not immediately
change code.

Issues can preserve contradictions, proposals, and design history.

They become pathological when filing them substitutes indefinitely for
creating a path to implementation.

**A guardrail** is not the same as a complete model.

Rejecting an incoherent state may be the honest response while a full
model remains unavailable.

**A warning** is not automatically a guardrail.

A warning still permits the state.

Sometimes this is appropriate.
Sometimes it is a machine politely announcing that the operator is
about to inherit the architecture.

**A test** is not automatically binding.

A test that reports failure but does not block integration may be an
observer, not a regulator.

**Consensus** is not enforcement.

Five maintainers agreeing that a state is invalid does not make the
state mechanically unreachable.

## Binding Strength

Binding surfaces differ in strength.

A useful rough scale is:

| Level | Form | Effect |
| ----- | ---------------------------------- | ------------------- |
| **narrative** | documentation, comments, discussion | informs interpretation |
| **advisory** | warnings, optional checks | influences behavior |
| **procedural** | required review, mandatory workflow | constrains participation |
| **mechanical** | parser rejection, schema validation, transaction constraints | constrains representable state |
| **architectural** | model and interfaces make the invalid state structurally unavailable | removes the failure class |

Stronger is not always better.

A system should not mechanically forbid legitimate variation merely
because enforcement is satisfying.

The correct strength depends on:

* the severity of failure;
* the cost of false rejection;
* the maturity of the model;
* operator sovereignty;
* migration constraints;
* whether the ecosystem can define the invalid state precisely.

The lesson is not:

> Turn every opinion into a parser error.

The lesson is:

> Know whether a rule is advice, procedure, enforcement, or
> architecture.

## Symbolic Binding

**Symbolic binding** occurs when an ecosystem creates an artifact that
looks authoritative without giving it operational force.

Examples include:

* a policy document nobody must follow;
* a test suite not connected to integration;
* a roadmap without ownership;
* a schema that producers may ignore;
* a deprecation with no migration or removal path;
* a review checklist completed after publication.

Symbolic binding can create institutional comfort.

The project sees the correct words in the correct repository and
concludes the rule now exists.

> The invariant has been rendered beautifully in Markdown.  
> Runtime remains unconvinced.

## Boundary Between Memory and Enforcement

A healthy ecosystem needs both memory surfaces and binding surfaces.

Memory explains:

* why the rule exists;
* what failure it prevents;
* what trade-off was chosen;
* when the rule may need revision.

Enforcement preserves:

* the current accepted states;
* the current operational contract;
* the current boundary against accidental regression.

Enforcement without memory becomes cargo cult.

Memory without enforcement becomes folklore.

Together they allow a lesson to survive without becoming either
unquestionable ritual or repeatedly rediscovered pain.

```text
autopsy
    ↓
documented lesson
    ↓
explicit contract
    ↓
binding surface
    ↓
guardrail
    ↓
future evidence
    ↓
revised contract
```

This is not permanent closure.

A binding surface should remain revisable when new evidence shows the
model is incomplete.

The objective is not to freeze truth.

It is to make the current truth operationally visible.

## The Binding Test

For any claimed rule or lesson, ask:

1. Where is the rule stated?
2. Which layer owns it?
3. Which operations encounter it?
4. What mechanism applies it?
5. Can the mechanism reject or transform invalid state?
6. Does it protect the authoritative path?
7. Can alternate paths bypass it?
8. Is it mandatory, optional, or merely conventional?
9. What happens when it fails?
10. Does the ecosystem describe its actual binding strength honestly?
11. Is the mechanism a shared guardrail or a local memory prosthesis?
12. Can future maintainers discover why it exists?

This test prevents the project from confusing knowledge with control.

## Fourth House Law

> A lesson without a binding surface becomes folklore with good
> typography.

The next question is what exactly should bind at that surface.

That leads to **Contracts and Invariants**: how the system turns
desired meaning into owned behavior, and why “everybody knows what
this command means” is not yet an execution model.

---

# Contracts and Invariants

The command accepts the input.

The operation begins.

Halfway through, one component discovers that the requested state
cannot be represented coherently.

It prints a warning, performs the representable half, and exits
successfully.

The documentation calls the operation supported.

The maintainers call the input unusual.

The operator calls the backup.

---

## Contract

A **contract** is an explicit statement of behavior owned by a
component or system boundary.

A useful contract identifies:

* accepted inputs;
* rejected inputs;
* authoritative state;
* produced outputs;
* permitted state transitions;
* failure conditions;
* observable consequences;
* guarantees that callers may rely upon.

A contract does not need to describe every implementation detail.

It needs to describe enough behavior for another layer to compose with
it without reconstructing hidden assumptions.

> A contract tells the caller where reasoning may stop.

Without that stopping point, every caller must continue downward into
implementation, configuration, history, or folklore.

## Contract Scope

Every contract has a scope.

A component may guarantee:

* syntax but not semantic validity;
* file extraction but not package installation;
* package construction but not repository publication;
* state mutation but not service activation;
* local execution but not alternate-root behavior.

Narrow contracts are not inherently weak.

A narrow contract that is explicit and complete within its scope is
stronger than a broad contract assembled from implications.

The problem begins when the interface advertises one operation while
the implementation owns only several disconnected fragments.

> The command name says “install”.  
> The contract says “some files may become emotionally associated with
> a directory”.

## Contract Boundary

A **contract boundary** is the point at which one layer's obligations
end and another layer's obligations begin.

A clean boundary answers:

* what enters;
* what leaves;
* what remains internal;
* what failures cross;
* which facts survive the crossing;
* which layer owns recovery.

When these answers are implicit, callers begin rebuilding internal
knowledge outside the component.

That is how an implementation detail acquires diplomatic immunity.

## Invariant

An **invariant** is a property mechanically preserved across the state
transitions for which the system claims responsibility.

Examples include:

* every installed package has one database record;
* every published artifact has an identity manifest;
* a transaction either commits completely or leaves authoritative
  state unchanged;
* dependency resolution and installation observe the same target
  state;
* malformed package names cannot enter an authoritative repository;
* an artifact's recorded checksum matches its contents.

An invariant is not merely a true statement about the current state.

It is a property the system actively prevents itself from violating.

> An invariant is a contract capable of punching back.

## Contract and Invariant

Contracts and invariants are related but not identical.

A contract describes owned behavior.

An invariant describes a property preserved by that behavior.

For example, a transaction contract may state:

* which operations participate;
* when state becomes visible;
* what failure means;
* how rollback behaves.

The corresponding invariant may be:

> No observer can see a partially committed package transaction.

The contract explains the mechanism's obligations.

The invariant states the property that must survive every permitted
transition.

```text
contract
    defines permitted behavior

implementation
    performs state transitions

invariant
    must survive those transitions
```

A system may have documented contracts without useful invariants.

It may also preserve invariants whose contracts are poorly exposed.

The strongest boundaries possess both.

## Rejection Path

A **rejection path** is the behavior through which the system refuses
an input or transition outside its contract.

Rejection is part of semantics.

A component that cannot support an operation coherently has several
honest choices:

1. reject it;
2. constrain it to a smaller supported form;
3. implement the missing model;
4. expose the unresolved parts to a layer that explicitly owns them.

The dishonest choice is partial acceptance combined with social blame.

> “You should not have done that” is not a rejection path.  
> It is an incident report written in the second person.

A clear rejection path reduces the reachable ambiguity space.

It tells operators and callers:

* this state is outside the model;
* no partial guarantee should be inferred;
* failure occurs before authoritative mutation;
* no folklore is required to discover the boundary.

## Invalid State

An **invalid state** is a state the system's current model explicitly
refuses to represent or preserve.

Invalidity should not be confused with unfamiliarity.

A state is not invalid merely because maintainers dislike it.

To reject a state honestly, the system should be able to explain which
contract or invariant it violates.

Otherwise “invalid” becomes a ceremonial word for “our current tooling
is afraid”.

## Unrepresentable State

An **unrepresentable state** is a state excluded structurally by the
model or data representation.

This is stronger than runtime rejection.

For example:

* a typed result object may require artifact identity;
* a transaction type may prevent commitment before validation;
* a schema may require version and architecture fields;
* an API may expose separate host and target contexts rather than one
  ambiguous `root` string.

When invalid states are unrepresentable, correctness no longer depends
on every caller remembering to perform the same checks.

This is powerful.

It is also dangerous when the model is incomplete.

A system can eliminate legitimate states merely by refusing to imagine
them.

## Guarded State

A **guarded state** is representable but accessible only after
explicit validation or authorization.

Guarding is useful when:

* the state is legitimate but dangerous;
* migration requires temporary coexistence;
* operator intent matters;
* the model cannot yet encode the distinction structurally;
* compatibility prevents immediate removal.

Guarding is not failure.

Pretending an unguarded state is safe because experienced operators
usually avoid it is failure.

## Soft Invariant

A **soft invariant** is a property preserved mainly through
convention, review, operator discipline, or social sanction.

Examples include:

* maintainers do not publish packages with ambiguous names;
* operators never invoke two flags together;
* lifecycle scripts avoid touching the host during alternate-root
  installation;
* repository contributors remember to update related metadata.

Soft invariants are real control mechanisms.

They simply execute in human memory and social process.

Their cost appears as:

* onboarding burden;
* review burden;
* inconsistent enforcement;
* dependence on experienced participants;
* vulnerability to turnover;
* repeated rediscovery.

> A soft invariant is an invariant with a biological implementation.

The term should not be used to excuse missing enforcement.

It should identify where enforcement actually lives.

## Invariant Surface

An **invariant surface** is a boundary across which a preserved
property remains valid and visible.

Suppose a build component guarantees that every successful build
produces exactly one artifact with structured identity.

That guarantee is useful only if the identity crosses the component
boundary in a form callers can consume.

If callers must infer it from stdout or filenames, the invariant may
exist internally while disappearing at the surface.

A property trapped inside one component is not yet an ecosystem
contract.

## Invariant Debt

**Invariant debt** is future instability accumulated by relying on
properties that are important but not mechanically preserved.

Each unenforced assumption creates recurring obligations:

* operators must remember it;
* reviewers must detect violations;
* wrappers must compensate;
* documentation must warn;
* support channels must explain;
* future interfaces must preserve accidental behavior.

The debt does not consist only of future code.

It includes every human cycle spent keeping the assumption alive.

## Contract Erosion

**Contract erosion** is the gradual weakening of an owned behavioral
boundary.

It often begins innocently:

* one edge case is tolerated;
* one compatibility exception is added;
* one caller depends on undocumented output;
* one warning replaces rejection;
* one temporary bypass becomes necessary for release.

Over time, the contract remains in documentation while operational
behavior acquires exceptions no single layer owns.

The boundary still has a name.

It no longer has enough force to stop anything.

## Partial Correctness

**Partial correctness** is correct behavior within a limited subset of
inputs or states.

Partial correctness is legitimate when the supported subset is
explicit and unsupported cases are rejected.

It becomes semantic counterfeit when the interface suggests a broader
contract and allows unsupported cases to proceed far enough to look
valid.

```text
honest partial correctness
    narrow contract
    explicit boundary
    early rejection

counterfeit completeness
    broad interface
    implicit boundary
    partial mutation
    operator blame
```

A constrained primitive is often preferable to counterfeit
completeness.

## Constrained Primitive

A **constrained primitive** exposes deliberately limited semantics
that the system can enforce completely.

It is weaker than a complete model.

It is stronger than an abstraction that pretends to unify states it
cannot reconcile.

For example, a package tool may support installation only into the
currently running root.

That is restrictive.

It may nevertheless be coherent.

Adding `--root` without defining dependency state, script context,
database ownership, and runtime observation does not automatically
produce a more capable model.

It may produce one string carrying four incompatible promises.

> A smaller truth is better than a larger lie.

## Real Model

A **real model** is a coherent authority surface whose contracts and
invariants cover the operation it claims to represent.

A real alternate-root model, for example, must define:

* host context;
* target context;
* dependency context;
* database ownership;
* filesystem mutation;
* lifecycle execution;
* path interpretation;
* failure and rollback;
* artifact and state discovery.

The model need not choose only one possible policy.

It must make the policy explicit and compositionally available.

## Invalid Abstraction

An **invalid abstraction** presents several incompatible authority
domains as one coherent operation.

The problem is not merely that implementation is incomplete.

The abstraction itself implies a unity the system does not possess.

Typical symptoms include:

* one flag changing only some phases of an operation;
* one result reconstructed from several unrelated representations;
* one transaction recorded across incompatible databases;
* one interface accepting states different callers interpret
  differently;
* one success status covering partially completed work.

> An invalid abstraction is a group photo of components that have
> never met.

## Field Symptom: The Successful Half-Install

A package operation performs these steps:

1. extracts files into a target root;
2. resolves dependencies against the host database;
3. executes lifecycle scripts on the host;
4. fails to register the package in the target database;
5. exits with a warning rather than failure.

What is the contract?

Possible interpretations include:

* files were copied;
* a package was installed;
* the target became operational;
* dependency state is now satisfied;
* lifecycle changes belong to the host;
* the operation partially succeeded.

The interface supplies no authoritative answer.

The system permitted several interpretations to survive one command.

This is not merely a bug in step four.

The operation lacks a contract capable of classifying its own result.

## Field Symptom: The Forbidden Flag Combination

A command accepts:

```text
tool --install --root=/mnt --run-scripts
```

Maintainers know the combination is unsafe.

The parser accepts it.

The man page does not forbid it.

The implementation performs host-visible scripts against
target-visible files.

After an incident, the operator is told:

> Nobody uses those options together.

The ecosystem has a soft invariant:

> Operators do not combine those flags.

The interface has no rejection path.

The documentation does not confess the boundary.

The system accepts the state and later denies responsibility for its
meaning.

That is authority laundering.

## Do Not Confuse

**A contract** is not merely documentation.

Documentation may express the contract. Behavior must own it.

**An invariant** is not any desirable property.

A desirable property becomes an invariant only when the system
mechanically preserves it.

**A soft invariant** is not imaginary.

It is a real property implemented through human coordination.

**Strict rejection** is not always good design.

Rejecting legitimate variation because the model is too narrow may be
ontology capture.

**Broad acceptance** is not always flexibility.

An interface that accepts a state it cannot interpret may only be
postponing rejection until after mutation.

**An edge case** is not automatically outside the contract.

Sometimes an edge case reveals that the contract was never stated
clearly enough.

**Backward compatibility** is not automatically contract preservation.

Compatibility may preserve behavior that was never intended to become
authoritative.

## The Contract Test

For any claimed operation, ask:

1. What exactly does the operation promise?
2. Which inputs are valid?
3. Which inputs are rejected?
4. Which state transitions may occur?
5. Which properties must remain invariant?
6. What counts as success?
7. What counts as failure?
8. Can partial success exist?
9. If so, how is it represented?
10. Which component owns each phase?
11. Which facts cross each boundary?
12. Can callers stop reasoning at the contract?
13. Which assumptions are mechanically preserved?
14. Which assumptions remain soft invariants?
15. What happens when the implementation encounters a state outside
    the model?
16. Does the interface advertise more coherence than the system owns?

A contract is useful when these questions produce stable answers.

If every answer begins with “normally”, the system has probably
written its execution model in folklore.

## Fifth House Law

> Hope is not an invariant.

A desired property, a documented intention, and a widely shared
expectation may all be valuable.

None becomes an invariant until the system can preserve it against
mistakes, turnover, unusual inputs, and operators who have not read
the correct decade of IRC logs.

The next section is **Normalization Contracts**: how varied inputs are
converted into stable meaning before they are permitted to mutate
authoritative state.

---

# Normalization Contracts

Two archive backends extract the same package.

The first preserves ownership, extended attributes, and hard-link
relationships.

The second rewrites ownership, ignores extended attributes, and turns
one hard link into two independent files.

Both return success.

The package manager reports the same operation.

The installed systems are not the same.

The ecosystem does not have two interchangeable backends.

It has two different definitions of installation wearing the same
function signature.

---

## Representation Variance

The same intended meaning can arrive in several representations.

Examples include:

* relative and absolute paths;
* several archive formats;
* different filename conventions;
* symbolic and numeric ownership;
* equivalent dependency expressions;
* configuration assembled from multiple files;
* artifact identity encoded in metadata, filenames, or directory
  structure;
* host and target paths describing different namespaces;
* human-readable and machine-readable results.

Variation is not automatically a defect.

Different representations may be legitimate at an external boundary.
Different backends may expose different native capabilities.
Operators may need several ways to express the same intent.

The problem begins when representational variation crosses into
authoritative state without being reconciled.

> Variation at the entrance is flexibility.  
> Variation inside the state model is usually a future argument.

## Normalization

**Normalization** is the conversion of accepted representational
variation into a stable form the system can reason about consistently.

A normalization step may:

* resolve syntax into explicit meaning;
* make defaults visible;
* translate backend-specific behavior;
* validate required information;
* reject contradictory inputs;
* preserve information needed by later phases;
* produce one internal representation from several external forms.

Normalization is not merely tidying data.

It is the moment where the system decides which differences matter and
which differences must disappear.

For example, these two dependency expressions may be syntactically
different:

```text
foo >= 1.2
foo>=1.2
```

If the system defines them as semantically equivalent, normalization
may convert both into the same structured dependency object.

But these two expressions are not necessarily equivalent:

```text
foo >= 1.2
foo > 1.2
```

A normalizer must preserve the distinction.

The purpose is not to make everything look alike.

The purpose is to produce one stable language without destroying
meaning.

## Normalization Contract

A **normalization contract** defines:

* which external forms are accepted;
* which distinctions are semantically meaningful;
* which distinctions are erased;
* which defaults are applied;
* which information must be preserved;
* which contradictions are rejected;
* which normalized representation downstream layers may rely upon.

The contract sits between varied input and authoritative behavior.

```text
external representations
        ↓
normalization contract
        ↓
stable internal meaning
        ↓
authoritative state transition
```

Downstream components should not need to know which accepted
representation originally carried the meaning.

> The backend is not the invariant.  
> The normalization contract is.

## Normal Form

A **normal form** is the stable representation produced by
normalization.

A useful normal form is:

* explicit;
* complete enough for the operation;
* independent of incidental input syntax;
* stable across supported backends;
* suitable for validation;
* suitable for comparison;
* suitable for serialization when required.

For a package installation, a normal form might include:

* package identity;
* version and release;
* architecture;
* normalized destination paths;
* ownership and mode;
* link relationships;
* extended attributes;
* conflict information;
* lifecycle operations;
* target-state context.

The exact form is architecture-specific.

The important property is that later phases consume the normal form
rather than repeatedly interpreting raw inputs.

## Normalize Before Mutation

Normalization should occur before ambiguous input is allowed to mutate
authoritative state.

The safe sequence is:

```text
input
    ↓
parse
    ↓
normalize
    ↓
validate
    ↓
construct operation plan
    ↓
mutate state
```

The dangerous sequence is:

```text
input
    ↓
partially interpret
    ↓
mutate some state
    ↓
discover ambiguity
    ↓
ask operator what the command probably meant
```

Once mutation begins, ambiguity becomes expensive.

The system may need to:

* roll back files;
* repair databases;
* reconstruct previous ownership;
* undo lifecycle scripts;
* distinguish partial success from failure;
* explain which representation was believed at each phase.

> Ambiguity is cheapest before it touches the filesystem.

## Parse, Normalize, Validate

Parsing, normalization, and validation are related but distinct.

### Parsing

**Parsing** converts syntax into a structured representation.

It answers:

> What did the input say?

### Normalization

**Normalization** resolves accepted variation into stable meaning.

It answers:

> Which differences matter, and what form will the system use?

### Validation

**Validation** determines whether the normalized meaning is permitted
by the current contract.

It answers:

> May this operation proceed?

For example, given:

```text
--root=/mnt/../target
```

Parsing may produce a path string.

Normalization may resolve the path to `/target`.

Validation may then determine whether `/target` is permitted as an
installation root.

Combining all three steps into one opaque function is possible.

Failing to distinguish their responsibilities makes later reasoning
harder.

## Canonicalization

**Canonicalization** selects one representation among several
equivalent representations.

It is one possible normalization technique.

For example:

```text
./usr//bin/../bin/tool
```

may canonicalize to:

```text
usr/bin/tool
```

But canonicalization is not the entire normalization contract.

A complete contract must also decide:

* whether absolute paths are accepted;
* whether `..` may escape a package root;
* how symbolic links affect resolution;
* whether path comparison occurs before or after extraction;
* which namespace defines the root;
* whether the original path should remain visible for diagnostics.

Canonicalization without semantic context can destroy information or
create false equivalence.

> One canonical string does not guarantee one canonical meaning.

## Lossless and Lossy Normalization

Normalization may be **lossless** or **lossy**.

A lossless normalizer preserves every distinction needed to reproduce
the intended meaning.

A lossy normalizer deliberately discards distinctions judged
irrelevant to the contract.

Loss is not automatically wrong.

For example, insignificant whitespace may be discarded safely.

Discarding ownership, capabilities, or hard-link relationships during
package extraction may not be safe if installation semantics promise
to preserve them.

The contract must state which losses are permitted.

Otherwise a backend limitation quietly becomes system policy.

## Backend Capability

A backend may lack capabilities required by the normalization
contract.

The system then has honest choices:

1. reject that backend for the operation;
2. constrain the supported contract;
3. emulate the missing behavior;
4. expose the limitation explicitly to a layer capable of choosing
   policy.

The dishonest choice is to accept the backend, silently degrade
semantics, and continue reporting equivalent success.

> “Supported backend” should mean “satisfies the contract”, not
> “returned zero during testing”.

## Backend Substitution

A backend is substitutable when replacing it does not change the
semantics promised by the surrounding boundary.

This does not mean every backend must behave identically internally.

It means their differences are contained behind the normalization
contract.

```text
backend A ─┐
backend B ─┼─→ normalization contract → stable operation plan
backend C ─┘
```

If callers must branch on backend identity, the substitution boundary
is weak.

If the installed result changes according to backend quirks, the
normalization contract is incomplete or absent.

Backend pluralism without normalized semantics is not modularity.

It is a lottery with plugins.

## Field Symptom: Archive Extraction

A package archive contains:

* a directory;
* a regular file;
* a symbolic link;
* a hard link;
* an extended attribute;
* numeric ownership;
* a path containing `..`.

One extraction backend:

* rejects the escaping path;
* preserves numeric ownership;
* preserves the hard link;
* restores the extended attribute.

Another backend:

* normalizes the path differently;
* maps ownership through the current environment;
* duplicates the hard-linked contents;
* ignores the extended attribute.

The package manager invokes either backend through an interface called
`extract`.

The interface is syntactically uniform.

The installation semantics are not.

The missing layer is not necessarily a better archive library.

The missing layer is a normalization contract stating what package
installation requires from any archive backend.

The contract might require:

* every path resolves beneath the installation root;
* ownership is interpreted numerically;
* link relationships are preserved;
* unsupported metadata causes explicit failure;
* extraction produces a normalized install plan before filesystem
  mutation.

Once that contract exists, backend selection becomes an implementation
decision.

Without it, backend selection changes the meaning of installation.

## Field Symptom: Package Identity

A package may be described by:

* a source directory named `foo`;
* configuration containing `name=foo`;
* an archive named `foo#1.2-1.pkg.tar.gz`;
* metadata declaring `foo`;
* stdout saying `Built foo`;
* repository state indexing the artifact as `foo`.

These representations agree during ordinary operation.

A local configuration overrides the archive filename.

Now they disagree.

Which representation wins?

If each component chooses independently:

* the builder publishes one identity;
* the repository indexes another;
* the installer records a third;
* the operator sees a fourth in the filename.

The system does not have package identity.

It has a committee.

A normalization contract should define:

* which representation is authoritative at each boundary;
* how derived names are produced;
* whether disagreement is rejected;
* which identity travels with the artifact;
* whether callers may infer identity from filenames.

The goal is not to prohibit every alternate representation.

The goal is to stop identity from changing when nobody is looking.

## Field Symptom: Configuration Layers

A component reads configuration from:

1. built-in defaults;
2. a system file;
3. a user file;
4. command-line overrides;
5. environment variables.

Each source is individually simple.

The effective behavior is not.

A normalization contract should produce one explicit effective
configuration before execution.

That normal form should make visible:

* which value won;
* where it came from;
* whether values were appended, replaced, or merged;
* which conflicts were rejected;
* which defaults were applied.

Without normalization, every subsystem may interpret precedence
differently.

The ecosystem then has one configuration syntax and several
operational realities.

## Semantic Adapter

A **semantic adapter** translates one representation or backend
contract into the system's normal form.

A semantic adapter is useful when:

* an external tool cannot be changed;
* migration requires old and new formats to coexist;
* several backends expose different native interfaces;
* compatibility must be contained at one boundary.

A semantic adapter should absorb representation differences.

It should not merely rename functions while leaking every backend
quirk upward.

A thin wrapper is not automatically an adapter.

Sometimes it is only a new location from which to observe the same
problem.

## Compatibility Boundary

A **compatibility boundary** contains legacy representations and
converts them into current semantics.

Healthy compatibility looks like:

```text
legacy representation
        ↓
compatibility adapter
        ↓
current normal form
```

Unhealthy compatibility looks like:

```text
legacy assumption
        ↓
special case in parser
        ↓
special case in planner
        ↓
special case in transaction
        ↓
special case in every caller
```

In the first case, the past is translated at one boundary.

In the second, the past acquires citizenship everywhere.

## Normalization and Policy

Normalization should not silently decide policy that belongs
elsewhere.

For example, a path normalizer may determine that two syntactic paths
refer to the same target.

It should not necessarily decide whether overwriting that target is
permitted.

Likewise, an archive normalizer may expose that metadata cannot be
preserved.

A policy layer may then choose to:

* reject the package;
* warn and continue;
* require an explicit override;
* use another backend.

The distinction is:

* normalization makes meaning explicit;
* policy chooses among explicit meanings.

Mixing them can turn low-level implementation limitations into
invisible system doctrine.

## Normalization Failure

A normalization failure occurs when the system cannot produce one
coherent meaning from the supplied representation.

Examples include:

* two authoritative identity fields disagree;
* a path escapes the permitted root;
* a backend cannot preserve required metadata;
* dependency syntax is ambiguous;
* configuration sources specify incompatible modes;
* host and target contexts cannot be reconciled.

Normalization failure should normally occur before mutation.

It should report:

* which representations conflicted;
* which contract could not be satisfied;
* what information was missing;
* whether a narrower operation remains available.

A good failure message exposes the boundary.

A bad one announces that something somewhere was invalid and invites
the operator to begin divination.

## Do Not Confuse

**Normalization** is not making every input identical.

It preserves meaningful differences and removes incidental ones.

**Canonicalization** is not the whole normalization contract.

A canonical string can still carry ambiguous semantics.

**Validation** is not normalization.

Validation decides whether normalized meaning is permitted.

**A wrapper** is not automatically a semantic adapter.

It must translate into a stable contract rather than merely forward
quirks.

**Backend independence** is not achieved by giving every backend the
same function names.

Substitution requires equivalent promised semantics.

**Normalization** is not centralization.

Each boundary may normalize the forms it owns.

**Lossy normalization** is not automatically wrong.

Unspecified loss is wrong.

**Compatibility** is not inherently haunting.

Compatibility becomes haunting when legacy semantics escape
containment and infect every current layer.

## The Normalization Test

For every boundary accepting varied representations, ask:

1. Which forms are accepted?
2. Which differences are semantically meaningful?
3. Which differences are incidental?
4. What is the normal form?
5. Which information must survive normalization?
6. Which information may be discarded?
7. Which defaults become explicit?
8. Which contradictions cause rejection?
9. Does normalization happen before state mutation?
10. Can every supported backend satisfy the same contract?
11. What happens when a backend lacks a required capability?
12. Are backend limitations exposed or silently converted into policy?
13. Can downstream components ignore the original representation?
14. Can legacy forms be contained at one compatibility boundary?
15. Does failure reveal the violated contract?
16. Is the normalized result available as structured state?

If callers repeatedly inspect raw input after normalization, the
normal form is probably incomplete.

If every backend requires special cases throughout the system, the
normalization boundary is probably fictional.

## Sixth House Law

> The backend is replaceable.  
> The meaning is not.

A successful normalization contract allows implementations,
representations, and compatibility mechanisms to change without
forcing the ecosystem to renegotiate the operation each time.

The next section is **Artifact Truth and Supplier Duty**: how facts
already known by one component should cross a boundary as structured
state instead of being reconstructed from filenames, configuration,
and human narration.

---

# Artifact Truth and Supplier Duty

The build succeeds.

A package archive appears in the output directory.

The builder knows:

* which artifact it created;
* where it placed it;
* which package identity it contains;
* which configuration produced it;
* whether the result is complete.

The orchestrator receives none of those facts.

It scans the directory, parses stdout, rereads the builder's
configuration, and guesses which new file belongs to the operation.

The producer knows.

The consumer guesses.

Architecture has selected divination.

---

## Artifact

An **artifact** is a bounded output expected to carry identity or
operational truth across a system boundary.

Examples include:

* a package archive;
* a root filesystem image;
* a binary;
* a source tarball;
* a repository index;
* a database snapshot;
* a generated configuration;
* a patch;
* a build manifest;
* a signed release file.

An artifact is not merely a file that exists after a command finishes.

It participates in a larger operation.

Other components may need to determine:

* what it is;
* where it came from;
* which version it represents;
* which architecture it targets;
* which inputs produced it;
* whether it is complete;
* whether it can be trusted;
* whether it replaces another artifact;
* which semantics survive when it crosses the boundary.

A file becomes an artifact when another layer must reason about it.

## Artifact Truth

**Artifact truth** is the set of authoritative facts that travel with
an artifact --- or remain mechanically bound to it --- so consumers do
not need to reconstruct its meaning from surrounding circumstances.

Artifact truth may include:

* identity;
* version;
* release;
* architecture;
* format;
* content digest;
* provenance;
* build configuration;
* dependency declarations;
* creation time;
* producer identity;
* compatibility requirements;
* intended destination;
* transaction status.

These facts do not all need to be embedded inside the artifact bytes.

They may exist in:

* an internal manifest;
* a signed sidecar;
* a repository record;
* a transaction result;
* a content-addressed store;
* metadata bound through a digest.

The important property is not physical location.

It is binding.

> Truth may travel beside the artifact.  
> It may not wander nearby hoping consumers understand the
> relationship.

## Bound Metadata

**Bound metadata** is metadata whose relationship to an artifact is
mechanically established.

The binding may use:

* a checksum;
* a signature;
* a transaction identifier;
* a repository object identity;
* an immutable content address;
* an explicit result object;
* an atomic database record.

A sidecar file named similarly to an artifact is not necessarily bound
metadata.

For example:

```text
foo#1.2-1.pkg.tar.gz
foo#1.2-1.pkg.tar.gz.meta
```

The naming relationship is convenient.

It becomes authoritative only if the system verifies that the metadata
describes the actual artifact.

Otherwise one filename is merely vouching for another filename.

## Identity

**Artifact identity** is the stable answer to:

> What artifact is this?

Identity may contain several fields:

```text
name      = foo
version   = 1.2
release   = 1
arch      = x86_64
format    = pkg.tar.gz
```

The exact model depends on the ecosystem.

The important distinction is between identity and presentation.

A filename may present identity:

```text
foo#1.2-1.pkg.tar.gz
```

But filenames are often:

* mutable;
* lossy;
* filesystem-dependent;
* ambiguous;
* derived from configuration;
* unable to carry complete provenance;
* parsed differently by different components.

> A filename is a label.  
> Do not promote it to passport control merely because it contains
> punctuation.

## Identity Authority

The system must define which representation is authoritative for
artifact identity.

Possible candidates include:

* internal artifact metadata;
* build state;
* repository metadata;
* the filename;
* source configuration;
* a transaction result.

Several representations may coexist.

Their relationship should be explicit.

For example:

```text
package metadata
    is authoritative

filename
    is derived from package metadata

repository index
    records the artifact digest and package metadata

build result
    identifies the exact produced artifact
```

If the filename and internal metadata disagree, the contract must
define whether:

* publication is rejected;
* installation is rejected;
* one representation is regenerated;
* the disagreement is reported as corruption.

“Usually they match” is not an identity model.

## Provenance

**Provenance** describes how an artifact came into existence.

Useful provenance may include:

* source revision;
* build configuration;
* tool versions;
* applied patches;
* build environment;
* producer component;
* input artifact digests;
* signing identity;
* reproducibility information.

Not every artifact needs a complete forensic biography.

The required provenance depends on the operation.

A local temporary object may need little.

A published package expected to cross machines and survive years may
need substantially more.

The contract should identify which provenance facts are necessary for:

* verification;
* debugging;
* reproduction;
* migration;
* accountability;
* compatibility.

## Completeness

An artifact may exist without being complete.

For example, a builder may:

1. create the archive path;
2. begin writing content;
3. fail;
4. leave the partial archive behind.

A consumer scanning the directory sees a plausible filename.

The filesystem reports that the file exists.

The build failed.

Artifact truth therefore needs some notion of completion.

Possible mechanisms include:

* writing to a temporary path and renaming atomically;
* recording completion in a transaction;
* returning the artifact only after final validation;
* publishing a manifest after all content is committed;
* verifying the artifact before exposing it to consumers.

> Existence is not completion.  
> A corpse also exists.

## Supplier Duty

**Supplier duty** is the obligation of the component that first knows
a fact to expose that fact in a stable form appropriate to its
consumers.

If a builder knows the exact artifact path, callers should not
normally need to rediscover it.

If an installer knows the resulting package state, later components
should not infer it from filesystem debris.

If a repository knows which digest corresponds to which package
identity, consumers should not reconstruct the relationship from URL
shape.

Supplier duty does not mean exposing every internal detail.

It means publishing the facts required at the boundary the component
claims to support.

> The component that creates the truth should not make every caller
> reenact the crime scene.

## Consumer Duty

Supplier duty has a corresponding **consumer duty**.

A consumer should use the published contract rather than depending on
incidental internal behavior.

If a builder returns a structured artifact result, an orchestrator
should not continue parsing its status text because the old regex
already works.

Consumer duty includes:

* respecting the authoritative representation;
* validating the supplied result;
* avoiding private configuration unless it is part of the contract;
* not inferring additional guarantees from presentation;
* reporting missing facts instead of silently guessing.

A healthy boundary requires both sides.

The supplier must publish enough truth.

The consumer must stop excavating beneath it.

## Structured Result

A **structured result** is a machine-readable representation of an
operation's authoritative outcome.

For a package build, it might contain:

```text
status
artifact_path
package_identity
artifact_digest
manifest_path
warnings
```

The representation may be:

* an in-process object;
* a stable command output mode;
* a result file;
* a transaction record;
* a machine-readable stream;
* an API response.

The specific transport is secondary.

The result must be:

* explicit;
* versioned when necessary;
* unambiguous;
* separate from human narration;
* complete enough for callers;
* honest about partial outcomes.

## Human Narration

Human-readable output serves operators.

It may include:

* progress;
* explanation;
* warnings;
* summaries;
* context;
* humor, when the component has earned it.

Human narration is not a reliable control interface unless the system
deliberately defines it as one.

Narration changes for reasons unrelated to semantics:

* wording improves;
* localization is added;
* progress formatting changes;
* timestamps appear;
* errors become clearer;
* lines are reordered;
* color is introduced.

A consumer depending on narration converts editorial change into
protocol breakage.

## Narrative Coupling

**Narrative coupling** occurs when machine control depends on text
intended for human presentation.

Examples include:

* parsing stdout to find the artifact path;
* searching logs for a success phrase;
* extracting identifiers from warning messages;
* inferring state from command narration;
* using terminal output as the only record of a transaction.

> When stdout becomes protocol, every regex is a tiny priest.

Narrative coupling is attractive because the information appears to
already exist.

But presence is not contract.

A sentence may contain the truth while remaining an unstable way to
carry it.

## Machine-Readable Output

A command-line component may provide machine-readable output through:

* a dedicated option;
* a stable record format;
* a result file;
* a null-delimited field list;
* JSON or another structured representation;
* a library interface.

The format is less important than the contract.

A machine-readable mode should define:

* schema;
* field meaning;
* escaping;
* versioning;
* ordering guarantees;
* failure representation;
* compatibility expectations;
* separation from diagnostics.

Printing JSON does not automatically solve the problem.

Unversioned, underspecified JSON can be folklore wearing braces.

## Opaque-Tool Boundary

An **opaque-tool boundary** allows one component to invoke another
without reproducing the subordinate component's internal semantics.

Opacity is useful.

An orchestrator should not need to know:

* how a builder computes its output directory;
* how package names are assembled internally;
* which temporary files it uses;
* which archive implementation it selected;
* how it orders internal phases.

The builder should publish the facts required by the orchestration
boundary.

Opacity fails when the subordinate component withholds those facts.

The caller then becomes dependent on private configuration and
implementation details.

> A black box is acceptable.  
> A black box that requires callers to guess what came out is merely a
> dark room.

## Artifact-Borne Assurance

**Artifact-borne assurance** means enough authoritative information
crosses with the artifact that later boundaries can verify and
interpret it without fresh social authorization.

For example, a package artifact may carry or bind:

* package identity;
* file manifest;
* digest;
* format version;
* architecture;
* required installation semantics;
* signature.

A repository can then validate the artifact.

An installer can interpret it.

An operator can inspect it.

A later audit can identify it.

Without artifact-borne assurance, every boundary must ask another
component --- or another human --- what the artifact probably means.

## Witness Proliferation

When artifacts carry insufficient truth, ecosystems often add
witnesses.

The build service records a log.

The repository service records another log.

The release process adds a checklist.

A reviewer confirms the filename.

An operator confirms the checksum.

A maintainer confirms the configuration.

Each witness may be locally useful.

The larger pattern is dangerous:

```text
weak artifact truth
        ↓
boundary uncertainty
        ↓
additional witness
        ↓
manual interpretation
        ↓
responsibility diffusion
```

The ecosystem begins mistaking increased witnessing for increased
control.

> If an artifact needs five people to explain what it is, it is not
> self-describing.  
> It is holding a press conference.

## Self-Describing Artifact

A **self-describing artifact** carries enough information for the
operations expected of it.

Self-description is relative to purpose.

A package archive does not need to contain the history of the project.
It may need to expose:

* identity;
* format;
* manifest;
* compatibility requirements;
* integrity information.

A self-describing artifact does not eliminate external state.

Repository policy, trust roots, dependency resolution, and local
configuration may remain external.

The goal is not total ontological independence.

The goal is to prevent consumers from reconstructing facts the
artifact boundary should already preserve.

## Artifact Manifest

An **artifact manifest** is structured metadata describing an
artifact's identity, contents, or required semantics.

A package manifest may include:

* package name;
* version;
* release;
* architecture;
* files;
* ownership;
* modes;
* links;
* checksums;
* lifecycle hooks;
* format version.

A manifest is useful when it is:

* authoritative within its declared scope;
* bound to the artifact;
* validated before use;
* versioned;
* preserved across publication.

A manifest generated only for display and ignored by all operations is
not an authority surface.

It is a very organized rumor.

## Field Symptom: Identity in stdout

A builder prints:

```text
Built package: foo#1.2-1.pkg.tar.gz
```

An orchestrator needs the artifact path.

It captures stdout and extracts the text after the colon.

This works until:

* the message wording changes;
* several artifacts are built;
* a warning prints a similar line;
* output is localized;
* the artifact is placed in another directory;
* the command fails after printing the filename;
* progress output is redirected differently.

The builder possessed the fact.

It published narration rather than state.

The orchestrator converted that narration into an accidental protocol.

## Field Symptom: Reconstructing Identity from Configuration

A builder reads:

```text
name=foo
version=1.2
release=1
compression=gz
```

It creates an artifact.

The orchestrator reads the same configuration and independently
computes:

```text
foo#1.2-1.pkg.tar.gz
```

This avoids parsing stdout.

It does not remove the coupling.

The orchestrator now duplicates:

* naming rules;
* compression suffix rules;
* override precedence;
* version escaping;
* output directory semantics;
* future format changes.

The system has replaced narrative coupling with implementation
coupling.

> The caller stopped reading the priest's announcement.  
> It now studies the priest's private notes.

## Field Symptom: Directory Scanning

A command builds one or more artifacts in a shared output directory.

The caller records the directory contents before the build, scans
again afterward, and treats new files as results.

This fails when:

* concurrent builds run;
* stale temporary files appear;
* a build replaces an existing artifact;
* several outputs are produced;
* unrelated files arrive;
* the build partially fails;
* clock or filesystem ordering is unreliable.

Directory scanning observes environmental change.

It does not identify the authoritative result of one operation.

## Field Symptom: The Orphaned Artifact

A build creates a valid package archive and then fails while writing
repository metadata.

The command exits nonzero.

The artifact remains.

What is its status?

Possible answers include:

* valid but unpublished;
* incomplete operation;
* reusable local artifact;
* forbidden residue;
* candidate for retry;
* untrusted because final validation never ran.

The contract must represent this state.

If the only result is success or failure, callers may either discard
useful output or accidentally publish uncommitted output.

Artifact truth includes lifecycle state, not only identity.

## Transaction Result

A **transaction result** describes the authoritative outcome of an
operation, including any artifacts it produced.

A useful transaction result may distinguish:

* completed artifact;
* partial artifact;
* reused artifact;
* published artifact;
* failed operation with no valid output;
* failed operation with recoverable output.

This allows the system to represent reality without converting every
non-ideal path into either total success or total disappearance.

## Artifact Lifecycle

An artifact may pass through several states:

```text
planned
    ↓
being produced
    ↓
produced
    ↓
validated
    ↓
published
    ↓
installed
    ↓
superseded
    ↓
retired
```

Different ecosystems need different states.

The important point is that existence alone does not define lifecycle.

A file appearing in a directory does not tell consumers whether it is
validated, published, or authoritative.

## Do Not Confuse

**Artifact truth** is not the same as embedding every fact inside the
artifact.

Truth may be carried through bound external metadata.

**A filename** is not useless.

Filenames are valuable human projections and convenient lookup keys.

They become dangerous when consumers treat them as the only
authoritative identity representation.

**Structured output** is not automatically a good contract.

A structure with unstable or undocumented fields is still an
accidental protocol.

**Supplier duty** does not require exposing implementation details.

It requires publishing the facts consumers legitimately need.

**Consumer duty** does not forbid validation.

Consumers should verify supplied facts.
They should not reconstruct them from unrelated evidence unless
recovery is explicitly part of the contract.

**A self-describing artifact** is not a fully autonomous system.

External trust policy and local intent may remain external.

**More metadata** is not automatically better.

Metadata without scope, binding, or consumers becomes sediment.

**A successful command** is not proof of a completed artifact.

Completion must be represented and validated.

## The Artifact Truth Test

For every artifact-producing operation, ask:

1. Which component first knows that the artifact exists?
2. How does it identify the exact artifact?
3. Which identity fields are authoritative?
4. Which representations are derived?
5. How does the fact cross the component boundary?
6. Is the result machine-readable?
7. Is human narration separate from machine state?
8. Is metadata bound to the artifact?
9. How is completeness represented?
10. What happens after partial failure?
11. Can several artifacts be represented?
12. Can concurrent operations be distinguished?
13. Does the artifact carry enough truth for its consumers?
14. Which provenance facts are required?
15. Can consumers validate the supplied result?
16. Are callers duplicating naming or configuration logic?
17. Are callers scanning directories or parsing logs?
18. Can the backend change without forcing consumers to relearn
    identity?
19. Does publication strengthen or replace artifact truth?
20. When representations disagree, which one wins?

If the producer knows the answer but every consumer derives it
independently, supplier duty has failed.

## Seventh House Law

> Good architecture does not encode truth in operator messages.  
> It publishes truth as contract.

An artifact should cross a boundary carrying enough identity, state,
and provenance to remain intelligible without ritual reconstruction.

The next section is **Substitution Boundaries and Opaque Tools**: how
components become genuinely replaceable, why several implementations
do not automatically constitute pluralism, and how ecosystem-wide
substitution differs from one maintainer successfully writing another
wrapper.

---

# Substitution Boundaries and Opaque Tools

A maintainer dislikes the existing orchestration tool.

It is too coupled, too old, too ceremonial, and written in the wrong
language.

So the maintainer writes a replacement.

The new tool:

* reads the same private configuration;
* reconstructs the same artifact names;
* invokes the same commands in the same undocumented order;
* depends on the same output conventions;
* inherits the same failure cases;
* and adds a cleaner command-line interface.

The old tool has been replaced.

The architecture has not noticed.

---

## Substitution

**Substitution** is the replacement of one component by another while
preserving the contract expected by the surrounding system.

A successful substitution may change:

* implementation language;
* internal data structures;
* performance characteristics;
* backend libraries;
* user interface;
* deployment model;
* maintenance ownership.

It should not silently change the semantics promised at the boundary.

```text
component A ─┐
             ├─→ shared contract → surrounding system
component B ─┘
```

The important object is not the implementation.

It is the contract both implementations satisfy.

> Replacement changes the body.  
> Substitution preserves the skeleton.

## Substitution Boundary

A **substitution boundary** is an explicit contract across which one
component can be replaced without forcing callers to reproduce or
revise its internal assumptions.

A useful substitution boundary defines:

* accepted inputs;
* structured outputs;
* failure semantics;
* state ownership;
* artifact identity;
* ordering requirements;
* versioning expectations;
* lifecycle responsibilities;
* compatibility guarantees.

The boundary need not make replacement effortless.

It should make the cost visible and localized.

Without such a boundary, replacement becomes ecosystem surgery.

Every caller must be examined for private knowledge of the component
being replaced.

## Substitutability

A component is **substitutable** when another implementation can
satisfy its contract without requiring changes throughout the
surrounding ecosystem.

Substitutability is not binary.

A component may be:

* substitutable for one operation but not another;
* substitutable only within one version range;
* substitutable only through an adapter;
* technically replaceable but operationally expensive to replace;
* replaceable by one maintainer but not by ordinary ecosystem
  participants.

The relevant question is not merely:

> Can another implementation exist?

It is:

> What must the rest of the ecosystem know or change for that
> implementation to participate?

## Opaque-Tool Boundary

An **opaque-tool boundary** allows callers to use a component without
owning its internal semantics.

A caller may know:

* what operation to request;
* what input contract applies;
* what structured result to expect;
* which failures are possible.

It should not need to know:

* where the component stores temporary files;
* how it computes internal paths;
* which helper commands it invokes;
* how it parses its private configuration;
* which incidental message indicates success;
* which implementation phase happened first.

Opacity is not ignorance.

It is disciplined ignorance made possible by a sufficient contract.

> A good boundary tells the caller everything it needs.  
> A bad boundary forces the caller to become a part-time maintainer of
> the component behind it.

## Black Box

A **black box** is a component whose internal implementation is hidden
or intentionally irrelevant to callers.

A black box is useful only if its boundary carries enough truth.

A component that hides its internals while withholding required
results is not encapsulated.

It is merely uncooperative.

> A black box that does not publish its result is just a dark room
> with a process ID.

## Encapsulation

**Encapsulation** keeps implementation decisions private behind a
stable contract.

Healthy encapsulation allows internal change without forcing callers
to change.

Unhealthy concealment withholds facts callers legitimately require.

For example:

* callers do not need to know how an artifact name is constructed;
* callers do need to know which artifact was produced.

The naming algorithm may remain encapsulated.

The artifact identity cannot.

## Substitution Cost

**Substitution cost** is the total ecosystem cost of replacing one
component with another.

It includes more than implementation work.

Possible costs include:

* writing the replacement;
* adapting callers;
* migrating state;
* converting configuration;
* reproducing hidden behavior;
* retraining operators;
* updating documentation;
* preserving compatibility;
* changing automation;
* validating equivalent failure semantics;
* replacing institutional knowledge;
* maintaining both implementations during transition.

A substitution boundary does not eliminate these costs.

It prevents them from spreading arbitrarily.

## Local Substitution Cost

**Local substitution cost** is the cost paid by the maintainer
creating or adopting a replacement.

A skilled maintainer may write a wrapper in one evening.

The wrapper may work perfectly for that maintainer.

This demonstrates that local escape is possible.

It does not prove that the ecosystem possesses a substitution
boundary.

## Ecosystem Substitution Cost

**Ecosystem substitution cost** is the cost paid across operators,
repositories, tooling, automation, documentation, and dependent
components.

This is the cost relevant to architectural pluralism.

A replacement that requires every operator to:

* rewrite local scripts;
* learn a new configuration model;
* preserve compatibility wrappers;
* understand hidden differences;
* and debug divergent state;

may be locally elegant while remaining ecosystemically expensive.

> “I replaced it” and “it is replaceable” are different claims.

## Private Escape Hatch

A **private escape hatch** is an alternate tool or wrapper that
reduces cost for one maintainer or installation without lowering
substitution cost for the wider ecosystem.

Private escape hatches are useful.

They may:

* prove that another design is possible;
* preserve local survivability;
* provide a migration laboratory;
* expose missing contracts;
* keep work moving while shared infrastructure stagnates.

They become misleading when presented as evidence that the ecosystem
already supports tool pluralism.

## Tool Pluralism

**Tool pluralism** is the coexistence of meaningfully substitutable
components under boundaries that make replacement affordable beyond
their original authors.

Pluralism requires more than several executables.

It requires:

* shared or translatable contracts;
* explicit state ownership;
* stable artifact semantics;
* bounded compatibility work;
* understandable migration;
* low enough substitution cost that alternatives can survive socially.

Several tools may coexist while every one depends on the same hidden
substrate assumptions.

That is diversity of implementation.

It is not yet diversity of architecture.

## Parallel Control Planes

**Parallel control planes** are multiple orchestration or management
layers built around the same underlying components.

They may be legitimate alternatives.

They may also be repeated compensations for a missing shared boundary.

Consider three package frontends.

Each one:

* reads package metadata independently;
* computes dependency order independently;
* invokes the same low-level tools;
* parses their human-readable output;
* maintains its own cache;
* applies slightly different policy;
* compensates for the same missing structured results.

The ecosystem appears pluralistic.

But each frontend has recreated the same priesthood around the same
opaque rituals.

> Three wrappers around one missing contract are not three
> architectures.  
> They are a committee studying the same hole.

## Pluralism as Compensation

**Pluralism as compensation** is apparent tool diversity produced by
missing contracts, high substitution costs, or unresolved
control-plane boundaries.

Each alternative exists because the official path is insufficient.

Each alternative must privately reconstruct the same missing
semantics.

This can still produce valuable experimentation.

The diagnostic distinction is:

* **tool pluralism** lowers ecosystem substitution cost;
* **pluralism as compensation** distributes coping cost among several
  implementations.

One creates alternatives around a shared boundary.

The other creates several local survivability strategies around the
absence of one.

## Interface Compatibility

**Interface compatibility** means another component accepts or
produces the same externally visible forms.

This is necessary for substitution.

It is not sufficient.

Two tools may accept identical commands while differing in:

* state ownership;
* atomicity;
* failure semantics;
* lifecycle execution;
* artifact completeness;
* dependency interpretation;
* concurrency behavior;
* rollback guarantees.

A familiar command-line syntax may conceal incompatible contracts.

> Same flags, different physics.

## Behavioral Compatibility

**Behavioral compatibility** means another component preserves the
semantics callers are entitled to rely upon.

Behavioral compatibility is defined by contract, not by reproducing
every historical accident.

This creates a difficult question:

> Which existing behaviors are contractual, and which are merely
> observed?

Without an explicit answer, replacement projects often preserve too
much or too little.

Preserve too little, and legitimate callers break.

Preserve too much, and every old bug becomes constitutional law.

## Compatibility Surface

A **compatibility surface** is the set of externally observable
behaviors a replacement may need to preserve.

A controlled compatibility surface is:

* explicit;
* versioned;
* documented;
* testable;
* bounded by declared contracts.

An uncontrolled compatibility surface consists of everything any
caller has ever observed.

That surface grows without limit.

> If every observation is a promise, maintenance becomes paleontology.

## Compatibility Adapter

A **compatibility adapter** translates between an old contract and a
new one at a bounded location.

Healthy migration may look like:

```text
old caller
    ↓
compatibility adapter
    ↓
new contract
    ↓
new component
```

The adapter contains legacy semantics so they do not infect the new
component or every caller.

An adapter becomes pathological when:

* it must know every internal detail of both sides;
* it grows indefinitely;
* callers bypass it;
* new features are implemented only through compatibility paths;
* no removal or convergence plan exists.

At that point, the adapter is no longer a bridge.

It is a new country whose primary industry is customs paperwork.

## Semantic Adapter

A **semantic adapter** translates meaning, not merely syntax.

For example, an old interface may return only a filename while a new
interface returns a structured artifact result.

A semantic adapter may:

1. invoke the old component;
2. validate the resulting artifact;
3. reconstruct identity through an explicitly documented legacy rule;
4. produce the new structured result;
5. mark which assurances could not be recovered.

The adapter makes the mismatch visible.

A wrapper that simply renames options while preserving ambiguity is
not a semantic adapter.

It is cosmetic surgery on the same ghost.

## Implementation Coupling

**Implementation coupling** occurs when callers depend on private
details of another component's implementation.

Examples include:

* reading its private configuration;
* duplicating its naming rules;
* depending on internal directory layout;
* invoking undocumented helper commands;
* assuming internal phase order;
* parsing incidental log messages;
* modifying its state database directly.

Implementation coupling raises substitution cost because every
replacement must either reproduce those internals or break callers.

## Contract Coupling

**Contract coupling** occurs when callers depend only on behavior
explicitly promised at the boundary.

All useful composition involves some coupling.

The objective is not zero coupling.

It is coupling to the right thing.

> Components should be coupled by contracts, not by shared childhood
> trauma.

## Hidden Shared Substrate

A **hidden shared substrate** is a lower-level assumption that several
apparently independent tools all depend upon.

Examples include:

* one package database format;
* one repository layout;
* one archive naming convention;
* one lifecycle-script environment;
* one configuration language;
* one implicit dependency model.

The tools may expose different interfaces.

Their architecture remains constrained by the substrate.

This does not make them worthless alternatives.

It does mean their apparent diversity should not be mistaken for
independent semantic models.

## Substrate Capture

**Substrate capture** occurs when assumptions from a lower-level
component become unavoidable throughout higher layers.

The substrate stops being one implementation choice.

It becomes the ontology within which every alternative must think.

Replacing the top-level tool then changes little.

The replacement inherits the same state model, failure shapes, and
compatibility burden.

## Boundary Extraction

**Boundary extraction** is the process of turning hidden coupling into
an explicit contract that can support substitution.

Typical steps include:

1. identify facts callers currently reconstruct;
2. identify private behavior callers depend upon;
3. separate stable semantics from historical accidents;
4. publish structured inputs and results;
5. define failure behavior;
6. normalize state at the boundary;
7. contain compatibility in adapters;
8. migrate callers away from implementation knowledge;
9. test alternate implementations against the contract.

Boundary extraction may happen without rewriting the component.

A small interface change can produce more architectural freedom than a
complete rewrite preserving the same hidden assumptions.

> A rewrite changes the code.  
> Boundary extraction changes what the ecosystem is allowed to know.

## Rewrite Without Extraction

A **rewrite without extraction** replaces implementation while
preserving the same implicit coupling.

It often has these symptoms:

* the new component reads the old private configuration;
* callers remain responsible for artifact discovery;
* the same state database remains semantically undocumented;
* failure behavior changes accidentally;
* compatibility is tested by “does my installation still work?”;
* the replacement author becomes the only person who understands the
  translation.

The new code may still be better.

It may be cleaner, safer, or easier to maintain.

But the substitution boundary remains absent.

The ecosystem has paid reimplementation cost without receiving
architectural decoupling.

## Field Symptom: The New Orchestrator

A maintainer replaces an old package frontend.

The new frontend:

* computes dependency order more cleanly;
* has better error messages;
* uses a modern language;
* exposes a simpler configuration file.

But it still must:

* read private configuration from the low-level package builder;
* infer produced artifacts;
* parse installer output;
* repair database inconsistencies;
* preserve undocumented option interactions.

The replacement improves local maintenance.

It does not lower ecosystem substitution cost because the missing
contracts remain below it.

The correct conclusion is not:

> The rewrite failed.

The correct conclusion is:

> The rewrite improved one component but did not extract the shared
> boundaries.

## Field Symptom: Two Installers

Two package installers accept the same package archive format.

Installer A:

* preserves extended attributes;
* rejects path traversal;
* commits database state transactionally;
* refuses lifecycle scripts in an alternate root.

Installer B:

* ignores extended attributes;
* normalizes paths differently;
* writes database state after extraction;
* runs lifecycle scripts against the host.

They are interface-compatible at the filename level.

They are not behaviorally substitutable under one installation
contract.

A shared package format alone does not create a substitution boundary.

The ecosystem must also define installation semantics.

## Field Symptom: The Replaceable Backend

A system supports three archive libraries.

All three must produce the same normalized install plan before
filesystem mutation.

The system verifies:

* path containment;
* ownership interpretation;
* link relationships;
* required metadata;
* extraction completeness.

One backend lacks support for required extended attributes.

The operation is rejected before mutation.

This is successful substitution.

The backend differs.

The contract does not.

## Field Symptom: The Compatible CLI

A replacement command reproduces every option of an older tool.

Scripts continue running.

But the replacement:

* changes exit-status meaning;
* writes warnings to stdout instead of stderr;
* permits partial success;
* orders operations differently;
* omits one state update.

The CLI is syntactically compatible.

The operation is not semantically compatible.

This is why substitution tests must examine contracts and invariants,
not merely command acceptance.

## Migration Boundary

A **migration boundary** is the controlled interface through which
state or callers move from one contract to another.

A migration boundary should define:

* old and new representations;
* conversion rules;
* unsupported cases;
* rollback or recovery;
* coexistence period;
* authority during transition;
* completion criteria;
* removal conditions for compatibility logic.

Without a migration boundary, the ecosystem may run both semantics
indefinitely.

Every component then needs to understand both.

Transition becomes permanent bilingual confusion.

## Dual Authority During Migration

Migration often creates a period in which old and new representations
coexist.

The system must define which one is authoritative.

Possible models include:

* old state remains authoritative until one atomic cutover;
* new state becomes authoritative and old state is generated for
  compatibility;
* writes occur through one layer that updates both representations;
* coexistence is forbidden and migration occurs offline.

The dangerous model is:

> Both are authoritative, except when they disagree.

That is not dual authority.

That is an invitation to choose whichever answer hurts least during
the incident.

## Replacement Proof

A **replacement proof** is evidence that a boundary supports more than
one implementation without semantic leakage.

Useful evidence includes:

* conformance tests;
* independent implementations;
* migration exercises;
* backend-specific failure injection;
* compatibility tests focused on contracts;
* removal of caller access to private internals;
* successful operation under different implementations.

A single replacement written by the original maintainer is useful
evidence.

It is not complete proof.

The author may unconsciously reproduce knowledge that the boundary
never expressed.

Independent implementations are valuable because they expose hidden
assumptions.

> The second implementation is where the first contract discovers what
> it forgot to say.

## Conformance Suite

A **conformance suite** tests whether an implementation satisfies the
shared contract.

It should test:

* accepted inputs;
* rejected inputs;
* normalized results;
* failure semantics;
* state transitions;
* invariant preservation;
* concurrency behavior where relevant;
* artifact truth;
* migration behavior;
* declared optional capabilities.

A conformance suite does not need to force identical internal design.

It should preserve externally promised meaning.

A test suite written entirely around one implementation's internal
behavior may freeze that implementation rather than validate the
contract.

## Capability Declaration

Different implementations may legitimately support different optional
capabilities.

A **capability declaration** makes those differences explicit.

For example, an archive backend may declare support for:

* extended attributes;
* ACLs;
* sparse files;
* numeric ownership;
* specific compression formats.

The surrounding system can then decide whether the implementation
satisfies the requested operation.

Capability declaration is preferable to optimistic invocation followed
by semantic surprise.

## Do Not Confuse

**Replacement** is not automatically substitution.

The old component can disappear while its assumptions remain
everywhere.

**Several tools** do not automatically create tool pluralism.

Alternatives must reduce substitution cost beyond their original
authors.

**Opacity** is not concealment.

A component may hide implementation details while publishing required
facts.

**Encapsulation** is not withholding.

Facts needed by the boundary are not private merely because the
component discovered them internally.

**Interface compatibility** is not behavioral compatibility.

The same syntax can invoke different semantics.

**A rewrite** is not automatically boundary extraction.

A rewrite may preserve every hidden coupling in cleaner code.

**Compatibility** is not the same as reproducing every accident.

The compatibility surface should be defined by owned behavior.

**An adapter** is not automatically architectural debt.

A bounded adapter may be the cleanest migration mechanism.

**Substitution cost** is not only developer effort.

Operator learning, state migration, automation, and institutional
memory also count.

**A shared substrate** is not automatically bad.

It becomes capture when alternatives cannot define or replace its
semantics.

## The Substitution Test

For any allegedly replaceable component, ask:

1. What contract must a replacement satisfy?
2. Which inputs are stable?
3. Which results are structured?
4. Which failure semantics are promised?
5. Which state does the component own?
6. Which internal details do callers currently know?
7. Do callers read private configuration?
8. Do callers reproduce naming or path rules?
9. Do callers parse narration?
10. Can an independent implementation satisfy the boundary?
11. Is there a conformance suite?
12. Are optional capabilities explicit?
13. Which historical behaviors are contractual?
14. Which are accidental?
15. Can compatibility be contained in one adapter?
16. How is state migrated?
17. Which representation is authoritative during migration?
18. What is the local substitution cost?
19. What is the ecosystem substitution cost?
20. Does the replacement reduce hidden coupling, or merely reproduce
    it?
21. Can ordinary operators choose among implementations without
    becoming integration engineers?
22. Does the ecosystem gain pluralism, or another private escape
    hatch?

If the replacement requires intimate knowledge of the old component,
the boundary is not yet extracted.

If only the replacement author can operate the alternative, the
ecosystem has not acquired pluralism.

It has acquired another specialist.

## Eighth House Law

> A second implementation does not prove a boundary exists.  
> It often proves how much undocumented knowledge the first maintainer
> carried.

Substitution becomes architectural only when meaning survives the
replacement without requiring the ecosystem to reenact the original
implementation.

The next section is **Boundary Extraction and Semantic Containment**:
how to move from implicit coupling toward explicit contracts without
building a grand abstraction that claims more coherence than the
system can actually enforce.

---

# Boundary Extraction and Semantic Containment

Three components depend on the same hidden behavior.

Each reads the same configuration.

Each reconstructs the same artifact name.

Each handles one edge case differently.

A maintainer proposes a shared abstraction.

The new abstraction accepts every existing option, preserves every
historical quirk, supports every backend, and promises to unify the
entire operation.

Six months later, the ecosystem has acquired:

* the old hidden coupling;
* a new abstraction layer;
* three compatibility modes;
* and a configuration option called `legacy_semantics`.

The boundary was not extracted.

The ambiguity received an office.

---

## Boundary Extraction

**Boundary extraction** is the process of turning implicit coupling
into an explicit, owned contract.

It begins by asking:

* Which facts already cross this boundary?
* Which facts should cross it?
* Which component first knows them?
* Which assumptions are callers reconstructing?
* Which behavior is stable enough to promise?
* Which behavior should be rejected, contained, or left explicitly
  local?

The purpose is not to move every behavior into one new component.

The purpose is to make the existing semantic relationship visible
enough to reason about, validate, and eventually replace.

> Boundary extraction is not adding a layer.  
> It is discovering which layer was already there in human memory.

## Hidden Boundary

A **hidden boundary** exists whenever components interact through
behavior that has not been represented as a contract.

Examples include:

* a caller reading another component's private configuration;
* an orchestrator depending on command order;
* a repository assuming a filename convention;
* an installer assuming one archive backend's path behavior;
* lifecycle scripts assuming a host context;
* maintainers agreeing that two options must never be combined;
* operators knowing which warning means success.

The boundary exists operationally.

It is merely undocumented in the system's structure.

A hidden boundary does not disappear because all current maintainers
understand it.

That only means the boundary has been implemented in shared nervous
tissue.

## Extraction Target

An **extraction target** is the smallest coherent semantic
relationship worth making explicit.

Good extraction targets are narrow.

Examples include:

* “return the exact artifact produced by this build”;
* “normalize archive entries into an installation plan”;
* “define which root owns dependency state”;
* “publish package identity independently of filename presentation”;
* “reject lifecycle execution when its context is undefined”;
* “declare which repository metadata is authoritative”.

Bad extraction targets usually sound like:

* “abstract packaging”;
* “unify all backends”;
* “create one interface for every operation”;
* “solve alternate roots generically”;
* “make the whole toolchain pluggable”.

These may eventually become legitimate projects.

They are not useful first boundaries.

> Extract the nerve before designing the replacement skeleton.

## Minimal Honest Boundary

A **minimal honest boundary** exposes the smallest contract that:

* removes a real hidden coupling;
* preserves the facts callers legitimately need;
* rejects unsupported meanings;
* does not imply broader coherence than the system owns.

Suppose a builder knows the produced artifact path.

A minimal honest boundary may simply provide:

```text
build()
    → success
    → artifact path
    → artifact identity
    → digest
```

It does not need to solve:

* repository publication;
* dependency policy;
* installation;
* signing;
* remote distribution;
* every future artifact type.

Those may belong to later boundaries.

The first obligation is to stop callers from parsing a sentence to
discover which file exists.

## Boundary Closure

**Boundary closure** occurs when the system explicitly defines what a
boundary accepts, rejects, and guarantees.

A closed boundary does not need to support every meaningful state.

It needs to classify every state that reaches it.

Possible classifications include:

* accepted;
* normalized;
* rejected;
* unsupported;
* delegated to another explicit authority;
* preserved as opaque local policy.

An implicit boundary avoids closure by leaving edge cases socially
negotiable.

That feels flexible until two components negotiate differently.

> An open boundary says, “anything may happen”.  
> An implicit boundary says, “anything may happen, but we will blame
> you personally”.

## Semantic Containment

**Semantic containment** limits an abstraction to meanings the system
can actually enforce.

Containment prevents unsupported semantics from escaping into callers,
artifacts, state, and ecosystem expectation.

It may involve:

* narrowing an interface;
* separating two contexts;
* rejecting ambiguous combinations;
* converting legacy forms at one adapter;
* keeping backend quirks behind a normalization layer;
* refusing to expose partial behavior as one coherent operation;
* marking an output as incomplete or unverified;
* leaving local policy with the operator while binding the contract
  around it.

Semantic containment is not timidity.

It is refusing to grant citizenship to meanings the system cannot
govern.

## Containment Boundary

A **containment boundary** is the point beyond which an internal
ambiguity, legacy behavior, or backend-specific quirk is not permitted
to propagate.

For example:

```text
legacy package filename
        ↓
compatibility parser
        ↓
normalized package identity
        ↓
current system
```

The legacy syntax remains accepted.

Its peculiarities do not become mandatory knowledge for every current
component.

Without containment:

```text
legacy filename rule
        ↓
builder special case
        ↓
repository special case
        ↓
installer special case
        ↓
orchestrator special case
        ↓
operator folklore
```

The past is no longer supported.

It is reproducing.

## Containment Breach

A **containment breach** occurs when internal or legacy semantics
escape the boundary intended to isolate them.

Typical symptoms include:

* callers branching on backend identity;
* normalized state still requiring raw input inspection;
* compatibility flags appearing in unrelated components;
* repository policy depending on builder internals;
* operator documentation explaining private implementation order;
* every replacement reproducing one historical quirk.

A breach does not necessarily mean the boundary design was wrong.

It may mean the normal form is incomplete, the contract is too weak,
or one caller has quietly tunneled under the fence.

> Every abstraction has one caller who believes “private” means “not
> yet useful enough”.

## Semantic Spill

**Semantic spill** is the spread of meaning beyond the layer that
should own it.

Examples include:

* archive semantics spilling into package policy;
* build configuration spilling into orchestration;
* database layout spilling into operator workflows;
* repository naming spilling into package identity;
* host assumptions spilling into alternate-root execution.

Semantic spill raises coupling because more layers must understand the
same unstable fact.

Containment reduces spill by translating the fact once and exposing
only the stable meaning.

## Boundary Extraction Is Not Centralization

A frequent mistake is to discover distributed ambiguity and respond by
creating one central component responsible for everything.

This can reduce some coupling.

It can also create:

* a semantic god object;
* a new bottleneck;
* policy capture;
* excessive authority;
* large migration cost;
* a single interface carrying unrelated meanings.

Boundary extraction asks:

> Which responsibility already exists, and where can it be owned
> honestly?

It does not ask:

> Which daemon deserves to become emperor?

A distributed system can have clean boundaries.

A centralized system can contain several invisible fractures.

The number of processes is not the issue.

The clarity of authority is.

## Boundary Extraction Is Not Wrapper Proliferation

A wrapper may help expose a boundary.

For example, a wrapper around a legacy builder may convert its
unstable output into a structured result.

That is useful when the wrapper:

* owns the translation explicitly;
* validates the result;
* contains legacy behavior;
* publishes a stable contract;
* has a migration path.

A wrapper does not extract a boundary when it:

* forwards every option unchanged;
* preserves every ambiguity;
* parses narration without validating state;
* requires callers to understand the wrapped tool anyway;
* becomes another place where quirks accumulate.

> A wrapper is not a boundary merely because the call stack got
> taller.

## Boundary Extraction Is Not Documentation

Documentation can identify a hidden boundary.

It can explain:

* current behavior;
* known contradictions;
* authority distribution;
* migration constraints;
* unsupported states.

This is necessary work.

But documentation alone does not extract the boundary.

The extraction occurs when the semantic relationship acquires:

* structured inputs;
* structured outputs;
* explicit ownership;
* rejection behavior;
* validation;
* tests;
* migration paths.

Documentation confesses the hidden contract.

Engineering gives it a body.

## Extraction Seam

An **extraction seam** is a location where hidden coupling can be
intercepted and converted into an explicit contract with limited
disruption.

Useful seams often exist where:

* one component already knows a fact before printing it;
* raw input becomes internal state;
* a backend result enters a higher layer;
* a repository accepts an artifact;
* a database mutation begins;
* a compatibility format is parsed;
* an orchestrator invokes a subordinate operation.

A good seam has leverage.

One change can remove duplicated reconstruction from several callers.

For example, changing a builder to publish a result file may
eliminate:

* stdout parsing;
* output-directory scanning;
* filename reconstruction;
* private configuration access;
* ambiguity under concurrent builds.

The best extraction work often looks small in the producer and
enormous in the ecosystem.

## Staged Extraction

Large hidden boundaries are rarely repaired safely in one step.

A staged extraction may proceed as follows.

### 1. Observe the Current Boundary

Identify:

* current callers;
* reconstructed facts;
* private assumptions;
* failure behavior;
* compatibility dependencies;
* operator folklore.

Do not begin by designing the ideal interface.

Begin by discovering the one already being performed socially.

### 2. Name the Stable Meaning

Separate:

* durable semantics;
* implementation accidents;
* local policy;
* historical compatibility;
* unsupported ambiguity.

This is often the hardest step.

Every old behavior has at least one witness willing to call it a
contract.

### 3. Publish the Fact

Expose the needed information as structured state.

Examples include:

* a result object;
* a manifest;
* a normalized plan;
* an explicit context object;
* a versioned record;
* a stable machine-readable output mode.

### 4. Validate the Boundary

Define:

* accepted forms;
* rejected forms;
* required fields;
* disagreement behavior;
* completion state;
* failure semantics.

### 5. Migrate Callers

Move callers from reconstruction to consumption.

A published contract that nobody uses is a museum exhibit.

### 6. Contain Compatibility

Place legacy behavior behind an adapter or compatibility boundary.

Do not make every new caller bilingual.

### 7. Remove Illicit Knowledge

Prevent callers from continuing to read private configuration, parse
narration, or inspect internal layout.

This may require:

* deprecations;
* warnings;
* access restrictions;
* removal of unstable output;
* conformance tests.

### 8. Test Substitution

Use another implementation, backend, or synthetic test double to
reveal facts the contract forgot to express.

### 9. Close the Boundary

Once migration is complete, reject unsupported paths and delete
duplicated reconstruction logic.

Until this step, the old ghost still has keys.

## Field Symptom: Structured Results Added, Coupling Preserved

A builder gains a machine-readable result:

```text
{
  "artifact": "foo#1.2-1.pkg.tar.gz"
}
```

The orchestrator uses it.

Progress.

But the result contains only a filename.

The orchestrator still needs to:

* prepend the output directory;
* infer package identity;
* know the compression suffix;
* determine whether the artifact is complete;
* distinguish several concurrent builds.

The boundary has been partially extracted.

That is still valuable.

The next step is not to declare failure.

It is to identify which facts remain reconstructed and extend the
contract only as far as necessary.

Boundary extraction is iterative.

The first useful contract need not be the final constitution.

## Field Symptom: The Universal Root Object

Maintainers discover that `--root` means different things in different
phases.

They introduce:

```text
RootContext
```

The object contains:

* target path;
* host database;
* target database;
* script root;
* dependency root;
* configuration root;
* runtime root;
* fallback root;
* compatibility mode.

Every function accepts it.

No function agrees which fields are authoritative.

The system has made ambiguity type-safe.

> A struct containing every contradiction is not a model.  
> It is a filing cabinet for unresolved theology.

A better extraction may begin with separate explicit contexts:

```text
BuildContext
InstallContext
DependencyContext
ScriptContext
```

Then define which operations are allowed to compose them.

The goal is not the smallest number of types.

It is the smallest number of lies.

## Field Symptom: Repository Validation

A repository accepts package artifacts.

Historically, maintainers inspect filenames and metadata manually.

The project adds a validation tool.

At first, it runs locally and emits warnings.

Later, the authoritative repository requires it before publication.

The progression is:

```text
folklore
    ↓
memory prosthesis
    ↓
structured hope
    ↓
shared validation
    ↓
binding surface
    ↓
repository invariant
```

The boundary was extracted gradually.

The important transition was not writing the validator.

It was attaching validation to the authoritative publication path.

## Field Symptom: Legacy Format Containment

A package manager must continue accepting an old archive format.

Instead of teaching every subsystem both old and new semantics, it:

1. detects the old format;
2. parses it in a compatibility module;
3. converts it into the current normal form;
4. rejects information that cannot be represented safely;
5. records that compatibility translation occurred;
6. exposes only current semantics downstream.

The old format remains supported.

The current system does not become old internally.

That is containment.

## Constrained Primitive

A **constrained primitive** is often the correct first result of
boundary extraction.

Suppose the ecosystem cannot yet model arbitrary alternate-root
lifecycle execution coherently.

A constrained primitive may allow:

* file installation into a target root;
* database registration in that target;
* no lifecycle scripts;
* no host dependency assumptions;
* explicit rejection of unsupported combinations.

This primitive is less powerful than the advertised universal
operation.

It is more useful than an operation whose semantics change by phase.

> The primitive does less.  
> The operator knows what the less means.

## Semantic Expansion

**Semantic expansion** is the deliberate widening of a contract after
the system acquires enough model and enforcement to support additional
meanings.

A healthy expansion proceeds by:

1. naming the new case;
2. defining its authority and state;
3. extending the normal form;
4. adding validation;
5. defining failure behavior;
6. testing invariants;
7. updating compatibility expectations.

An unhealthy expansion begins by accepting another option and
postponing meaning until somebody reports damage.

## Invalid Abstraction Versus Constrained Primitive

Consider two interfaces.

### Interface A

```text
install(package, root, scripts, deps, config)
```

It accepts every combination but interprets each argument differently
across phases.

### Interface B

```text
install_into_running_system(package)
install_files_into_target(package, target)
```

It supports fewer operations but defines each one completely.

Interface A is broader.

Interface B is more composable.

The difference is not simplicity versus sophistication.

It is counterfeit completeness versus semantic containment.

## Real Model Versus Permanent Constraint

A constrained primitive should not automatically become permanent
doctrine.

Sometimes the system genuinely needs a broader model.

Containment buys time and prevents false guarantees while that model
is designed.

The Fieldbook does not teach:

> Reject everything difficult forever.

It teaches:

> Do not represent an unsolved operation as a solved abstraction.

A constraint becomes pathological when maintainers treat the absence
of a model as proof that the wider problem is illegitimate.

## Boundary Surface Area

Every boundary exposes semantic surface area.

Surface area grows with:

* accepted inputs;
* configurable policy;
* supported backends;
* compatibility modes;
* artifact types;
* lifecycle phases;
* state transitions;
* context combinations.

Each addition requires corresponding invariant capacity:

* validation;
* normalization;
* tests;
* documentation;
* failure semantics;
* migration handling;
* review knowledge.

When semantic surface area grows faster than invariant capacity, the
difference is absorbed by folklore.

```text
semantic surface area
        >
invariant capacity

        ↓

operator compensation
```

The problem is not growth.

The problem is growth without enough structure to own the new
meanings.

## Invariant Budget

An **invariant budget** is the practical capacity of the project to
define, enforce, test, and maintain the contracts exposed by its
interfaces.

The budget includes:

* maintainer attention;
* test infrastructure;
* model clarity;
* review capacity;
* migration support;
* artifact truth;
* observability;
* enforcement mechanisms.

A feature may be individually useful and still exceed the system's
current invariant budget.

The honest options are:

* increase the budget;
* narrow the feature;
* stage the implementation;
* reject the unsupported portion;
* accept explicit debt.

The dishonest option is to expose the feature and finance the missing
semantics with operator memory.

## Over-Abstraction

**Over-abstraction** occurs when a boundary claims to unify more
meanings than the system can preserve coherently.

Symptoms include:

* many optional fields whose combinations are undefined;
* one interface spanning unrelated lifecycle phases;
* configuration replacing explicit types;
* backend-specific branches in every caller;
* “generic” operations interpreted differently by each implementation;
* success statuses too broad to classify outcomes.

Over-abstraction is not caused by abstraction itself.

It is caused by authority claims exceeding invariant capacity.

## Under-Abstraction

**Under-abstraction** occurs when stable shared semantics remain
duplicated across callers because no boundary exposes them.

Symptoms include:

* repeated parsing;
* duplicated naming rules;
* direct database manipulation;
* many wrappers reconstructing the same fact;
* identical validation implemented differently;
* widespread dependence on private configuration.

The system may suffer from over-abstraction and under-abstraction
simultaneously:

* one giant public interface claims too much;
* several critical internal relationships remain implicit.

This is common enough to deserve no surprise.

## Semantic Quarantine

**Semantic quarantine** is temporary containment of behavior whose
contract is not yet understood well enough for general exposure.

Examples include:

* marking an interface experimental;
* limiting a feature to one backend;
* requiring an explicit unsafe flag;
* isolating compatibility code;
* preventing downstream composition;
* refusing publication of artifacts lacking required truth.

Quarantine should include a reason and an exit condition.

Otherwise temporary containment becomes permanent purgatory.

## Do Not Confuse

**Boundary extraction** is not adding an abstraction layer.

The new layer must remove hidden coupling and publish a real contract.

**Semantic containment** is not feature hostility.

It prevents unsupported meanings from becoming accidental promises.

**A constrained primitive** is not automatically good design.

It must still solve a real operation coherently.

**A broad model** is not automatically over-abstraction.

Breadth is legitimate when authority and invariants scale with it.

**Centralization** is not automatically boundary repair.

One central component may simply collect every ambiguity.

**A wrapper** is not automatically coping infrastructure.

A wrapper can be a legitimate semantic adapter when it owns
translation and contains legacy behavior.

**Compatibility** is not failed containment.

Compatibility is healthy when translation remains bounded.

**Rejecting an operation** is not proof that the boundary is honest.

The system must reject according to a stated contract, not maintainer
discomfort.

**Publishing structured data** is not complete extraction.

Callers must stop reconstructing the same facts elsewhere.

**Migration** is not optional.

A new boundary with no path away from the old coupling merely adds
another authority surface.

## The Boundary Extraction Test

For any hidden or proposed boundary, ask:

1. What semantic relationship already exists?
2. Where is it currently implemented?
3. Which parts live in code?
4. Which parts live in operators?
5. Which facts do callers reconstruct?
6. Which component first knows those facts?
7. What is the smallest useful extraction target?
8. Which behavior is stable enough to promise?
9. Which behavior is accidental?
10. Which behavior belongs to local policy?
11. Which states should be rejected?
12. What is the normal form?
13. What is the structured result?
14. Where can compatibility be contained?
15. Which callers must migrate?
16. How will old access paths be removed?
17. Can another implementation satisfy the contract?
18. Does the extraction reduce semantic spill?
19. Does it create a new central authority unnecessarily?
20. Does the interface expose more surface area than the invariant
    budget can support?
21. Is the result a real model, a constrained primitive, or merely a
    wrapper around ambiguity?
22. What evidence will show that the boundary has actually closed?

If the proposed abstraction requires a page of warnings describing
what its arguments do in different phases, the boundary is probably
not extracted.

It has been narrated.

## Ninth House Law

> If the boundary is implicit, eventually someone will piss through
> it.

The purpose of boundary extraction is not architectural cleanliness
for its own sake.

It is to make the place where meaning changes visible before an
operator discovers it experimentally.

---

Part II established where semantics acquire authority, how contracts
bind behavior, how representations become normalized, how artifacts
carry truth, and how substitution becomes possible.

Part III descends into what happens when those structures weaken.

The next section is **Part III: Drift, Ghosts, and Counterfeit
Semantics**, beginning with **Semantic Drift**: how implementation,
documentation, operator expectation, and historical behavior gradually
stop describing the same system.

---

# Part III. Drift, Ghosts, and Counterfeit Semantics

The man page describes one operation.

The implementation performs another.

The package database records part of it.

The filesystem preserves the rest.

A wrapper repairs one historical exception.

An experienced operator knows which representation to trust in each
case.

Every layer is locally reasonable.

Together they no longer describe the same system.

Nothing failed all at once.

The meanings simply stopped arriving at the same destination.

---

# Semantic Drift

**Semantic drift** is the gradual divergence among:

* implemented behavior;
* documented behavior;
* authoritative state;
* artifact meaning;
* operator expectation;
* maintainer intention;
* historical compatibility;
* ecosystem practice.

A system drifts when these representations continue evolving without a
binding process that keeps them mutually coherent.

> Semantic drift begins when the system tells several almost-correct
> stories and nobody owns the disagreement.

Drift is rarely announced.

There is usually no commit titled:

```text
begin seven-year separation between documentation and reality
```

Instead, the divergence accumulates through individually tolerable
changes:

* one compatibility exception;
* one warning instead of rejection;
* one caller parsing an incidental output;
* one backend behaving slightly differently;
* one undocumented override;
* one local workaround copied elsewhere;
* one issue describing a future contract;
* one maintainer remembering what the interface “really means”.

Each change may preserve local survivability.

Together they alter the system's semantic shape.

## Semantic Alignment

A system is **semantically aligned** when its major representations
agree about the operation they describe.

For an installation operation, alignment might require agreement
among:

* the command interface;
* the execution plan;
* the filesystem result;
* the package database;
* the artifact metadata;
* the documentation;
* subsequent query and removal operations.

Alignment does not require every representation to contain identical
information.

It requires their relationships to be explicit and their disagreements
to have defined resolution paths.

For example:

```text
artifact metadata
    defines package identity

package database
    records installed state

filesystem
    contains installed files

documentation
    describes the contract

queries
    derive their answers from authoritative state
```

Each representation performs a different role.

The system remains aligned because those roles agree.

## Divergence

**Divergence** occurs when two representations that should correspond
begin producing different answers.

Examples include:

* an artifact filename and its internal metadata disagree;
* the package database claims a file is installed, but the file is
  absent;
* documentation describes rejection, but implementation accepts the
  state;
* a wrapper treats a warning as success while the underlying component
  treats it as failure;
* the host and target roots disagree about dependency state;
* two frontends interpret the same low-level result differently.

Divergence may be temporary and detectable.

Drift begins when divergence persists, accumulates, or acquires
dependents.

> One disagreement is an incident.  
> A stable population of disagreements is an ecology.

## Drift Is a Process

A bug is an event or defect.

Drift is a process.

A bug may cause drift when:

1. the behavior persists;
2. operators adapt to it;
3. callers depend on it;
4. documentation rationalizes it;
5. compatibility preserves it;
6. future changes treat it as prior art.

The original defect may later disappear.

The adaptations remain.

This is why correcting implementation alone does not always restore
coherence.

The ecosystem may already have learned the old behavior.

## The Drift Sequence

A common drift sequence looks like this:

```text
contract is incomplete
        ↓
implementation chooses one behavior
        ↓
documentation generalizes from the common case
        ↓
operator encounters an exception
        ↓
local workaround preserves survival
        ↓
another component depends on the workaround
        ↓
compatibility preserves the dependency
        ↓
the exception becomes ecosystem behavior
```

At the beginning, the system lacked one explicit decision.

At the end, changing that decision requires migration.

## Drift Surfaces

Drift can occur across several surfaces.

### Interface Drift

**Interface drift** occurs when the practical meaning of an interface
changes while its visible syntax remains stable.

The command still accepts:

```text
--root=/mnt
```

But over time:

* one phase begins reading host configuration;
* another begins writing target state;
* a new lifecycle phase executes outside the target;
* dependency resolution remains host-relative.

The option name is unchanged.

Its semantic radius has expanded.

### Documentation Drift

**Documentation drift** occurs when documentation no longer describes
current operational behavior.

This may happen because:

* implementation changed;
* edge cases accumulated;
* compatibility behavior was never documented;
* proposed behavior was written as present fact;
* old limitations disappeared from memory;
* several components now interpret the same term differently.

Documentation drift is not always neglect.

Sometimes the system itself no longer possesses one stable behavior to
document.

The writer is asked to produce one sentence for an operation with four
authority surfaces.

At that point, prose is being used as semantic compression against
reality.

### State Drift

**State drift** occurs when representations of operational state stop
corresponding.

Examples include:

* package database and filesystem divergence;
* repository index and stored artifacts disagreeing;
* generated configuration differing from declared configuration;
* cached dependency state surviving changes to its source;
* transaction records claiming completion after partial mutation.

State drift is especially dangerous because later operations may
choose different representations as authoritative.

Install trusts the database.

Remove trusts the filesystem.

Upgrade trusts the filename.

Repair trusts whichever answer still has data.

### Artifact Drift

**Artifact drift** occurs when the meaning associated with an artifact
changes or separates from the artifact itself.

Examples include:

* a filename implies one version while internal metadata declares
  another;
* repository metadata describes an artifact that was replaced;
* provenance no longer identifies the actual source revision;
* a package format gains required semantics that old artifacts cannot
  carry;
* sidecar metadata becomes detached from the content it describes.

### Operator-Expectation Drift

**Operator-expectation drift** occurs when experienced operators and
new operators infer different contracts from the same interface.

Experienced operators may know:

* which combinations are unsafe;
* which warning indicates partial success;
* which documented behavior is obsolete;
* which artifact name is misleading;
* which script must run afterward.

New operators read the visible interface.

Both groups are reasoning rationally from different evidence.

The system has divided its semantics by tenure.

### Institutional Drift

**Institutional drift** occurs when a project's current doctrine,
review habits, and design reflexes no longer match the conditions that
produced them.

A restriction may survive after its technical cause disappeared.

A workaround may remain mandatory after the underlying component was
replaced.

A fear of complexity may survive while complexity has already migrated
into operators.

The institution preserves the conclusion and loses the autopsy.

## Contract Erosion

**Contract erosion** is the weakening of an explicit or implicit
behavioral boundary through accumulated exceptions.

A contract may begin clearly:

> A successful installation records every installed file in the
> package database.

Then exceptions appear:

* generated files are not recorded;
* lifecycle-created files are not recorded;
* compatibility files are not recorded;
* files outside the target root are not recorded;
* partial installation still returns success;
* repair mode bypasses registration.

Each exception may have a reason.

Eventually the original statement remains only as introductory prose.

The real contract becomes:

> Most files are recorded, except those produced through paths whose
> history you are expected to know.  
> Contract erosion does not delete the boundary.  
> It makes the boundary negotiable after every incident.

## Exception Accretion

**Exception accretion** is the accumulation of locally justified
special cases around a shared contract.

Exceptions are not inherently wrong.

A mature system often needs:

* compatibility;
* migration;
* hardware-specific behavior;
* recovery paths;
* operator overrides;
* legacy artifact support.

The problem is not the presence of exceptions.

The problem is when exceptions:

* are implemented at several layers;
* lack explicit scope;
* have no removal condition;
* change authoritative behavior silently;
* become visible to unrelated callers;
* outnumber the cases covered by the original rule.

At that point, the exception structure may be more authoritative than
the nominal contract.

## Model Rot

**Model rot** occurs when an abstraction remains in use after its
underlying model no longer corresponds to operational reality.

The interface may still compile.

The command may still run.

The model has lost explanatory power.

Examples include:

* one `root` parameter standing for several execution contexts;
* one package state representing files, database registration, and
  lifecycle effects that can diverge;
* one success status representing complete, partial, and recoverable
  outcomes;
* one repository model covering artifacts with incompatible metadata
  guarantees;
* one dependency expression interpreted differently by several
  solvers.

> Model rot is what happens when an abstraction survives by becoming
> increasingly metaphorical.

A rotten model forces every caller to reinterpret its terms.

The abstraction remains syntactically central while semantic authority
moves elsewhere.

## Semantic Leak

A **semantic leak** occurs when internal behavior becomes required
knowledge outside the component that owns it.

Examples include:

* callers must know archive-backend path rules;
* an orchestrator must know how a builder computes filenames;
* operators must understand database write order;
* repository tools must know temporary-file conventions;
* wrappers must know which warning is emitted before a partial
  success.

A semantic leak increases coupling.

It also creates new authority surfaces because external components
begin making decisions based on internal facts.

## Topology Leak

A **topology leak** occurs when semantics escape the architectural
layer that should own them and begin governing another layer
indirectly.

Examples include:

* build semantics leaking into repository policy;
* repository naming leaking into package identity;
* lifecycle-script behavior leaking into alternate-root topology;
* dependency semantics leaking into wrapper conventions;
* local filesystem layout leaking into artifact contracts.

A semantic leak exposes an internal fact.

A topology leak changes which layer must reason about that fact.

> A leak tells another component too much.  
> A topology leak gives that component a new unpaid job.

## Implicit Coupling

**Implicit coupling** is dependence on behavior that has not been
represented as a shared contract.

Implicit coupling commonly appears as:

* repeated configuration parsing;
* reliance on command order;
* environment-variable assumptions;
* filename interpretation;
* directory scanning;
* database layout knowledge;
* shared process context;
* undocumented success phrases.

Implicit coupling is a primary carrier of drift because each consumer
may preserve and evolve its own interpretation.

## Interpretation Fork

An **interpretation fork** occurs when two consumers derive different
meanings from the same ambiguous behavior.

For example, a low-level tool returns exit status zero with a warning.

Frontend A interprets this as success.

Frontend B treats the warning as partial failure.

A local script ignores both and checks whether one file appeared.

The tool emitted one event.

The ecosystem created three contracts.

## Accidental Protocol

An **accidental protocol** is undocumented behavior that other
components begin depending upon compositionally.

Examples include:

* stdout wording;
* filename shape;
* warning order;
* temporary-directory layout;
* configuration precedence;
* database record ordering;
* timing assumptions;
* exit status combined with filesystem inspection.

Once several components depend on the behavior, changing it becomes a
migration problem.

The protocol was never designed.

It nevertheless acquired clients.

> The most permanent interface is accidental behavior with two
> callers.

## Drift Amplification

Drift amplifies when one ambiguous layer feeds another.

Consider:

```text
builder prints ambiguous result
        ↓
orchestrator guesses artifact
        ↓
repository derives identity from filename
        ↓
installer records filename-derived identity
        ↓
query tool reports database identity
```

One weak boundary becomes several apparently authoritative
representations.

Each downstream layer adds confidence.

None adds truth.

## Partial Success

**Partial success** is an outcome in which some promised effects occur
while others do not.

Partial success is not inherently incoherent.

A system can represent it honestly.

For example:

```text
artifact produced
publication failed
artifact remains valid for local use
```

Drift begins when partial success is collapsed into an
undifferentiated success or failure status.

Different callers then infer different operational meanings.

One retries and duplicates work.

Another publishes the surviving artifact.

Another deletes it.

The result was real.

The contract failed to name it.

## Semantic Lag

**Semantic lag** is the delay between operational change and the
ecosystem's adaptation to its new meaning.

After an interface changes:

* documentation may lag;
* wrappers may lag;
* training material may lag;
* cached state may lag;
* operator expectation may lag;
* compatibility may intentionally preserve old behavior.

Some lag is unavoidable.

A healthy migration manages it explicitly.

Unmanaged lag becomes drift when old and new semantics coexist without
a clear authority rule.

## Compatibility Drift

**Compatibility drift** occurs when behavior preserved for
compatibility gradually becomes indistinguishable from current
contract.

A legacy exception may begin as:

```text
accept old package filename during migration
```

Years later:

* new tools produce the old form;
* documentation teaches it;
* tests require it;
* callers depend on its quirks;
* removing it is called a breaking change.

The compatibility path has stopped translating the past.

It is generating the present.

## Field Symptom: One Flag, Several Meanings

A command introduces:

```text
--ignore
```

Initially, the flag means:

> Ignore this package during one update operation.

Later, callers use it to mean:

* skip dependency resolution;
* preserve an installed version;
* suppress repository selection;
* hide an error;
* prevent automatic removal;
* bypass one validation rule.

The flag remains one string.

Its operational meanings multiply.

Documentation lists examples but cannot state one invariant.

Different subcommands consume the flag differently.

This is semantic overloading followed by drift.

The honest repair may be:

* separate flags;
* separate typed operations;
* a narrower constrained primitive;
* explicit rejection of unsupported combinations.

The dishonest repair is another paragraph beginning with “depending on
context”.

## Field Symptom: The Package Database Is Authoritative

A project states:

> The package database is authoritative.

But operationally:

* installation writes files before database state;
* recovery reconstructs records from the filesystem;
* removal skips missing files silently;
* upgrades infer package identity from archive filenames;
* operators manually edit database records;
* scripts create untracked files.

The statement may still describe the intended model.

It no longer describes the whole control structure.

The system has drifted from:

```text
database is authoritative
```

toward:

```text
database is normally preferred unless another representation contains
more useful evidence during the current incident
```

The correct response is not necessarily to abolish the database.

It is to identify which disagreements are legitimate, which are
corruption, and which operations must restore alignment.

## Field Symptom: The Correct Wrapper

A wrapper repairs a low-level tool's ambiguous behavior.

It:

* validates inputs;
* normalizes configuration;
* rejects unsafe combinations;
* interprets partial success correctly;
* publishes a structured result.

For its callers, the wrapper creates a coherent boundary.

Years later, another caller bypasses it and invokes the low-level tool
directly.

Both paths remain supported.

Now the ecosystem has:

* one coherent contract through the wrapper;
* one historical contract through direct invocation;
* shared state modified by both.

The wrapper was correct.

The ecosystem failed to establish which surface became authoritative.

Local repair without boundary closure created dual semantics.

## Field Symptom: Documentation from Tomorrow

An issue proposes that every built artifact will carry structured
identity.

The documentation is updated early to describe the future model.

The implementation still publishes filenames and stdout.

New callers depend on the documented guarantee.

Maintainers explain that support is “in progress”.

The project has created semantic lag deliberately and represented it
as present truth.

Documentation now describes tomorrow.

Runtime remains loyal to yesterday.

## Do Not Confuse

**Semantic drift** is not all change.

A system can evolve while keeping contracts, state, documentation, and
migration aligned.

**Variation** is not drift.

Several representations or implementations may coexist under explicit
boundaries.

**An exception** is not automatically contract erosion.

A scoped, tested exception with clear authority may be part of the
contract.

**A bug** is not automatically drift.

Drift occurs when divergent meaning persists or acquires dependents.

**Compatibility** is not automatically pathology.

Compatibility becomes drift when legacy behavior escapes containment
or becomes current semantics without explicit adoption.

**Operator knowledge** is not itself drift.

Operators may legitimately own policy and local intent.

Drift occurs when their knowledge compensates for contradictory or
missing system semantics.

**Implementation detail** is not always a semantic leak.

It becomes a leak when external correctness depends on knowing it.

**A wrapper** is not automatically evidence of model rot.

A wrapper may expose a clean boundary. The question is whether the
ecosystem recognizes and closes around that boundary.

## Detecting Drift

Drift often becomes visible through disagreement.

Useful comparisons include:

* documentation versus implementation;
* artifact metadata versus filename;
* database state versus filesystem state;
* producer result versus consumer inference;
* host context versus target context;
* current behavior versus compatibility tests;
* maintainer explanation versus operator expectation;
* two independent callers interpreting the same result.

Independent implementations and new operators are especially valuable.

They lack some of the hidden knowledge that allows drift to remain
invisible.

> The newcomer did not break the system.  
> The newcomer failed to carry the undocumented patch in their nervous
> system.

## Drift Audit

For any important operation, ask:

1. What does the interface claim?
2. What does the documentation describe?
3. What state does the implementation actually mutate?
4. Which representation is authoritative afterward?
5. Which facts travel with the result?
6. Which facts are reconstructed?
7. What do experienced operators know that new operators do not?
8. Which warnings or exceptions have become operationally normal?
9. Which compatibility paths still influence current behavior?
10. Do different callers interpret the same output differently?
11. Are several representations allowed to disagree?
12. How is disagreement detected?
13. Which layer resolves it?
14. Are partial outcomes represented explicitly?
15. Has a once-narrow interface accumulated unrelated meanings?
16. Are implementation details required outside their component?
17. Does documentation describe current behavior or desired behavior?
18. Has a local workaround become a shared dependency?
19. Can an independent implementation infer the contract?
20. Which correction would restore alignment rather than merely hide
    one symptom?

If every maintainer gives a different but historically defensible
answer, the system is not merely complicated.

It has drifted into several local truths.

## Restoring Alignment

Restoring alignment may require:

* identifying one authority surface;
* publishing structured truth;
* normalizing representations;
* rejecting ambiguous operations;
* migrating old state;
* updating documentation;
* containing compatibility;
* removing bypass paths;
* converting soft invariants into guardrails;
* explicitly adopting behavior that was previously accidental.

Restoration does not always mean returning to the original design.

The original design may no longer fit the ecosystem.

The goal is not historical purity.

The goal is one honest present.

## Tenth House Law

> Drift begins when “what the system does” requires a different answer
> from every layer.

Semantic drift explains how meaning separates.

The next section, **Ghosts and Undead Semantics**, examines what
remains after the original contract, rationale, or enforcement
mechanism has already disappeared --- but the ecosystem continues
behaving around its shape.

---

# Ghosts and Undead Semantics

The option was removed eight years ago.

The parser no longer accepts it.

The documentation no longer mentions it.

A wrapper still checks whether operators tried to use it.

A migration script still translates it.

A compatibility test still expects its old side effect.

One directory still exists because the option once wrote state there.

Nobody considers the option supported.

The ecosystem continues organizing itself around its absence.

The feature is dead.

Its causal structure has excellent uptime.

---

## Ghost

A **ghost** is residual causal structure surviving after the original
rationale, maintainer, mechanism, or contract disappeared.

A ghost is not merely old code.

Old code may still have a clear purpose and an active owner.

A ghost exists when the original source of authority is gone, yet
current behavior remains deformed around what used to be there.

Examples include:

* a directory preserved because an old tool once required it;
* a configuration field copied although no current component reads it;
* an execution order inherited from a race condition fixed years ago;
* a wrapper preserving behavior whose original implementation
  vanished;
* a repository convention nobody can justify but nobody dares remove;
* a codepath retained because an unknown downstream caller may depend
  on it.

> A ghost is a dependency whose maintainer is history.

The important property is causal survival.

The original thing may be absent.

Its consequences are not.

## Semantic Ghost

A **semantic ghost** is a residual expectation surviving after the
authoritative guarantee disappeared.

The system no longer promises the behavior.

Operators, callers, documentation, or compatibility logic continue to
act as though some part of the promise remains.

For example:

* an interface once guaranteed one artifact per build;
* the implementation later gained multi-artifact output;
* callers still assume exactly one result;
* the guarantee is gone;
* the expectation still shapes orchestration.

The semantic ghost is not necessarily executable code.

It may live in:

* operator expectation;
* wrapper logic;
* test assumptions;
* naming conventions;
* migration scripts;
* documentation fragments;
* downstream components.

> A semantic ghost is a contract without a body.

## Ghost Production

Ghosts are usually produced through a sequence like this:

```text
behavior exists
    ↓
ecosystem adapts
    ↓
behavior becomes expected
    ↓
implementation or rationale disappears
    ↓
adaptations remain
    ↓
current system inherits the shape
```

The disappearance may occur through:

* refactoring;
* deprecation;
* maintainer turnover;
* backend replacement;
* incomplete migration;
* documentation cleanup;
* compatibility preservation;
* accidental removal.

The ecosystem remembers through deformation.

## Residue

**Residue** is any remaining implementation, state, documentation, or
behavior left after a feature or contract changes.

Not all residue is a ghost.

A migration marker may be deliberate and temporary.

A compatibility adapter may remain clearly owned.

A deprecated configuration field may still have a documented removal
date.

Residue becomes ghostly when:

* its current purpose is unclear;
* its authority is uncertain;
* its removal risk cannot be bounded;
* downstream dependence is suspected rather than known;
* behavior persists without an active model.

## Fossil

A **fossil** is preserved evidence of an earlier system state that no
longer participates materially in current behavior.

Examples include:

* an old comment;
* an unused migration script in historical documentation;
* a retired database schema kept for reference;
* an archived configuration example.

A fossil can help explain a ghost.

It is not itself a ghost unless current behavior still depends on it.

> Fossils tell you what died.  
> Ghosts continue changing the temperature.

## Zombie Invariant

A **zombie invariant** is a formerly enforced property still
consciously maintained through social discipline after mechanical
enforcement disappeared.

The ecosystem knows the rule.

The system no longer preserves it.

Typical forms include:

* “everyone knows package names must not contain that character”;
* “operators never combine those options”;
* “maintainers always update both files together”;
* “lifecycle scripts do not touch the host during target
  installation”;
* “the wrapper must run before the real command”.

The rule remains operationally important.

It is kept alive through:

* review;
* operator caution;
* maintainer memory;
* checklists;
* custom scripts;
* social correction.

> A zombie invariant is a dead rule still reporting for work.

The distinction from a soft invariant is historical.

A soft invariant may have always been socially enforced.

A zombie invariant was once mechanically preserved --- or widely
believed to be --- and continues after that enforcement died.

## Zombie Invariant Lifecycle

A zombie invariant often follows this path:

```text
mechanical invariant
        ↓
enforcement weakened or removed
        ↓
ecosystem notices failures
        ↓
social rule preserves expected behavior
        ↓
new operators inherit the rule
        ↓
project forgets enforcement ever existed
```

At the end, the rule may be described as tradition, good practice, or
obvious operator responsibility.

The corpse has completed its rebranding.

## Field Symptom: Forbidden Package Names

An early package tool rejects names containing `/`.

Later, the validation is removed during a parser rewrite.

The package database and repository layout still cannot represent such
names safely.

Maintainers continue avoiding them.

Reviewers reject offending packages manually.

The documentation says package names “should not” contain `/`.

The invariant remains:

> Package names do not contain `/`.

The system no longer enforces it.

The maintainer community does.

That is a zombie invariant.

The clean repairs are:

* restore mechanical rejection;
* redesign the affected representations;
* define an escaping model.

The unclean repair is to continue blaming contributors for violating a
rule the authoritative path happily accepts.

## Ghost Invariant

A **ghost invariant** is an extinct invariant whose historical shape
continues deforming the ecosystem even though operators no longer
remember the rule explicitly.

Unlike a zombie invariant, nobody is consciously preserving it.

The system has inherited adaptations made around the former property.

Examples include:

* a directory layout designed around a limit that no longer exists;
* a fixed operation order preserved after the original race condition
  disappeared;
* a data field retained because old code once required it;
* a wrapper branch whose triggering condition can no longer occur;
* a repository split created for a tool that was later removed.

> A zombie invariant is still being fed.  
> A ghost invariant merely moves the furniture at night.

## Field Symptom: The Empty Directory

A base filesystem always creates:

```text
/var/lib/tool/legacy
```

No current component writes there.

No documentation mentions it.

Removal causes one old migration test to fail.

The test was copied from an earlier release.

The original tool used the directory to stage state during upgrades.

That implementation disappeared years ago.

Current installation scripts, tests, and filesystem layouts still
preserve the directory.

Nobody remembers the old invariant:

> The staging directory exists before migration begins.

The invariant is gone.

Its topology remains.

That is a ghost invariant.

## Semantic Imprint

A **semantic imprint** is the visible deformation left by an old
contract or invariant.

Imprints help identify ghosts.

Examples include:

* an otherwise unexplained field;
* an unnecessary directory;
* a suspicious ordering constraint;
* a compatibility branch with no known caller;
* a test asserting behavior absent from documentation;
* an interface parameter no current implementation needs.

An imprint is evidence.

It does not prove the original rationale.

The maintainer must still perform the autopsy.

## Undead Behavior

**Undead behavior** is an implementation artifact accidentally
promoted into an ecosystem contract and kept operational after its
original status should have ended.

Examples include:

* exact stdout wording used by callers;
* undocumented exit-status combinations;
* temporary filenames parsed by automation;
* incidental ordering relied upon by scripts;
* a bug-compatible path interpretation;
* a fallback intended for recovery becoming normal operation.

The behavior may never have been promised.

Dependence gave it authority.

> The behavior was never alive enough to deserve compatibility.  
> The ecosystem adopted it anyway.

## Accidental Contract

An **accidental contract** is an observed behavior treated as a
promise without an explicit decision to own it.

Accidental contracts emerge when:

1. the behavior is stable long enough to attract callers;
2. no documented contract contradicts it clearly;
3. the system partially validates dependence;
4. changing it causes visible breakage;
5. compatibility pressure reclassifies the observation as obligation.

Not every observed behavior should become contractual.

But once dependence exists, maintainers must decide explicitly whether
to:

* adopt the behavior;
* deprecate it;
* provide a migration;
* reject the dependence;
* contain it behind compatibility.

Pretending no decision is required merely delegates the decision to
the next incident.

## Semantic Revenant

A **semantic revenant** is behavior officially deprecated or declared
dead yet still operationally required.

A revenant differs from generic undead behavior because its death has
already been announced.

The project says:

* do not use this;
* this will be removed;
* this is obsolete;
* the replacement exists.

The ecosystem replies by continuing to depend on it.

Examples include:

* a deprecated command required by release scripts;
* an old package format still produced by current tooling;
* a compatibility option needed by supported installations;
* a retired database field read by migration code;
* an obsolete path hardcoded in downstream automation.

> Deprecated means “dead in documentation”.  
> A revenant is what runtime files as an appeal.

## Deprecation Without Exit

A **deprecation without exit** announces the end of behavior without
creating the path by which dependence can actually leave.

It may lack:

* a replacement;
* migration tooling;
* discovery of remaining callers;
* a removal version;
* compatibility boundaries;
* structured warnings;
* ownership.

Such deprecations accumulate indefinitely.

The documentation becomes a cemetery whose residents still answer
production traffic.

## Haunted Compatibility Layer

A **haunted compatibility layer** preserves dead semantics because too
much downstream ecology has adapted around them.

Compatibility itself is not haunting.

A healthy compatibility layer:

* has explicit scope;
* translates old behavior into current semantics;
* remains contained;
* records when it is used;
* has a migration strategy;
* does not infect new interfaces.

A haunted compatibility layer:

* grows without a removal condition;
* reproduces old semantics internally;
* requires special cases in unrelated components;
* accepts new callers;
* becomes the only path that still works reliably;
* prevents the current model from becoming authoritative.

> Compatibility preserves the past.  
> Haunted compatibility lets the past keep committing.

## Compatibility Necrosis

**Compatibility necrosis** occurs when compatibility logic remains
present but no longer serves a coherent migration purpose.

The layer cannot be removed because unknown dependents may exist.

It cannot be understood because the original model is gone.

It cannot be extended cleanly because every branch preserves a
different historical assumption.

The code survives.

Its reason has decomposed.

## Field Symptom: The Old Package Format

A package manager supports a legacy archive format through a
compatibility parser.

Initially, the parser converts old metadata into the current normal
form.

Years later:

* new build tools still produce the old format;
* repository tooling contains old-format branches;
* current documentation teaches both formats;
* new fields are encoded through legacy extension tricks;
* callers inspect which format was used.

The compatibility boundary no longer translates history.

It manufactures current state.

The old format is not merely supported.

It is a semantic revenant with release engineering privileges.

## Haunted Codepath

A **haunted codepath** is a branch whose current necessity is unknown,
whose removal risk is unbounded, and whose behavior may be depended
upon outside visible contracts.

Typical comments include:

```text
/* do not remove */
```

```text
/* needed for old systems */
```

```text
/* workaround */
```

```text
/* FIXME: investigate */
```

The comments are often older than the maintainer reading them.

A haunted codepath is not defined by ugliness.

It is defined by missing causal knowledge combined with compatibility
fear.

## Fear-Based Retention

**Fear-based retention** is preservation of behavior because the
ecosystem cannot bound the consequences of removal.

The fear may be rational.

Unknown downstream dependence is still dependence.

The pathology is institutional:

* no inventory of callers;
* no telemetry;
* no deprecation path;
* no contract tests;
* no migration strategy;
* no ownership.

The project cannot prove the code is needed.

It also cannot prove removal is safe.

So the branch acquires tenure.

> Nobody knows why it exists.  
> This is treated as evidence that it must be important.

## Semantic Afterlife

**Semantic afterlife** is the period during which removed behavior
continues influencing the ecosystem indirectly.

Afterlife may persist through:

* stored state;
* wrappers;
* compatibility adapters;
* old artifacts;
* tests;
* documentation;
* operator habit;
* directory topology;
* naming conventions;
* downstream automation.

Removal from one repository is not the end of a semantic life.

The meaning may continue elsewhere.

## Deletion Is Not Removal

Deleting code removes implementation.

It does not necessarily remove:

* expectations;
* artifacts;
* state;
* callers;
* migration requirements;
* compatibility behavior;
* operator practice.

A complete removal must identify which surfaces still carry the old
meaning.

```text
delete implementation
        ≠
remove ecosystem dependency
```

> The code was deleted.  
> The ecosystem did not receive the obituary.

## Ghost Surface

A **ghost surface** is a location where dead semantics remain
externally observable.

Examples include:

* an accepted legacy option;
* an old database field;
* a directory still created;
* a warning retained for scripts;
* a filename form still recognized;
* a compatibility result still exposed to callers.

Ghost surfaces matter because they allow new dependence to form.

A deprecated behavior that remains easy to invoke may continue
acquiring new callers.

Deprecation without friction is recruitment.

## Ghost Propagation

A ghost propagates when one component reproduces dead semantics for
another.

For example:

```text
legacy behavior
    ↓
compatibility wrapper
    ↓
new orchestrator copies wrapper assumption
    ↓
new documentation describes assumption
    ↓
new operator learns assumption
```

The original implementation may be gone.

The ghost now has several independent hosts.

## Ghost Host

A **ghost host** is any current component, artifact, document, or
operator practice carrying residual semantics.

A single ghost may inhabit:

* code;
* state;
* tests;
* documentation;
* wrappers;
* institutional memory.

Removing one host may not remove the ghost.

This is why ghost hunting requires an ecosystem inventory rather than
a repository search.

## Ghost Drift

**Ghost drift** occurs when residual semantics continue changing after
the original authority disappeared.

Different hosts may evolve the ghost differently.

For example:

* one wrapper preserves old exit statuses;
* another preserves old filenames;
* documentation preserves old option meaning;
* operators preserve old command order.

The ecosystem no longer has one legacy behavior.

It has descendants.

## Semantic Séance

A **semantic séance** is the reconstruction of current meaning through
historical evidence because no authoritative present contract is
available.

The maintainer consults:

* old commits;
* issue trackers;
* mailing lists;
* IRC logs;
* release notes;
* wrapper scripts;
* forgotten tests;
* comments from escaped maintainers.

A séance is sometimes necessary.

It becomes infrastructure pathology when ordinary maintenance requires
one.

> Archaeology is a method.  
> It should not be the primary API.

## Necromancy

**Necromancy** is the practical work of restoring operational
coherence from fossilized assumptions, residual state, and inherited
contradictions.

Necromancy may involve:

* identifying the original invariant;
* discovering current ghost hosts;
* separating useful compatibility from residue;
* reconstructing missing migration logic;
* deciding which accidental behavior to adopt;
* building a containment boundary;
* deleting behavior only after its causal shape is understood.

The term is humorous.

The work is serious.

A careless cleanup can destroy the only surviving representation of a
contract the project forgot to write down.

## Exorcism

**Exorcism** is the deliberate removal or containment of undead
semantics so they no longer influence current behavior without
explicit authority.

A successful exorcism may require:

1. identify the ghost;
2. locate every known host;
3. reconstruct the original contract;
4. decide which present behavior is legitimate;
5. define the current authority surface;
6. provide migration;
7. contain compatibility;
8. block new dependence;
9. remove obsolete hosts;
10. verify that the ecosystem remains coherent.

Exorcism is not deletion with confidence.

It is migration with evidence.

## Adoption

Sometimes the correct response is not exorcism.

The ecosystem may have depended on an accidental behavior for years.

The behavior may now be useful, coherent, and cheaper to own than to
remove.

**Adoption** is the explicit promotion of accidental or undead
behavior into the current contract.

Adoption requires:

* stating the behavior;
* defining scope;
* adding tests;
* enforcing invariants;
* updating documentation;
* removing contradictory paths;
* accepting future compatibility obligations.

> Not every ghost must be banished.  
> Some need paperwork.

Adoption is honest when the system gains an explicit owner.

## Retirement

**Retirement** is the controlled end of a behavior after dependence
has been migrated or deliberately rejected.

A retirement should define:

* replacement;
* affected callers;
* migration path;
* warning period;
* removal version;
* compatibility scope;
* state conversion;
* final verification.

Retirement without caller discovery is hope wearing a calendar.

## Field Symptom: The Meaning of Success

An old tool prints a warning and exits zero after partial completion.

Several scripts learn to treat this as successful enough.

A newer implementation changes the warning and exits nonzero.

The scripts break.

Was the old behavior contractual?

Originally, no.

Operationally, yes.

The ecosystem has several choices:

* restore the old behavior;
* provide a compatibility adapter;
* migrate scripts to structured partial results;
* reject partial success entirely;
* explicitly adopt a new contract.

The wrong response is:

> Nobody should have parsed that.

That may be historically true.

It is not a migration strategy.

## Field Symptom: The Unused Configuration Field

A configuration file still contains:

```text
legacy_mode=no
```

No current component reads it.

Removing the field causes operators to worry that old installations
will break.

A repository search finds no reader.

An archived migration tool from nine years ago once used it.

The field is now a fossil.

If an external supported tool still reads it, it is a ghost surface.

If current scripts consciously preserve it because they believe old
tools need it, it participates in a zombie invariant.

The correct classification depends on present causal effect, not age
or appearance.

## Field Symptom: The Order Nobody Changes

A service script always creates a directory before loading a module.

No current code requires that order.

The sequence came from a kernel bug fixed twelve years ago.

Operators no longer know the reason.

Tests preserve the order because they copy production behavior.

This is a ghost invariant.

If maintainers consciously say, “the directory must exist first”, and
enforce that rule socially, it has become a zombie invariant.

If the order is observed by another component and treated as a
promise, it has also become an accidental contract.

One behavior may participate in several categories at different
layers.

The vocabulary is compositional.

It is not a cabinet in which each corpse receives exactly one drawer.

## Do Not Confuse

**Old behavior** is not automatically a ghost.

It may remain current, documented, and owned.

**Legacy behavior** is not automatically undead.

A compatibility contract may preserve it deliberately.

**A semantic ghost** is not the same as a zombie invariant.

A semantic ghost is residual expectation.

A zombie invariant is a dead property still actively maintained
through social discipline.

**A ghost invariant** is not the same as a zombie invariant.

A ghost invariant deforms the ecosystem even though nobody consciously
remembers the rule.

**Undead behavior** is not necessarily deprecated.

It may never have been formally recognized at all.

**A semantic revenant** has been declared obsolete but remains
required.

**A fossil** does not necessarily affect current behavior.

A ghost does.

**A haunted codepath** is not merely poorly documented code.

Its removal risk is unbounded because its causal role is unknown.

**Necromancy** is not automatically bad maintenance.

Historical reconstruction may be necessary before safe change.

**Exorcism** is not deleting strange code.

It is removing the semantic dependence.

**Compatibility** is not haunting when its scope, authority, and
migration path remain explicit.

## The Ghost Test

When old or unexplained behavior appears, ask:

1. What current behavior is being observed?
2. Is the original implementation still present?
3. Is the original rationale known?
4. Was the behavior ever an explicit contract?
5. Was a property once mechanically enforced?
6. Is that property now maintained socially?
7. Do operators consciously preserve the rule?
8. Does the ecosystem remain deformed around a forgotten rule?
9. Which components or documents host the residual meaning?
10. Are current callers still acquiring dependence?
11. Is the behavior officially deprecated?
12. Is it still operationally required?
13. Does compatibility translate the old behavior or reproduce it?
14. Can the affected callers be inventoried?
15. Is the behavior useful enough to adopt explicitly?
16. Is migration cheaper and safer than preservation?
17. Which state or artifacts carry the semantic afterlife?
18. What would complete removal require?
19. Can the ghost be contained at one boundary?
20. Does the project possess enough evidence to exorcise it safely?

The test prevents two common failures:

* preserving every unexplained behavior forever;
* deleting unexplained behavior and calling the resulting archaeology
  a regression.

## A Compact Classification

Use this shorthand when distinguishing the dead:

| Term | What survives? | Is it consciously maintained? |
| --------- | --------------------------- | -------------------- |
| **fossil** | historical evidence | no current causal role |
| **semantic ghost** | expectation | not necessarily |
| **zombie invariant** | socially enforced dead property | yes |
| **ghost invariant** | deformation around forgotten property | no |
| **undead behavior** | accidental behavior promoted into contract | often |
| **semantic revenant** | deprecated but required behavior | yes, despite declared death |
| **haunted compatibility layer** | dead semantics reproduced by compatibility | institutionally |
| **haunted codepath** | unknown causal role and unbounded removal risk | preserved through fear |

The categories overlap because systems are inconsiderate enough to
produce compound hauntings.

## Eleventh House Law

> A ghost is not old code.  
> It is old meaning still collecting rent.

Drift explains how meanings separate.

Ghosts explain how separated meanings survive after their original
authority disappears.

The next section is **Semantic Counterfeit and Hallucinated
Semantics**: how interfaces project guarantees they cannot enforce,
why partial correctness is more dangerous than obvious failure, and
how ecosystems stabilize around lies that work just often enough.

---

# Semantic Counterfeit and Hallucinated Semantics

The command is called:

```text
install --atomic
```

It writes files first.

Then it updates the database.

Then it runs lifecycle scripts.

If the database update fails, the files remain.

If a lifecycle script fails, the database still reports success.

The documentation says the operation is atomic.

Maintainers explain that “atomic” means the important parts are
*mostly* treated as one operation, provided nothing unusual happens.

The interface has issued a guarantee.

The implementation has issued several qualifications.

The operator receives whichever definition survives the incident.

---

## Semantic Counterfeit

**Semantic counterfeit** is behavior that projects stronger authority,
coherence, or guarantees than the system can mechanically preserve.

The interface appears to offer one stable meaning.

The implementation owns only part of that meaning.

Examples include:

* a command named `atomic` whose effects can remain partially
  committed;
* an option named `root` that changes some execution contexts but not
  others;
* a result named `success` that includes incomplete outcomes;
* a backend described as interchangeable despite different
  installation semantics;
* an artifact presented as self-describing while its identity depends
  on external configuration;
* a validation command that reports violations but cannot block the
  authoritative path.

The semantics are counterfeit not because every behavior is false.

They are counterfeit because the interface presents partial truth with
the authority of a complete contract.

> A semantic counterfeit is a lie that passes enough tests to enter
> circulation.

## Counterfeit Authority

A counterfeit interface borrows credibility from:

* a strong name;
* familiar syntax;
* documentation;
* partial success;
* compatibility with common cases;
* maintainer confidence;
* similarity to another system;
* the absence of immediate failure.

The operator sees:

```text
--safe
```

and reasonably infers that the operation is safe within the documented
scope.

The implementation means:

> safer than the path we had before, except for several states the
> parser still accepts.

The interface has borrowed authority from the word *safe* without
paying the invariant cost required to own it.

## Partial Correctness as Counterfeit Mint

**Partial correctness** means that behavior is correct within a
limited subset of inputs, states, or execution contexts.

Partial correctness is normal.

Most components support bounded domains.

It becomes counterfeit when:

* the supported subset is implicit;
* unsupported states are accepted;
* failure occurs after mutation;
* the interface suggests broader coherence;
* operators are blamed for discovering the real boundary.

Consider an alternate-root operation that works correctly when:

* no lifecycle scripts run;
* dependencies are already satisfied;
* the target database exists;
* host and target configuration match.

That may be useful partial correctness.

It becomes counterfeit when the command accepts arbitrary roots,
scripts, dependencies, and configuration while documentation calls the
operation generally supported.

```text
honest partial correctness
    narrow contract
    explicit conditions
    early rejection

semantic counterfeit
    broad interface
    hidden conditions
    partial behavior
    social explanation afterward
```

> The dangerous lie is not “nothing works”.  
> It is “everything works, except wherever the model stops”.

## Hallucinated Semantics

**Hallucinated semantics** are guarantees, relationships, or authority
inferred by operators and callers beyond what the system actually
provides.

The hallucination may be encouraged by:

* interface names;
* familiar conventions;
* documentation;
* previous success;
* analogy with another tool;
* one component behaving more strongly than another;
* partial validation by the system.

Examples include:

* assuming `--root` changes every relevant execution context;
* assuming exit status zero means complete success;
* assuming an artifact filename is authoritative identity;
* assuming every backend behind one interface preserves the same
  semantics;
* assuming an optional check protects the authoritative repository;
* assuming deprecation implies an available replacement;
* assuming a package database describes every filesystem effect.

Hallucinated semantics are not necessarily irrational.

The interface often invites them.

> Operators do not hallucinate in a vacuum.  
> The interface supplies the mushrooms.

## System Projection and Ecosystem Interpretation

Semantic counterfeit and hallucinated semantics describe opposite
sides of one failure.

**Semantic counterfeit** is system-side projection.

The interface appears to guarantee more than the implementation owns.

**Hallucinated semantics** are ecosystem-side interpretation.

Operators or callers infer the stronger guarantee.

```text
system projects strong meaning
        ↓
operator infers strong contract
        ↓
common case partially confirms it
        ↓
ecosystem depends on the inference
```

The system does not need to deceive intentionally.

Names, defaults, and partial behavior are sufficient.

## Semantic Gravity

**Semantic gravity** is the tendency of an interface to attract
stronger interpretations than its implementation warrants.

Some words carry substantial conceptual mass:

* `atomic`;
* `safe`;
* `root`;
* `ignore`;
* `lock`;
* `transaction`;
* `install`;
* `portable`;
* `compatible`;
* `verified`.

Calling a command `install` attracts expectations about:

* files;
* state registration;
* dependency satisfaction;
* lifecycle behavior;
* later removal;
* queryability;
* rollback.

The project may intend only:

> extract files and record something if possible.

The name still pulls operator expectations toward the larger
operation.

Semantic gravity cannot be eliminated through disclaimers alone.

The system must either:

* support the attracted meaning;
* choose a narrower name;
* constrain the interface;
* reject unsupported interpretations;
* split the operation into explicit phases.

> Naming is not documentation.  
> It is preloaded expectation.

## Reachable Ambiguity Space

The **reachable ambiguity space** is the set of materially different
meanings an operator or caller can reasonably infer and partially
validate through system behavior.

Human imagination is unlimited.

The relevant question is narrower:

> Which interpretations can the interface plausibly attract and allow
> to survive?

For example, an `--ignore` option may plausibly mean:

* do not update this package;
* omit it from dependency resolution;
* hide it from repository selection;
* preserve its installed version;
* suppress an error;
* bypass one validation rule.

If different subcommands implement different subsets of those
meanings, the reachable ambiguity space is large.

A constrained primitive reduces that space.

Separate options such as:

```text
--hold-version
--skip-repository
--ignore-dependency-error
```

may be less elegant.

They make the meanings harder to confuse.

## Ambiguity Budget

An **ambiguity budget** is the amount of semantic uncertainty an
ecosystem can absorb before operators, callers, and components begin
forming incompatible interpretations.

Every interface consumes some ambiguity budget.

Small uncertainties may be tolerable when:

* the operation is local;
* failure is reversible;
* few callers exist;
* operators receive immediate feedback;
* state remains inspectable;
* the boundary is unlikely to compose further.

Ambiguity becomes expensive when:

* artifacts cross machines;
* several tools consume the result;
* state persists for years;
* failures are destructive;
* automation removes human review;
* compatibility freezes observed behavior;
* different authority surfaces disagree.

An ecosystem with strong contracts can afford more local flexibility.

An ecosystem already saturated with folklore has little ambiguity
budget left.

> Ambiguity is cheap until somebody automates it.

## Trust-Me-Bro Interface

A **trust-me-bro interface** depends primarily on operator virtue,
experience, or restraint for correctness.

Typical forms include:

* a dangerous option accepted without validation;
* two incompatible flags allowed together;
* an unrestricted string representing several semantic categories;
* a command that requires callers to know undocumented phase order;
* a public function whose valid inputs exist only in maintainer
  memory.

The interface says:

> The system permits this.

The maintainers mean:

> Competent people know when not to use it.

That is not operator sovereignty.

It is an undocumented entrance exam attached to state mutation.

## Undefined Ritual Zone

An **undefined ritual zone** is an operational area where behavior
often works despite lacking an enforceable contract.

Examples include:

* running lifecycle scripts under an alternate root;
* manually repairing package databases;
* mixing repository metadata from different generations;
* invoking internal helper commands directly;
* editing generated state;
* reusing partially produced artifacts;
* depending on warning text.

The zone is not necessarily random.

It may be stable enough for experienced operators to navigate.

Its stability comes from ritual:

* perform steps in one order;
* avoid specific combinations;
* inspect one file afterward;
* rerun one command if a warning appears;
* never automate the whole sequence.

> Undefined does not mean unpredictable.  
> Sometimes it means predictable only to the priesthood.

## Semantic Overloading

**Semantic overloading** occurs when one primitive carries several
distinct meanings that cannot be enforced through one coherent
contract.

Examples include:

* `root` meaning filesystem destination, database namespace,
  configuration base, and script environment;
* `ignore` meaning skip, hold, suppress, bypass, or hide;
* `success` meaning complete, partial, recoverable, or merely
  non-catastrophic;
* `package` meaning source recipe, built artifact, repository entry,
  or installed state;
* `remove` meaning unregister, delete files, run lifecycle logic, or
  all three.

Overloading is not automatically wrong.

A term may legitimately name a concept spanning several phases.

It becomes pathological when the phases can diverge and the interface
cannot represent the divergence.

> One word can unify a model.  
> It cannot manufacture one.

## Semantic Compression Artifact

A **semantic compression artifact** is a small interface element
carrying more implied meaning than it explicitly represents.

Examples include:

* one boolean option controlling several policies;
* one exit status representing several outcomes;
* one filename encoding identity, version, release, architecture, and
  format;
* one `root` path standing for multiple namespaces;
* one warning covering several failure classes.

Compression is useful.

Interfaces must remain manageable.

But compression becomes dangerous when callers need to decompress the
meaning differently.

## Counterfeit Success

**Counterfeit success** is a successful status that does not identify
which promised effects actually occurred.

Possible hidden outcomes include:

* files installed, database update failed;
* artifact created, publication failed;
* validation warned, operation continued;
* dependency resolution skipped;
* lifecycle script failed;
* rollback incomplete;
* result reused from cache;
* partial output remains valid.

A success result should match the contract.

If partial states are legitimate, they should be represented
explicitly.

> “Success” is not a bucket for everything that failed politely.

## Counterfeit Safety

**Counterfeit safety** is an interface implying that a dangerous
operation has been contained when the actual protection remains
partial, optional, or social.

Examples include:

* a `--safe` mode that only enables warnings;
* a dry-run that still performs network or script side effects;
* a validation tool disconnected from publication;
* a transaction that cannot roll back lifecycle scripts;
* a sandbox that shares writable host paths;
* an alternate root that does not isolate execution context.

The mechanism may improve safety.

The counterfeit lies in presenting improvement as a complete boundary.

## Counterfeit Portability

**Counterfeit portability** occurs when an artifact or operation
appears independent of its original environment but silently depends
on ambient state.

Examples include:

* artifacts requiring undeclared host libraries;
* packages whose scripts assume the build machine's filesystem layout;
* configurations containing absolute paths from the producer;
* repository metadata interpreted through local conventions;
* “portable” scripts depending on one shell's behavior.

The artifact crosses the boundary.

Its assumptions remain behind, connected by invisible cable.

## Counterfeit Pluralism

**Counterfeit pluralism** is the appearance of meaningful alternatives
where every alternative remains captured by the same unresolved
substrate.

Several frontends may exist.

Each one must:

* read the same private configuration;
* infer the same artifact identity;
* compensate for the same state ambiguity;
* preserve the same accidental protocol.

The ecosystem has several control panels.

The machine room remains singular and haunted.

## Authority Laundering

**Authority laundering** presents socially enforced behavior as if it
were mechanically guaranteed by the system.

Typical phrases include:

* “works when used correctly”;
* “everyone knows not to do that”;
* “supported for experienced operators”;
* “the configuration is unusual”;
* “that combination is technically valid but not sensible”;
* “the documentation implies the intended use”.

The system accepts the state.

Operators enforce the real boundary socially.

Maintainers then describe the result as system behavior.

```text
operator discipline
        ↓
stable common case
        ↓
appearance of system guarantee
```

Authority laundering often sustains semantic counterfeit.

The interface projects coherence.

The operator community supplies the missing enforcement.

The project credits the interface.

> The invariant is dead.  
> The maintainers keep dressing it for meetings.

## Counterfeit Lifecycle

A semantic counterfeit often matures through this sequence:

```text
ambiguous interface
        ↓
common case works
        ↓
operators infer broad contract
        ↓
edge case fails
        ↓
maintainers explain intended use
        ↓
social rule develops
        ↓
documentation describes the social rule
        ↓
ecosystem treats rule as system guarantee
```

At the end, everyone agrees on the meaning.

The system still does not enforce it.

## Field Symptom: `--ignore`

A package frontend provides:

```text
--ignore foo
```

One subcommand interprets this as:

> Do not update `foo`.

Another interprets it as:

> Remove `foo` from dependency consideration.

A third still resolves dependencies through `foo` but suppresses the
resulting error.

Operators infer that ignored packages remain installed and stable.

The implementation supports several different semantics under one
name.

The interface has high semantic gravity.

The reachable ambiguity space is large.

The correct repair may include:

* narrower options;
* separate typed operations;
* explicit per-command semantics;
* rejection where no coherent meaning exists.

Adding another paragraph to the man page may reduce surprise.

It does not remove the counterfeit surface.

## Field Symptom: Atomic Installation

A package manager describes installation as atomic.

Operationally:

1. files are extracted;
2. lifecycle scripts execute;
3. the package database is updated;
4. service state may change.

Only the database update is transactional.

Filesystem mutation cannot be fully rolled back.

Lifecycle scripts may affect external state.

The term `atomic` may honestly describe one phase.

It counterfeits the whole operation if presented without scope.

A better contract might say:

> Package database registration is atomic.
> Filesystem and lifecycle effects may require recovery after failure.

Less beautiful.

More useful during the fire.

## Field Symptom: The Safe Hook

A repository provides an optional validation hook.

Maintainers who install it are protected from one class of malformed
metadata.

Documentation says:

> Repository metadata is validated before commit.

Imports, automation, and maintainers without the hook remain
unprotected.

The validation mechanism is real.

The ecosystem-level guarantee is counterfeit.

The hook is a memory prosthesis.

Calling it a repository invariant launders local discipline into
system authority.

## Field Symptom: Supported Alternate Roots

A tool accepts:

```text
--root=/mnt
```

Files are written beneath `/mnt`.

Dependency resolution reads the host database.

Configuration comes from the host.

Lifecycle scripts run with host process context.

The package database beneath `/mnt` is updated.

The documentation says alternate roots are supported.

What is supported?

* alternate filesystem destination;
* alternate package registration;
* alternate dependency model;
* alternate execution environment;
* all of the above?

The option produces enough correct behavior to validate the broad
interpretation.

It also preserves enough host dependence to violate it.

This is semantic counterfeit.

## Field Symptom: Self-Describing Artifact

A package filename contains:

```text
foo#1.2-1-x86_64.pkg.tar.gz
```

The repository and installer infer identity from the name.

The archive contains no manifest.

The file may be renamed.

Architecture is derived differently by another component.

The artifact appears self-describing.

Its truth depends on an external naming convention and shared parser
behavior.

The presentation is rich.

The authority is absent.

## Field Symptom: Successful Verification

A command verifies an artifact and prints:

```text
verification successful
```

It checked the checksum.

It did not check:

* signature;
* package identity;
* provenance;
* compatibility;
* manifest consistency.

The message may be true within one narrow scope.

Without naming that scope, `verification successful` attracts a
broader security interpretation.

The system did not lie about the checksum.

It counterfeited the meaning of verification.

## Semantic Counterfeit Versus Ordinary Bug

A bug violates the intended implementation.

Semantic counterfeit may persist even when every line behaves as
implemented.

The problem is mismatch between:

* projected contract;
* actual authority;
* enforceable subset;
* ecosystem interpretation.

Fixing one defect may leave the counterfeit intact.

For example, repairing one rollback failure does not make an operation
atomic if lifecycle effects remain irreversible.

The name still projects more than the model owns.

## Hallucination Containment

A system cannot prevent operators from imagining every possible
meaning.

It can constrain hallucination by:

* choosing precise names;
* publishing explicit contracts;
* separating distinct operations;
* representing partial outcomes;
* rejecting unsupported combinations;
* making authority visible;
* exposing structured truth;
* reducing accidental success outside the supported model;
* ensuring documentation confesses current limits.

The objective is not to eliminate interpretation.

It is to reduce the set of interpretations that runtime appears to
validate.

## Honest Interface

An **honest interface** exposes no stronger guarantee than the system
can enforce.

Honesty may look like:

* narrower commands;
* longer names;
* explicit phases;
* structured result types;
* visible limitations;
* rejection of ambiguous combinations;
* capability declarations;
* partial outcomes represented directly;
* warnings that do not masquerade as safety.

An honest interface can still be inconvenient.

Sometimes the inconvenience is the exact shape of unresolved reality.

> Friction is cheaper than counterfeit confidence.

## Semantic Friction

**Semantic friction** is deliberate difficulty introduced to prevent
operators or callers from crossing an important boundary accidentally.

Examples include:

* requiring an explicit unsafe option;
* refusing ambiguous flag combinations;
* separating destructive commands;
* requiring a migration step;
* forcing acknowledgment of partial semantics;
* making implicit defaults visible.

Friction should correspond to real risk.

Arbitrary inconvenience is not semantic rigor.

A useful friction point says:

> You are leaving the model the system can defend.

## Warning Surface

A **warning surface** informs operators that a contract is weak,
partial, or context-dependent.

Warnings are valuable when:

* the state remains legitimate;
* operator judgment is required;
* compatibility prevents rejection;
* migration is underway;
* the system can continue safely.

Warnings become authority laundering when they substitute indefinitely
for a boundary the system already knows how to enforce.

> A warning is information.  
> It is not a fence with yellow text painted on the grass.

## Do Not Confuse

**Semantic counterfeit** is not deliberate deception.

A system can counterfeit meaning through inherited names, partial
behavior, and unclear boundaries.

**Hallucinated semantics** are not simply operator stupidity.

The interface often supplies strong evidence for the interpretation.

**Partial correctness** is not automatically counterfeit.

It becomes counterfeit when the supported subset is hidden or the
interface implies completeness.

**A broad interface** is not automatically dishonest.

It is honest when the system possesses a real model covering its
breadth.

**A warning** is not automatically insufficient.

Some legitimate states require operator judgment.

**Strict rejection** is not always the correct solution.

The system may need to preserve operator authority or accept a
temporarily broader migration surface.

**Semantic friction** is not an excuse for hostile interfaces.

Friction should guard a meaningful boundary.

**Familiar terminology** is not automatically semantic gravity abuse.

Common names are useful when their scope is defined.

**Authority laundering** is not the same as a zombie invariant.

A zombie invariant is the dead property maintained socially.

Authority laundering is the process by which that social maintenance
is presented as system enforcement.

## The Counterfeit Test

For any strong-looking interface or guarantee, ask:

1. What meaning does the name naturally attract?
2. What exact contract does the documentation state?
3. Which parts are mechanically enforced?
4. Which parts hold only in the common case?
5. Which accepted states fall outside the model?
6. Are unsupported states rejected before mutation?
7. Can partial outcomes be represented?
8. Does success identify which effects occurred?
9. Which facts are authoritative?
10. Do different callers infer different meanings?
11. Which operator knowledge is required for safe use?
12. Does the interface depend on “sensible” behavior?
13. Are warnings substituting for rejection?
14. Does one term carry several incompatible semantics?
15. Is an optional mechanism presented as an ecosystem invariant?
16. Does a backend limitation silently weaken the contract?
17. Does the interface borrow familiar terminology from a stronger
    model?
18. Can a newcomer infer the supported boundary correctly?
19. Does the system partially validate a broader interpretation?
20. Is social discipline being presented as mechanical authority?
21. Can the interface be narrowed without losing essential capability?
22. Would a more explicit result reduce hallucination?
23. Is the projected guarantee worth the invariant budget required to
    own it?
24. If the guarantee cannot be enforced, should the system rename,
    constrain, split, or reject the operation?

If maintainers must explain that the option does not mean what every
reasonable operator thinks it means, the interface has already filed
its confession.

## Twelfth House Law

> If an interface can lie, it will eventually acquire believers.

Semantic counterfeit explains how weak guarantees gain the appearance
of authority.

Hallucinated semantics explain how the ecosystem converts that
appearance into expectation, automation, and dependence.

Part III has followed meaning as it drifts, dies, returns, and finally
learns to impersonate a contract.

Part IV turns to the ecosystem that keeps all of this operational.

The next section is **Part IV: Folklore Ecology and Institutional
Memory**, beginning with **Coping Infrastructure**: how wrappers,
rituals, channels, conventions, and operator knowledge become the
missing control structure around an incomplete system.

---

# I. Ontology of Haunted Systems

## ghost

Residual causal structure surviving after the original rationale,
maintainer, or enforcement mechanism disappeared.

## semantic ghost

Residual semantic expectation surviving after the authoritative
guarantee disappeared.

## undead behavior

Implementation artifact accidentally promoted into ecosystem contract.

## haunted codepath

Branch nobody trusts, nobody understands, and nobody dares remove.

## semantic revenant

Behavior officially deprecated yet operationally required.

## cursed interface

Abstraction requiring folklore knowledge to use safely.

## haunted compatibility layer

Dead semantics preserved because too much downstream ecology adapted
around them.

## zombie invariant

Invariant socially assumed to exist despite no longer being
mechanically enforced.

Unlike a [semantic ghost](#semantic-ghost), a zombie invariant still
actively shapes operational decisions.

Typical form:

- “everyone knows not to do that”
- “the script assume this”
- “it usually behaves correctly if operators stay disciplined”

The invariant survives socially after enforcement died structurally.

## necromancy

Reconstructing operational coherence from fossilized assumptions and
inherited contradictions.

## semantic séance

Reading commits, bug trackers, IRC logs, and mailing lists trying to
determine what the system "really means".

## exorcism

Removing ambiguous, split-brain, or undead semantics before ecosystem
crystallize around them.

## demonology

Classification of recurring infrastructure failure patterns.

## semantic poltergeist

Failure manifesting only when multiple undocumented assumptions
resonate together.

## cursed attractor

Locally convenient behavior producing long-term ecosystem deformation.

## semantic afterlife

Period where deleted behavior continues influencing runtime
indirectly through ecology adaptation.

---

# II. Taxonomy of Bastards

## bastard

Operator compensating manually for missing invariants,
undefined boundaries, or folklore semantics.

## elder bastard

Operator whose coping mechanisms became indistinguishable from
infrastructure.

## infrastructure bastard

Human functioning as missing subsystem.

## folklore priest

Operator transmitting operational truth socially instead of
mechanically.

## semantic undertaker

Maintainer cataloguing dead assumptions and decomposing lying
abstractions.

## ghost shepherd

Operator preventing undead semantics from escaping containment.

## patch necromancer

Maintainer reviving decade-old fixes because the same pathology
reappeared again.

## wrapper warlock

User constructing increasingly elaborate shells around incoherent
tooling.

## coping virtuoso

Person whose expertise consists primarily of surviving broken
semantics elegantly.

## entropy janitor

Maintainer continuously cleaning emergent states nobody formally
modeled.

## semantic archaeologist

Operator reconstructing intent from historical debris rather than
documentation.

## invariant blacksmith

Engineer converting vibes into mechanically enforceable contracts.

## convergence engineer

Designer shaping ecosystems toward shared semantic reality.

## cathedral exorcist

Maintainer removing spiritually expensive abstractions from
infrastructure.

**Note:** candidate for removal.  
**Reason:** ornamental rather than operational.

## heat sink operator

Human absorbing ecosystem entropy manually.

---

# III. Failure Ecology

## coping infrastructure

Complexity externalized into operator discipline.

## workaround ecology

Ecosystem stabilized through accumulated compensatory behavior.

## distributed folklore

Incompatible local truths replacing shared semantics.

## semantic sprawl

Uncontrolled proliferation of unofficial meanings.

## scripting hell

Condition where orchestration semantics escaped entirely into user
space.

## workaround kung-fu

Advanced ritual knowledge required for ordinary workflows.

## entropy export

Preserving local simplicity by externalizing systemic complexity
elsewhere.

## semantic landfill

Accumulation of abandoned interfaces nobody dares remove.

## rediscovery loop

Recurring relearning of previously solved failures after
institutional memory collapsed.

## operational superstition

Ritual behavior repeated because it once appeared to work.

## cargo-cult invariant

Constraint preserved without understanding the original failure it
protected against.

## semantic sinkhole

Abstraction consuming increasing maintenance energy without
stabilizing semantics.

## local survivability

Ability to keep one installation operational despite ecosystem
incoherence.

## ecosystem fracture

Divergence into mutually incompatible operational realities.

## wrapper proliferation event

Moment operators collectively stop trusting the official abstraction
layer.

## recursive coping

Workarounds layered atop workarounds atop workarounds.

## metastasis layer

Workaround that silently became infrastructure.

---

# IV. Invariants and Contracts

## invariant

Property mechanically defended by the system itself.

## soft invariant

Property enforced primarily through operator discipline or social
expectation.

## ghost invariant

Formerly enforced invariant whose original enforcement mechanism
vanished long ago, yet ecosystem behavior still deforms around its
historical shape.

Unlike a [zombie invariant](#zombie-invariant), operators no longer
necessarily remember the invariant explicitly.
The ecosystem merely inherited deformation around its former
existence.

## contract

Explicit behavioral boundary.

## semantic authority surface

Location where meaning is actually determined.

## invariant surface

Boundary across which semantics remain mechanically coherent.

## authority fracture

Mismatch between where users believe meaning originates and where it
actually originates.

## semantic split-brain

Multiple incompatible authority surfaces simultaneously pretending to
describe one coherent operation.

## trust-me-bro interface

Abstraction depending primarily on user virtue for correctness.

## undefined ritual zone

Operational area where behavior often works despite lacking
enforceable semantics.

## semantic gravity

Tendency of users to infer stronger guarantees than the interface
actually provides.

## ambiguity budget

Maximum semantic uncertainty an ecosystem can absorb before
fragmentation begins.

## invariant debt

Future instability accumulated by tolerating unenforced assumptions.

## semantic compression artifact

Tiny interface carrying vastly more implied meaning than explicitly
specified.

## implementation masquerading as interface

Accidental behavior mistaken for stable contract.

## semantic leak

Internal implementation detail escaping into public meaning.

## semantic drift

Divergence between implementation, documentation, operational
expectation, and original intent.

## model rot

Abstraction losing correspondence with operational reality.

## contract erosion

Gradual weakening of enforceable guarantees.

## abstraction poisoning

Interface becoming misleading while remaining technically functional.

## hallucinated semantics

Users inferring stronger guarantees, coherence, or topology control
than the system actually provides.

Usually triggered by:

- ambiguous interfaces
- partial correctness
- accidental success
- split authority surfaces

## semantic counterfeit

Abstraction projecting stronger semantic authority than the system can
mechanically enforce.

Counterfeit semantics are especially dangerous because partial
correctness allows ecosystems to unconsciously stabilize around lies.

> Not to be confused with
> [hallucinated semantics](#hallucinated-semantics):
> - Hallucinated semantics describes user perception.
> - Semantic counterfeit describes system behavior.

## semantic overloading

Single primitive forced to carry incompatible or unrelated meanings
simultaneously.

## accidental protocol

Undocumented behavior ecosystems begin depending upon compositionally.

---

# V. Cybernetic Pathologies

## regulator failure

System loses ability to constrain its own state transitions.

## control surface

Interface through which operators attempt to steer system behavior.

## phantom control surface

Interface implying control over dynamics it cannot actually regulate.

## feedback hallucination

Users believe corrective feedback exists while the loop is
structurally disconnected.

## open-loop engineering

Software acting without validating consequences of its own behavior.

## closed-loop engineering

Software continuously validating effects against enforced invariants.

## unstable equilibrium

System appearing stable until tiny perturbation triggers semantic
cascade.

## compensatory oscillation

Repeated workaround cycles induced by missing regulation.

## semantic resonance

Multiple ambiguous assumptions amplifying each other catastrophically.

## damping layer

Mechanism reducing propagation of semantic instability.

## entropy pump

Abstraction exporting unresolved complexity downstream.

## attractor poisoning

Local optimization corrupting long-term convergence behavior.

## bifurcation event

Moment ecosystem splits into incompatible operational cultures.

## control inversion

Operators adapting themselves to tooling pathologies more than tooling
adapts to operators.

## adaptation debt

Future complexity accumulated through human compensation.

## semantic turbulence

Unpredictable interactions emerging between loosely constrained
abstractions.

## invariant starvation

Condition where no layer possesses sufficient authority to enforce
correctness.

## convergence engine

Mechanism forcing ecosystem behavior toward shared semantics.

## divergence engine

Mechanism generating operational fragmentation.

## semantic thermal runaway

Ambiguity generating more ambiguity faster than correction mechanisms
can absorb it.

## regulatory necrosis

Formerly authoritative contract becoming operationally irrelevant.

## orphaned feedback loop

Validation mechanism no longer connected to actual decisions.

## compensatory overfitting

Operators becoming experts at surviving broken environments instead of
improving them.

## semantic phase transition

Moment tolerated ambiguity becomes ecosystem-defining reality.

## control-path leakage

Hidden implementation details unexpectedly influencing public
semantics.

## distributed control fiction

Belief that “users are in control” while no participant possesses
enough visibility to reason compositionally about the system.

---

# VI. Orders of Consequence

## first-order effect

Immediate behavior of the mechanism itself.

## second-order effect

How behavior propagates operationally.

## third-order effect

What kinds of operators the system manufactures over time.

## fourth-order effect

How institutional culture mutates around persistent constraints.

## fifth-order effect

What future abstractions become impossible because of accumulated
ecology.

## convergence pressure

Forces collapsing ecosystem behavior toward shared semantics.

## divergence pressure

Forces generating fragmented operational realities.

## bounded failure

Failure constrained into predictable forms.

## unbounded failure field

Ambiguity capable of mutating arbitrarily downstream.

## semantic blast radius

Distance misunderstanding propagates through ecosystem layers.

## attractor basin

Stable behavioral pattern ecosystem naturally converge toward.

## metastable basin

Dysfunctional equilibrium surviving because migration cost exceeds
immediate pain.

## convergence trap

Ecosystem converging on wrong abstraction because alternatives are
operationally expensive.

## adaptive scar tissue

Workaround layer accumulated around historical failures.

## semantic scarification

Permanent interface deformation caused by compatibility trauma.

**Note:** candidate for removal.  
**Reason:** ornamental rather than operational.

## local optimum cemetery

Infrastructure graveyard full of solutions that solved immediate pain
while destroying future coherence.

---

# VII. Systems-Theory Bastardry

## invariant singularity

Tiny enforced contract around which entire ecosystem stabilizes.

## entropy displacement field

Illusion of simplicity created by moving complexity elsewhere.

## runtime theology

Belief system formed around unexplained operational behavior.

## institutional haunting

Dead maintainers continuing to influence architecture through
inherited assumptions.

## operational mythogenesis

Repeated incidents gradually transforming into ecosystem truth.

## convergence necromancy

Forcing fragmented ecosystem behavior back toward shared semantics.

**Note:** candidate for removal.  
**Reason:** ornamental rather than operational.

## semantic immune response

Ecosystem reaction against abstractions perceived as dangerous,
coercive, or spiritually impure.

## distributed schizophrenia

Ecosystem where every node maintains internally coherent but mutually
incompatible truths.

## invariant gravity well

Strong semantic center pulling surrounding behavior toward coherence.

## semantic dark matter

Undocumented assumptions exerting enormous operational influence
despite remaining invisible.

## control necromancer

Maintainer attempting to restore enforceable feedback loops to
folklore-driven systems.

## abstraction burial ground

Collection of interfaces nobody removes because unknown downstream
ecology still depends on them.

## semantic blood pact

Undocumented dependency silently accepted as permanent operational
reality.

**Note:** candidate for removal.  
**Reason:** rather ornamental than operational.

## ecosystem memory leak

Project continuously forgetting conclusions and re-solving identical
debates.

## distributed exorcism

Painful ecosystem-wide removal of undead assumptions.

## semantic heat death

State where all abstractions degraded into equally meaningless
folklore.

---

# VIII. Semantic Entropy Dynamics

## first law of semantic entropy

Unenforced semantics tend to migrate into folklore.

## second law of bastard thermodynamics

Operational folklore tends to accumulate faster than institutions
remove it.

## third law of bastard thermodynamics

At absolute KISS, operators themselves become the abstraction layer.

## entropy laundering

Presenting exported complexity as simplicity.

## semantic refrigeration

Aggressive invariant enforcement preventing ambiguity growth.

## thermal ghost

Historical workaround surviving after the original failure
disappeared.

## operational friction

Pain intentionally introduced to discourage invalid states.

## catastrophic cooling failure

Removal of constraints causing explosive workaround proliferation.

## entropy sequestration

Isolating ambiguity so it cannot infect surrounding semantics.

---

# IX. Design Religions

## CHURCHX

Religion of survivable entropy.

System simplicity preserved by externalizing suffering into operators.

## ZPLN

Religion of enforced semantic convergence.

System absorbs invariant burden so users do not become infrastructure.

## folklore-driven system

Correctness emerges socially.

## engineered ecology

Correctness emerges mechanically.

## authoritarian semantics

Semantics enforced strongly enough that invalid states become
mechanically difficult or impossible to represent.

## hallucinated semantics

Interface implying stronger guarantees than the system can actually
enforce.

## user-space garbage collector

Ecosystem stability achieved by exhausting or filtering incompatible
operators.

## semantic libertarianism

Preference for unrestricted representability over invariant
enforcement.

## invariant authoritarianism

Preference for semantic coherence over unrestricted state-space
freedom.

## KISS necromancy

Removing explicit models until operators themselves become the
abstraction layer.

## sacred KISS

Doctrine that every explicit model itself risks spiritual corruption.

## cathedral engineering

Constructing rigid semantic centers.

## village engineering

Ecosystem surviving through distributed coping customs.

## semantic Calvinism

Belief that only worthy operators deserve survivable systems.

## false simplicity

Complexity hidden inside operator cognition.

## forbidden complexity

Complexity acknowledged only after users already maintain it manually.

## ritual minimalism

Removing visible machinery while preserving hidden operational burden.

## semantic purgatory

State where behavior is neither guaranteed nor forbidden.

---

# X. Sacred Sayings of the House

* “If it can lie, it will lie.”
* “The code is cheap. Show me invariant.”
* “Every workaround is a ghost breeding program.”
* “Users do not read contracts. Systems must.”
* “Undefined behavior is outsourced responsibility.”
* “Folklore is what happens when enforcement fails.”
* “A constrained primitive is better than a haunted abstraction.”
* “No abstraction is better than a lying abstraction.”
* “Constrained primitive is worse than real model.”
* “Hope is not an invariant.”
* “Survival is not correctness.”
* “Rediscovery is institutional amnesia with uptime.”
* “The system remembers nothing. The bastards remember everything.”
* “Every CLI flag eventually becomes theology.”
* “Entropy denied by the system reappears inside operators.”
* “Ghosts are undocumented dependencies with tenure.”
* “Half the infrastructure is dead people still influencing runtime.”
* “When implementation becomes interface, archaeology becomes
  maintenance.”
* “A distro is defined by where it stores complexity.”
* “Either the system absorbs failure, or the users do.”
* “Every undefined behavior is a future religion.”
* “The wrapper is screaming because the abstraction underneath is
  dying.”
* “A bug tracker is institutional memory with uptime.”
* “Every workaround teaches the ecosystem the wrong lesson.”
* “If users must remember it, the system has already forgotten it.”
* “Folklore scales until it suddenly doesn’t.”
* “The most permanent interface is accidental behavior.”
* “Every metastable basin eventually demands human sacrifice.”
* “The maintainer who says ‘works for me’ has already left the shared
  reality.”
* “Users hallucinate semantics. Good systems constrain hallucination
  space.”
* “Complexity denied by architecture returns as operator ritual.”
* “The ecosystem always pays. The only question is where.”
* “Every missing invariant becomes somebody’s personality.”
* “When contracts die, priests appear.”
* “The IRC log is the distributed subconscious of the system.”
* “A semantic ghost is an invariant nobody buried properly.”
* “The system is not stable. The bastards are.”
* “One bastard’s workaround is another generation’s undocumented
  dependency.”
* “If the code cannot explain the behavior, folklore will.”
* “Every ecosystem eventually documents its ghosts. Usually too late.”

---

# Closing Note

This document is simultaneously:

* systems theory
* cybernetics
* infrastructure pathology
* distributed systems anthropology
* UNIX folklore analysis
* operational trauma documentation
* and IRC shitposting.

The categories are not mutually exclusive.

xDDDD

