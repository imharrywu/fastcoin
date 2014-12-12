all: TestKeccakHash1600

BINDIR = bin/build/TestKeccakHash1600
$(BINDIR):
	mkdir -p $(BINDIR)

CC = gcc
CXX= g++

CFLAGS := $(CFLAGS) -DKeccakReference

CFLAGS := $(CFLAGS) -O

HEADERS := $(HEADERS) Common/brg_endian.h
SOURCES := $(SOURCES) Common/brg_endian.h
CFLAGS := $(CFLAGS) -ICommon/

HEADERS := $(HEADERS) Constructions/KeccakDuplex.h
SOURCES := $(SOURCES) Constructions/KeccakDuplex.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Constructions/KeccakSponge.h
SOURCES := $(SOURCES) Constructions/KeccakSponge.h
CFLAGS := $(CFLAGS) -IConstructions/

HEADERS := $(HEADERS) Modes/KeccakHash.h
SOURCES := $(SOURCES) Modes/KeccakHash.h
CFLAGS := $(CFLAGS) -IModes/

HEADERS := $(HEADERS) Tests/testDuplex.h
SOURCES := $(SOURCES) Tests/testDuplex.h
CFLAGS := $(CFLAGS) -ITests/

HEADERS := $(HEADERS) Tests/testSnP.h
SOURCES := $(SOURCES) Tests/testSnP.h
CFLAGS := $(CFLAGS) -ITests/

HEADERS := $(HEADERS) Tests/testSponge.h
SOURCES := $(SOURCES) Tests/testSponge.h
CFLAGS := $(CFLAGS) -ITests/

HEADERS := $(HEADERS) SnP/KeccakF-1600/KeccakF-1600-interface.h
SOURCES := $(SOURCES) SnP/KeccakF-1600/KeccakF-1600-interface.h
CFLAGS := $(CFLAGS) -ISnP/KeccakF-1600/

HEADERS := $(HEADERS) SnP/KeccakF-1600/Reference/KeccakF-reference.h
SOURCES := $(SOURCES) SnP/KeccakF-1600/Reference/KeccakF-reference.h
CFLAGS := $(CFLAGS) -ISnP/KeccakF-1600/Reference/

HEADERS := $(HEADERS) SnP/KeccakF-1600/Reference/SnP-interface.h
SOURCES := $(SOURCES) SnP/KeccakF-1600/Reference/SnP-interface.h
CFLAGS := $(CFLAGS) -ISnP/KeccakF-1600/Reference/

HEADERS := $(HEADERS) SnP/SnP-FBWL-default.h
SOURCES := $(SOURCES) SnP/SnP-FBWL-default.h
CFLAGS := $(CFLAGS) -ISnP/

HEADERS := $(HEADERS) Tests/displayIntermediateValues.h
SOURCES := $(SOURCES) Tests/displayIntermediateValues.h
CFLAGS := $(CFLAGS) -ITests/

SOURCES := $(SOURCES) Constructions/KeccakDuplex.c
$(BINDIR)/KeccakDuplex.o: Constructions/KeccakDuplex.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakDuplex.o

SOURCES := $(SOURCES) Constructions/KeccakSponge.c
$(BINDIR)/KeccakSponge.o: Constructions/KeccakSponge.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakSponge.o

SOURCES := $(SOURCES) Modes/KeccakHash.c
$(BINDIR)/KeccakHash.o: Modes/KeccakHash.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakHash.o

SOURCES := $(SOURCES) Tests/TestKeccakHash.cxx
$(BINDIR)/TestKeccakHash.o: Tests/TestKeccakHash.cxx $(HEADERS)
	$(CXX) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/TestKeccakHash.o

SOURCES := $(SOURCES) Tests/testDuplex.c
$(BINDIR)/testDuplex.o: Tests/testDuplex.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/testDuplex.o

SOURCES := $(SOURCES) Tests/testSnP.c
$(BINDIR)/testSnP.o: Tests/testSnP.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/testSnP.o

SOURCES := $(SOURCES) Tests/testSponge.c
$(BINDIR)/testSponge.o: Tests/testSponge.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/testSponge.o

SOURCES := $(SOURCES) SnP/KeccakF-1600/Reference/KeccakF-1600-reference.c
$(BINDIR)/KeccakF-1600-reference.o: SnP/KeccakF-1600/Reference/KeccakF-1600-reference.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakF-1600-reference.o

SOURCES := $(SOURCES) SnP/SnP-FBWL-default.c
$(BINDIR)/SnP-FBWL-default.o: SnP/SnP-FBWL-default.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/SnP-FBWL-default.o

SOURCES := $(SOURCES) Tests/displayIntermediateValues.c
$(BINDIR)/displayIntermediateValues.o: Tests/displayIntermediateValues.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/displayIntermediateValues.o

TestKeccakHash1600: $(BINDIR) $(OBJECTS)
	$(CXX) $(CFLAGS) -o $@ $(OBJECTS)

clean:
	echo "Make Clean..."
	rm -rf TestKeccakHash1600.exe $(OBJECTS) $(BINDIR)