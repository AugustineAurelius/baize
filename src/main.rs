// Copyright 2020-2023 Tauri Programme within The Commons Conservancy
// SPDX-License-Identifier: Apache-2.0
// SPDX-License-Identifier: MIT

use std::rc::Rc;

use baize::util;
use tao::{
    event::{Event, WindowEvent},
    event_loop::{ControlFlow, EventLoop},
    window::WindowBuilder,
};
use wry::WebViewBuilder;

fn main() -> wry::Result<()> {
    let Some(first_arg) = std::env::args().nth(1) else {
        eprintln!("URL expected as first argument");
        std::process::exit(1);
    };

    let initial_url = match util::parse_url(first_arg.as_str()) {
        Ok(parsed_url) => parsed_url,
        Err(e) => {
            eprintln!("Invalid URL: {e}");
            std::process::exit(1);
        }
    };

    let event_loop = EventLoop::new();
    let window = WindowBuilder::new().build(&event_loop).unwrap();

    let builder = WebViewBuilder::new()
        .with_url(initial_url.as_str())
        .with_new_window_req_handler(|url, features| {
            println!("new window req: {url} {features:?}");
            wry::NewWindowResponse::Allow
        });

    let builder = builder.with_drag_drop_handler(|e| {
        match e {
            wry::DragDropEvent::Enter { paths, position } => {
                println!("DragEnter: {position:?} {paths:?} ")
            }
            wry::DragDropEvent::Over { position } => println!("DragOver: {position:?} "),
            wry::DragDropEvent::Drop { paths, position } => {
                println!("DragDrop: {position:?} {paths:?} ")
            }
            wry::DragDropEvent::Leave => println!("DragLeave"),
            _ => {}
        }

        true
    });

    let _webview = {
        use gtk::prelude::*;
        use tao::platform::unix::WindowExtUnix;
        use wry::WebViewBuilderExtUnix;

        let vbox = window.default_vbox().unwrap();
        let address = gtk::Entry::new();
        address.set_text(initial_url.as_str());
        vbox.pack_start(&address, false, false, 0);
        address.show();
        let webview = Rc::new(builder.build_gtk(vbox)?);

        let address_handler = Rc::clone(&webview);
        address.connect_activate(move |entry| {
            let new_url = match util::parse_url(entry.text().as_str()) {
                Ok(parsed_url) => parsed_url,
                Err(e) => {
                    eprintln!("Invalid URL: {e}");
                    return;
                }
            };

            if let Err(e) = address_handler.load_url(new_url.as_str()) {
                eprintln!("Failed to load URL: {e}");
            }
        });
        webview
    };

    event_loop.run(move |event, _, control_flow| {
        *control_flow = ControlFlow::Wait;

        if let Event::WindowEvent {
            event: WindowEvent::CloseRequested,
            ..
        } = event
        {
            *control_flow = ControlFlow::Exit;
        }
    });
}
