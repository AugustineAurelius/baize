use gtk::prelude::*;
use gtk::{Box, Button, Orientation};

pub struct Toolbar {
    pub container: Box,
    pub address: gtk::Entry,
    pub next: Button,
    pub back: Button,
    pub reload: Button,
}

impl Toolbar {
    pub fn new(initial_url: &str) -> Self {
        let container = Box::new(Orientation::Horizontal, 4);
        let next = Button::with_label("next");
        let back = Button::with_label("back");
        let reload = Button::with_label("renew");
        container.pack_start(&next, false, false, 0);
        container.pack_start(&back, false, false, 0);
        container.pack_start(&reload, false, false, 0);

        let address = gtk::Entry::new();
        address.set_text(initial_url);
        container.pack_start(&address, true, true, 0);

        Toolbar {
            container,
            address,
            next,
            back,
            reload,
        }
    }
}
