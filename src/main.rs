extern crate cupi;
extern crate joy;

use cupi::{DigitalWrite};
use cupi::mcp23x17::{MCP23S17, PinOutput};

fn main() {
    let mcp23s17 = unsafe { MCP23S17::new(0).unwrap() };
    let mut port_out = mcp23s17.porta();

    let mut pinout0 = port_out.output(0).unwrap();

    let mut js_dev = joy::Device::open("/dev/input/js0\0".as_bytes()).unwrap();
    loop {
        for ev in &mut js_dev {
            use joy::Event::*;
            match ev {
                Axis(_, _) => handle_axes(),
                Button(n, b) => handle_buttons(n, b, &mut pinout0),
            }
        }
    }
}

fn handle_buttons(n: u8, state: bool, pin: &mut PinOutput) {
    // println!("button {} state is {}", n, state);
    if state == true {
        pin.set(1).unwrap();
    } else {
        pin.set(0).unwrap();
    }
}

fn handle_axes() {
}
