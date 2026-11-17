# 0004 — Native GTK address bar for Linux

- Status: Accepted
- Date: 2026-11-15

## Context

The developer wants to navigate without restarting Baize. Tao already exposes a
vertical GTK container on Linux, and Wry embeds WebKitGTK into that container.

## Options

- Add a native GTK Entry to the existing container.
- Build browser controls in a separate webview and route navigation through IPC.
- Introduce another UI toolkit and integrate its rendering with the webview.

## Decision

Use GTK 3 controls using the `gtk` 0.18 crate, compatible with the current
Tao/Wry dependencies. Place an Entry above the WebView. On Enter, validate input
with the existing URL helper and navigate the existing WebView with `load_url`.
Invalid input should leave the current page open and report an error; it must
not terminate the application.

The entry and Enter navigation are implemented. A Wry page-load handler updates
the same GTK Entry with the URL reported at page-load events. This does not yet
cover URL changes made without a page load, such as History API navigation.

## Consequences

- This UI implementation is Linux-specific; other platforms need separate UI work.
- No additional webview or privileged IPC channel is required for the address bar.
- Callback ownership and WebView lifetime must be handled explicitly when adding
  navigation.
- Application code remains the developer's responsibility.

## Validation

The developer reported working Enter navigation on 2026-11-15. Code review on
2026-11-17 confirms shared WebView ownership with Rc, non-fatal input validation,
load_url error handling, and address updates from the page-load callback.
`cargo test --offline` passes (one URL parsing test); this does not validate GUI
behavior. Link/redirect address synchronization and resize behavior still need
explicit manual confirmation.

## References

- [Tao WindowExtUnix](https://docs.rs/tao/0.37.2/tao/platform/unix/trait.WindowExtUnix.html)
- [GTK 0.18 Box](https://gtk-rs.org/gtk3-rs/stable/0.18/docs/gtk/struct.Box.html)
- [ADR 0003](0003-tao-for-windowing.md)
