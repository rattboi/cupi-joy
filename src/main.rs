extern crate cupi;
extern crate joy;

use cupi::{DigitalWrite, delay_ms};
use cupi::mcp23x17::{MCP23S17, PinOutput};

fn main() {
    let mcp23s17 = unsafe { MCP23S17::new(0).unwrap() };
    let mut port_out = mcp23s17.porta();

    let mut pinout0 = port_out.output(0).unwrap();

    let mut js_dev = joy::Device::open("/dev/input/js0\0".as_bytes()).unwrap();
    loop {
        for ev in &mut js_dev {
            use joy::Event::*;
            pinout0 = match ev {
                Axis(_, _) => pinout0,
                Button(n, b) => handle_buttons(n, b, pinout0),
            }
        }
    }
}

fn handle_buttons(n: u8, state: bool, mut pin: PinOutput) -> PinOutput {
    // println!("button {} state is {}", n, state);
    if state == true {
        pin.set(1).unwrap();
    } else {
        pin.set(0).unwrap();
    }
    pin
}
