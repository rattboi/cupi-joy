NAME = cupi-joy

PI_USER = pi
PI_ADDRESS = 192.168.1.9

TARGET = arm-unknown-linux-gnueabihf
CARGO = cargo
STRIP = arm-linux-gnueabihf-strip

CARGO_OPTS = --target=$(TARGET)


all:
	$(MAKE) build
	$(MAKE) doc

build:
	$(CARGO) build $(CARGO_OPTS)

clean:
	$(CARGO) clean $(CARGO_OPTS)

check:
	$(MAKE) build
	$(MAKE) test

test:
	$(CARGO) test $(CARGO_OPTS)

bench:
	$(CARGO) bench $(CARGO_OPTS)

doc:
	$(CARGO) doc $(CARGO_OPTS)

debug:
	$(CARGO) build $(CARGO_OPTS)
	scp target/$(TARGET)/debug/$(NAME) $(PI_USER)@$(PI_ADDRESS):~
	ssh $(PI_USER)@$(PI_ADDRESS) chmod +x ./$(NAME)
	ssh $(PI_USER)@$(PI_ADDRESS) ./$(NAME) &
	@read -p "Press enter to kill:" unused;
	ssh $(PI_USER)@$(PI_ADDRESS) killall ./$(NAME)

release:
	$(CARGO) build $(CARGO_OPTS) --release
	$(STRIP) target/$(TARGET)/release/$(NAME)
	scp target/$(TARGET)/release/$(NAME) $(PI_USER)@$(PI_ADDRESS):~
	ssh $(PI_USER)@$(PI_ADDRESS) chmod +x ./$(NAME)
	ssh $(PI_USER)@$(PI_ADDRESS) ./$(NAME) &
	@read -p "Press enter to kill:" unused;
	ssh $(PI_USER)@$(PI_ADDRESS) killall ./$(NAME)

kill:
	ssh $(PI_USER)@$(PI_ADDRESS) killall ./$(NAME)

ssh:
	ssh $(PI_USER)@$(PI_ADDRESS)

.PHONY: all build clean check test bench doc run ssh
