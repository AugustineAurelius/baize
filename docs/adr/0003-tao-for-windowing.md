# 0003 — Use Tao for windowing

- Status: Accepted
- Date: 2026-11-15

## Context

The Wry prototype needs window creation and an event loop on Linux. The initial
copied example uses winit, but the developer prefers Tao.

## Options

- Tao: uses GTK on Linux and exposes a GTK container for Wry integration.
- winit: usable with Wry, but the current Linux integration requires explicitly
  initializing GTK and advancing its event loop. The raw-window embedding path
  in Wry 0.57.2 supports X11 only.

## Decision

Use Tao for window creation and event handling. Use Wry's GTK embedding path on
Linux so the prototype can support both X11 and Wayland.

There is no current requirement that favors winit. Reconsider windowing when
the experimental engine has concrete rendering and integration requirements.

## Consequences

- Rewrite the copied winit example using Tao's API; the APIs are not interchangeable.
- Tao handles the GTK event loop integration on Linux.
- This decision does not select how address bars, tabs, or other controls are drawn.
- No application code is changed as part of recording this decision.

## Validation

The choice is supported by Wry's documented Tao/GTK embedding example.
The developer reported successful launch of the Wry/Tao example. Input,
resizing, page rendering, and shutdown checks have not yet been reported separately.

## References

- [Tao](https://github.com/tauri-apps/tao)
- [Wry 0.57.2 documentation](https://docs.rs/wry/0.57.2/wry/)
- [ADR 0002](0002-wry-for-prototype.md)
