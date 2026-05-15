JAVAC   = javac
JAVA    = java
SRC_DIR = .
BIN_DIR = bin
PACKAGE = barScheduling
MAIN    = $(PACKAGE).SchedulingSimulation

ARGS ?= 30 2 5 30

SOURCES = $(wildcard $(SRC_DIR)/$(PACKAGE)/*.java)

.PHONY: all run clean

all: $(BIN_DIR)
	$(JAVAC) -d $(BIN_DIR) $(SOURCES)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)
	mkdir -p results

run: all
	$(JAVA) -cp $(BIN_DIR) $(MAIN) $(ARGS)

clean:
	rm -rf $(BIN_DIR)
	rm -rf results
