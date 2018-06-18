use yew::prelude::*;

use jobs::app_worker::*;

pub struct Navbar {
    worker: Box<Bridge<AppWorker>>,
}

pub enum NavbarMessage {
    Go(String),
    None,
}

#[derive(PartialEq, Clone)]
pub struct Props {
}

impl Default for Props {
    fn default() -> Self {
        Props {}
    }
}

impl Component for Navbar {
    type Message = NavbarMessage;
    type Properties = Props;

    fn create(_: Self::Properties, link: ComponentLink<Self>) -> Self {
        let callback = link.send_back(|_| {
                // By the moment, navbar does not accept any message
                NavbarMessage::None
            }
        );
        let worker = AppWorker::bridge(callback);
        worker.send(Request::RegisterComponent("navbar".into()));
        Navbar { worker }
    }

    fn update(&mut self, msg: Self::Message) -> ShouldRender {
        match msg {
            NavbarMessage::Go(place) => {
                self.worker.send(Request::SendMessageTo("router".into(), Response::Go(place.into())));
            }
            _ => {}
        }
        false 
    }

    fn change(&mut self, _: Self::Properties) -> ShouldRender {
        false
    }
}

impl Renderable<Navbar> for Navbar {
    fn view(&self) -> Html<Self> {
        html! {
            <>
                <div
                    id="main-menu",
                    class=("main-menu","collapse","navbar-collapse"),>
                    <ul class=("nav","navbar-nav"),>
                        <li>
                            <a href="#", onclick=|_| NavbarMessage::Go("/".into()),>
                                {"Dashboard "}
                            </a>
                        </li>
                        <li>
                            <a href="#", onclick=|_| NavbarMessage::Go("/analysis_groups".into()),>
                                {"Analysis Group "}
                            </a>
                        </li>
                    </ul>
                </div>
            </>
        }
    }
}