# 0002 — Use Wry for the prototype

- Status: Accepted
- Date: 2026-11-15

## Context

Baize needs to embed an existing web engine in a Rust desktop application on
Linux. The initial development environment is Ubuntu 24.04 on WSL 2 with WSLg.
The developer confirmed that `xclock` opens a GUI window on the Windows desktop.

The long-term goal is to develop a separate custom engine while retaining the
browser's interface and features where practical.

## Options

- Use WebKitGTK directly for Linux-specific integration and API access.
- Use Wry as a Rust abstraction over platform webviews; on Linux it uses WebKitGTK.
- Embed Chromium through CEF, accepting more complex build and distribution work.

## Decision

Choose Wry for the first prototype. It offers Rust APIs for
embedding web content and a route to other desktop platforms later.

The initial Linux prototype has been validated by the developer. Tao was selected
for windowing in [ADR 0003](0003-tao-for-windowing.md); browser controls remain
to be designed.

Keep browser state separate from Wry-specific code where practical. Avoid
designing an extensive engine abstraction before the prototype establishes the
actual requirements.

## Consequences

- Linux requires WebKitGTK and compatible GTK integration.
- Wry does not implement the browser's tabs, address bar, bookmarks, or full UI.
- Other operating systems use different underlying webviews, so compatibility
  must be validated per platform.
- Browser features may require platform-specific APIs beyond Wry's common API.
- A custom engine will need its own integration with Baize; Wry is not a generic
  plug-in interface for arbitrary engines.

## Validation

Completed: the developer verified Linux GUI support by opening `xclock` through
WSLg. This verifies the GUI environment, not Wry or WebKitGTK.

Completed: the developer reported that the Wry/Tao example launches successfully.

Completed: the developer confirmed page rendering, keyboard/mouse input,
resizing, and normal shutdown.

Known limitation: EGL/Mesa/Zink initialization warnings are printed at startup
under WSLg. Visible behavior is reported as normal. The developer's `glxinfo`
diagnostics select llvmpipe by default, but explicitly setting
`GALLIUM_DRIVER=d3d12` selects the NVIDIA GeForce RTX 4070 and reports
`Accelerated: yes`. This confirms that accelerated OpenGL is available for that
test; it does not establish WebKit's actual rendering backend. A subsequent Baize
launch with the same override still prints EGL device-information warnings, but
the supplied log no longer includes the Zink or DRI2 screen creation errors.

## References

- [ADR 0001](0001-linux-first-existing-engine.md)
- [Wry README and platform requirements](https://github.com/tauri-apps/wry)
- [Wry WebViewBuilder API](https://docs.rs/wry/latest/wry/struct.WebViewBuilder.html)
