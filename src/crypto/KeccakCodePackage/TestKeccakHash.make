all: TestKeccakHash1600

BINDIR = bin/build/TestKeccakHash1600
$(BINDIR):
	mkdir -p $(BINDIR)

CC = gcc
CXX= g++

CFLAGS := $(CFLAGS) -O0 -g

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

HEADERS := $(HEADERS) SnP/KeccakF-1600/KeccakF-1600-interface.h
SOURCES := $(SOURCES) SnP/KeccakF-1600/KeccakF-1600-interface.h
CFLAGS := $(CFLAGS) -ISnP/KeccakF-1600/

HEADERS := $(HEADERS) SnP/KeccakF-1600/Compact64/SnP-interface.h
SOURCES := $(SOURCES) SnP/KeccakF-1600/Compact64/SnP-interface.h
CFLAGS := $(CFLAGS) -ISnP/KeccakF-1600/Compact64/

HEADERS := $(HEADERS) SnP/SnP-FBWL-default.h
SOURCES := $(SOURCES) SnP/SnP-FBWL-default.h
CFLAGS := $(CFLAGS) -ISnP/

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

SOURCES := $(SOURCES) SnP/KeccakF-1600/Compact64/KeccakF-1600-compact64.c
$(BINDIR)/KeccakF-1600-compact64.o: SnP/KeccakF-1600/Compact64/KeccakF-1600-compact64.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/KeccakF-1600-compact64.o

SOURCES := $(SOURCES) SnP/SnP-FBWL-default.c
$(BINDIR)/SnP-FBWL-default.o: SnP/SnP-FBWL-default.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/SnP-FBWL-default.o

TestKeccakHash1600: $(BINDIR) $(OBJECTS)
	$(CXX) $(CFLAGS) -o $@ $(OBJECTS)

clean:
	echo "Make Clean..."
	rm -rf TestKeccakHash1600.exe $(OBJECTS) $(BINDIR)