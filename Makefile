NAME = cupi-joy

PI_USER = pi
PI_ADDRESS = 192.168.1.9

TARGET = arm-unknown-linux-gnueabihf
CARGO = cargo

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

run:
	scp target/$(TARGET)/debug/$(NAME) $(PI_USER)@$(PI_ADDRESS):~
	ssh $(PI_USER)@$(PI_ADDRESS) chmod +x ./$(NAME)
	ssh $(PI_USER)@$(PI_ADDRESS) bash -c "./$(NAME) | true"
	ssh $(PI_USER)@$(PI_ADDRESS) killall ./$(NAME)

kill:
	ssh $(PI_USER)@$(PI_ADDRESS) killall ./$(NAME)

ssh:
	ssh $(PI_USER)@$(PI_ADDRESS)

.PHONY: all build clean check test bench doc run ssh
