use std::string::String;

use components::navbar::*;
use components::analysis_group::*;

pub trait Printer {
    fn print(&mut self, data: &str);
}

use yew::prelude::*;
use yew::services::console::ConsoleService;
use jobs::app_worker::*;

pub struct AppRouter {
    worker: Box<Bridge<AppWorker>>,
    console: ConsoleService,
    section: String,
}

#[derive(PartialEq, Clone)]
pub struct Props {
}

impl Default for Props {
    fn default() -> Self {
        Props {
        }
    }
}

pub enum RouterMessage {
    Go(String),
    None
}

impl Component for AppRouter {
    type Message = RouterMessage;
    type Properties = Props;

    fn create(_: Self::Properties, link: ComponentLink<Self>) -> Self {
        let callback = link.send_back(|msg| {
                match msg {
                    Response::Go(place) => {
                        RouterMessage::Go(place)        
                    }
                    _ => {
                        RouterMessage::None
                    }
                }
            }
        );
        let worker = AppWorker::bridge(callback);
        worker.send(Request::RegisterComponent("router".into()));
        AppRouter { worker, console: ConsoleService::new(), section: "/".into() }
    }

    fn update(&mut self, msg: Self::Message) -> ShouldRender {
        match msg {
            RouterMessage::Go(place) => {
                // We update the section where we are
                self.section = place.clone();
                true
            }
            RouterMessage::None => {false}
        }
    }

    fn change(&mut self, _: Self::Properties) -> ShouldRender {
        true
    }
}

impl Renderable<AppRouter> for AppRouter {
    fn view(&self) -> Html<Self> { 
        html! {
            <>
                <aside class="left-panel",>
                    <nav class=("navbar","navbar-expand-sm","navbar-default"),>
                        <div class="navbar-header",>
                            <button class="navbar-toggler", 
                                    type="button", 
                                    data-toggle="collapse",
                                    data-target="#main-menu",
                                    aria-controls="main-menu", 
                                    aria-expanded="false", 
                                    aria-label="Toggle navigation",>
                                <i class=("fa","fa-bars"),></i>
                            </button>
                            <a class="navbar-brand",
                                href="#",>{"BRD"}</a>
                        </div>
                        <Navbar: />
                    </nav>
                </aside>
                <div class="right-panel",>
                    {self.render_body()}
                </div>
            </>
        }
    }
}

impl AppRouter {
    fn render_body(&self) -> Html<AppRouter> {
        if self.section.as_str() == "/analysis_groups" {
            html! {
                    <>
                        <AnalysisGroup: />
                    </>
                }
        } else {
            html!{
                    <>
                        {&self.section}
                    </>
                }
        }
    }
}