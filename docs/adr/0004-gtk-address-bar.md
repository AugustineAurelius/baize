# 0004 — Native GTK address bar for Linux

- Status: Proposed
- Date: 2026-11-15

## Context

The developer wants to navigate without restarting Baize. Tao already exposes a
vertical GTK container on Linux, and Wry embeds WebKitGTK into that container.

## Options

- Add a native GTK Entry to the existing container.
- Build browser controls in a separate webview and route navigation through IPC.
- Introduce another UI toolkit and integrate its rendering with the webview.

## Decision

Propose GTK 3 controls using the `gtk` 0.18 crate, compatible with the current
Tao/Wry dependencies. Place an Entry above the WebView. On Enter, validate input
with the existing URL helper and navigate the existing WebView with `load_url`.
Invalid input should leave the current page open and report an error; it must
not terminate the application.

First implement and review the visible entry; add navigation in a separate step.
Address synchronization after redirects and link navigation is deferred.

## Consequences

- This UI implementation is Linux-specific; other platforms need separate UI work.
- No additional webview or privileged IPC channel is required for the address bar.
- Callback ownership and WebView lifetime must be handled explicitly when adding
  navigation.
- Application code remains the developer's responsibility.

## Validation

Pending: entry is visible above the page, page expands on resize, and Enter loads
a valid address while invalid input preserves the current page.

## References

- [Tao WindowExtUnix](https://docs.rs/tao/0.37.2/tao/platform/unix/trait.WindowExtUnix.html)
- [GTK 0.18 Box](https://gtk-rs.org/gtk3-rs/stable/0.18/docs/gtk/struct.Box.html)
- [ADR 0003](0003-tao-for-windowing.md)
