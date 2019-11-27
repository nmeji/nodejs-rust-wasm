use wasm_bindgen::prelude::*;
use std::collections::HashMap;

#[macro_use]
extern crate serde_derive;

#[derive(Serialize, Deserialize)]
pub struct Example {
    pub field1: HashMap<u32, String>,
    pub field2: Vec<Vec<f32>>,
    pub field3: [f32; 4],
}

#[derive(Deserialize)]
pub struct Person {
    pub first_name: String,
    pub last_name: String,
}

#[wasm_bindgen]
pub fn send_example_to_js() -> JsValue {
    let mut field1 = HashMap::new();
    field1.insert(0, String::from("ex"));
    let example = Example {
        field1,
        field2: vec![vec![1., 2.], vec![3., 4.]],
        field3: [1., 2., 3., 4.]
    };

    JsValue::from_serde(&example).unwrap()
}

#[wasm_bindgen]
pub fn join_name(param: &JsValue) -> String {
    let person: Person = param.into_serde().unwrap();
    format!("{} {}", person.first_name, person.last_name)
}

#[wasm_bindgen]
pub fn add(a: u32, b: u32) -> u32 {
    a + b
}

#[wasm_bindgen]
pub fn not(b: bool) -> bool {
    !b
}

#[wasm_bindgen]
pub fn reverse(word: String) -> String {
    word.chars().rev().collect::<String>()
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}
