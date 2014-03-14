RAGEL = ragel
BISON = bison
UNAME := $(shell uname)
LDSHARED?=$(CC) -shared
OBJECTS = calc++-parser.tab.o calc++-scanner.o calc++.o calc++-driver.o
#CFLAGS = -fPIC -O2 -DYYDEBUG

all: calc++

calc++: $(OBJECTS)
	$(CXX) -o $@ $(OBJECTS)

calc++-scanner.cc: calc++-scanner.ll
	flex --outfile=calc++-scanner.cc  $<

calc++-parser.tab.hh calc++-parser.tab.cc: calc++-parser.yy
	$(BISON) calc++-parser.yy

clean:
	rm -f *.stackdump stack.hh position.hh location.hh calc++-scanner.hh calc++-parser.tab.hh calc++-parser.tab.cc *.o calc++

