use std::ops::Drop;
use yew::prelude::*;

use jobs::app_worker::*;

pub struct AnalysisGroup {
    worker: Box<Bridge<AppWorker>>,
}

pub enum AnalysisGroupMessage {
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

impl Component for AnalysisGroup {
    type Message = AnalysisGroupMessage;
    type Properties = Props;

    fn create(_: Self::Properties, link: ComponentLink<Self>) -> Self {
        let callback = link.send_back(|_| {
                // By the moment, navbar does not accept any message
                AnalysisGroupMessage::None
            }
        );
        let worker = AppWorker::bridge(callback);
        worker.send(Request::RegisterComponent("analysis_group".into()));
        AnalysisGroup { worker }
    }

    fn update(&mut self, msg: Self::Message) -> ShouldRender {
        match msg {
            _ => {}
        }
        false 
    }

    fn change(&mut self, _: Self::Properties) -> ShouldRender {
        false
    }

    fn destroy(&mut self) {
        self.worker.send(Request::UnregisterComponent("analysis_group".into()))
    }
}

impl Renderable<AnalysisGroup> for AnalysisGroup {
    fn view(&self) -> Html<Self> {
        html! {
            <>
                {"WIP AnalysisGroup"}
            </>
        }
    }
}