all: KeccakWidth1600Reference
KeccakWidth1600Reference: bin/KeccakWidth1600Reference
KeccakWidth1600Reference.pack: bin/KeccakWidth1600Reference.tar.gz

BINDIR = bin/build/KeccakWidth1600Reference
$(BINDIR):
	mkdir -p $(BINDIR)

CC = gcc

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

HEADERS := $(HEADERS) Tests/genKAT.h
SOURCES := $(SOURCES) Tests/genKAT.h
CFLAGS := $(CFLAGS) -ITests/

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

SOURCES := $(SOURCES) Tests/genKAT.c
$(BINDIR)/genKAT.o: Tests/genKAT.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/genKAT.o

SOURCES := $(SOURCES) Tests/main.c
$(BINDIR)/main.o: Tests/main.c $(HEADERS)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
OBJECTS := $(OBJECTS) $(BINDIR)/main.o

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

bin/KeccakWidth1600Reference: $(BINDIR) $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS)

bin/KeccakWidth1600Reference.tar.gz: $(SOURCES)
	mkdir -p bin/pack/KeccakWidth1600Reference
	rm -rf bin/pack/KeccakWidth1600Reference/*
	cp $(SOURCES) bin/pack/KeccakWidth1600Reference/
	cd bin/pack/ ; tar -czf ../../bin/KeccakWidth1600Reference.tar.gz KeccakWidth1600Reference/*

