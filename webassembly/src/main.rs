#[macro_use]
extern crate yew;
#[macro_use]
extern crate stdweb;
#[macro_use]
extern crate lazy_static;
#[macro_use]
extern crate serde_derive;

use yew::prelude::*;
// use yew::services::console::ConsoleService;

mod jobs;
// pub use services::app_state::{AppState, AppStateMsg};
mod components;
use components::app_router::*;


fn main() {
    yew::initialize();
    App::<AppRouter>::new().mount_to_body();
    yew::run_loop();

}