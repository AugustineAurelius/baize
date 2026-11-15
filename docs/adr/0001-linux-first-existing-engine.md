# 0001 — Start with Linux and an existing engine

- Status: Accepted
- Date: 2026-11-15

## Context

Baize is a new Rust desktop browser project. The developer wants to implement it
personally, beginning with an existing web engine and eventually creating an
engine from scratch. The development environment is WSL.

## Options

- Start with Linux through WSL.
- Start with a native Windows application.
- Start by building a custom browser engine before implementing the browser UI.

## Decision

Target Linux first and use an existing web engine for the initial browser.
Use WSL 2 with WSLg to run the Linux GUI during development, subject to verifying
the local setup.

Select the engine and UI toolkit in subsequent ADRs. No particular library has
been chosen yet.

Keep browser state and features separate from engine-specific integration where
practical. Develop the custom engine later, beginning with a limited set of HTML
and CSS features. Refine the integration boundary as actual needs emerge.

The developer writes the implementation; assistance focuses on planning,
explanations, and review unless implementation help is explicitly requested.

## Consequences

- The first milestone is a Linux window displaying a web page through an
  existing engine.
- WSL GUI support and the selected engine's Linux dependencies need verification.
- Native Windows support is deferred.
- Engine separation should help reuse browser features later, but integrating a
  custom engine will still require substantial work.
- Modern web compatibility is a long-term goal for the custom engine.

## Validation

The target platform and initial engine strategy were agreed with the developer.
No GUI prototype or engine integration has been tested yet.

## References

- [Microsoft: Run Linux GUI apps with WSL](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)
