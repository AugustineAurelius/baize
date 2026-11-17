# Architecture decision records

Use ADRs to record significant decisions: the problem, the alternatives, the
choice, and its consequences. Keep each record focused on one decision.

Copy `template.md` to `NNNN-short-title.md` for a new decision. Start it as
`Proposed`, then change it to `Accepted` when you choose an approach. If a later
decision replaces it, mark it `Superseded` and link to the new record; preserve
the original reasoning.

The assistant maintains ADRs and progress notes based on agreed decisions and
reported results. The developer writes the application code.

## Decisions

| Record | Status |
| --- | --- |
| [0001 — Start with Linux and an existing engine](0001-linux-first-existing-engine.md) | Accepted |
| [0002 — Use Wry for the prototype](0002-wry-for-prototype.md) | Accepted |
| [0003 — Use Tao for windowing](0003-tao-for-windowing.md) | Accepted |
| [0004 — Native GTK address bar for Linux](0004-gtk-address-bar.md) | Accepted |

## Progress

ADRs explain decisions. Use the checklist below to track the first milestone.
Add links to relevant ADRs as choices are made.

### Milestone 1: Open a browser window on Linux through WSL

- [x] Choose Linux as the first target.
- [x] Choose an existing engine for the initial browser.
- [x] Verify WSL 2 and WSLg can open a Linux GUI application (`xclock` opened successfully).
- [x] Compare engine embedding options and record the preliminary choice in ADR 0002.
- [x] Validate Wry with a working prototype and accept ADR 0002.
- [x] Choose Tao for windowing (ADR 0003); browser controls remain to be designed.
- [x] Install dependencies sufficient to run the example (successful launch reported by the developer).
- [x] Run the Wry/Tao example (successful launch reported by the developer).
- [x] Verify page rendering, keyboard/mouse input, resizing, and normal shutdown (confirmed by the developer).
- [x] Record how to build and run the prototype (below).

### Build and run (Ubuntu 24.04 / WSL)

Install Linux development dependencies:

```bash
sudo apt update
sudo apt install libwebkit2gtk-4.1-dev libsoup-3.0-dev
```

With the Rust toolchain installed, run from the repository root:

```bash
cargo build
GALLIUM_DRIVER=d3d12 cargo run -- https://example.com
```

The first application argument is required and must be an HTTP(S) URL with a
host. Missing or invalid input prints an error to stderr and exits with code 1
before window creation. The earlier default URL behavior has been replaced.
The D3D12 override addresses driver selection
in the developer's WSL environment; it is not a universal Linux requirement.

### Milestone 2: Navigation

- [x] Read the initial URL from the first argument (now required; code reviewed).
- [x] Verify earlier launches with an explicit URL and a default URL (confirmed by the developer before validation was added).
- [x] Define and implement handling of missing/invalid addresses before creating the window (code reviewed; developer reports successful compilation).
- [ ] Verify missing/invalid input exits with code 1 and a valid URL still opens a page.
- [x] Choose GTK for the address bar (ADR 0004).
- [x] Add a GTK address entry above the WebView (implemented; developer reports working navigation).
- [x] On Enter, validate the entry and navigate the existing WebView (developer confirmed).
- [x] Implement address updates from Wry page-load events (code reviewed).
- [ ] Manually confirm address updates after following links and redirects.
- [ ] Add a horizontal GTK toolbar with Back, Forward, Reload, and the address entry.
- [ ] Connect navigation controls and verify history traversal and reload.

Review on 2026-11-17: `cargo test --offline` passes (one URL parsing test).
GUI behavior was not exercised by the assistant.

Later milestones: navigation controls, tabs, persistent history/bookmarks, and
an experimental engine developed from scratch.

Known environment issue: EGL/Mesa/Zink initialization warnings appear during
startup under WSLg. The developer reports normal visible behavior. `glxinfo -B`
defaults to llvmpipe (`Accelerated: no`); with `GALLIUM_DRIVER=d3d12` it reports
D3D12 on NVIDIA GeForce RTX 4070 (`Accelerated: yes`). The developer ran Baize
with `GALLIUM_DRIVER=d3d12 cargo run`: the supplied startup log retains EGL
device-information warnings but no longer includes the Zink or DRI2 screen
creation errors. WebKit's actual backend remains unverified. No persistent
environment override has been configured.
