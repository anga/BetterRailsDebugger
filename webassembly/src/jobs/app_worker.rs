use std::sync::RwLock;
use std::collections::HashMap;
use std::string::String;
use yew::prelude::worker::*;
use yew::services::console::ConsoleService;


#[derive(Serialize, Deserialize, Debug)]
pub enum Request {
    RegisterComponent(String),
    UnregisterComponent(String),
    SendMessageTo(String,Response),
    None,
}

impl Transferable for Request { }

// Components should check this enum when receiving a message
#[derive(Serialize, Deserialize, Debug)]
pub enum Response {
    Go(String),
    None
}

impl Transferable for Response { }

pub enum WorkerMessage {
    None,
}

pub struct AppWorker {
    link: AgentLink<AppWorker>,
    components: RwLock<HashMap<String, HandlerId>>
}

impl Agent for AppWorker {
    type Reach = Context;
    type Message = WorkerMessage;
    type Input = Request;
    type Output = Response;

    fn create(link: AgentLink<Self>) -> Self {
        js!{console.log("Created....");}
        AppWorker {
            link,
            components: RwLock::new(HashMap::new()),
        }
    }

    fn update(&mut self, _: Self::Message) {
    }

    fn handle(&mut self, msg: Self::Input, who: HandlerId) {
        match msg {
            Request::RegisterComponent(name) => {
                {
                    self.components.write().unwrap().insert(name.clone(), who.clone());
                }
                {
                    let mut console = ConsoleService::new();
                    console.log("Adding");
                    for key in self.components.get_mut().unwrap().keys() {
                        console.log(key);
                    }
                    console.log("Adding end");
                }
            }
            Request::UnregisterComponent(name) => {
                js!{console.log("Removing component");}
                self.components.write().unwrap().remove(&name.clone());
                {
                    let mut console = ConsoleService::new();
                    console.log("Removing");
                    for key in self.components.get_mut().unwrap().keys() {
                        console.log(key);
                    }
                    console.log("removingend"); 
                }
            }
            Request::SendMessageTo(to, message) => {
                match self.components.read().unwrap().get(&to) {
                    Some(who) => { 
                        self.link.response(*who, message); 
                    }
                    None => {}
                }
            }
            _ => {}
        }
    }
}
