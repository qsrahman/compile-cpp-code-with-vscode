# $@
# The full target filename. By target, I mean the file that needs to be built, 
# such as a .o file being compiled from a .c file or a program made by linking 
# .o files.

# $*
# The target file with the suffix cut off. So if the target is prog.o, $* is 
# prog, and $*.c would become prog.c.

# $<
# The name of the file that caused this target to get triggered and made. If 
# we are making prog.o, it is probably because prog.c has recently been 
# modified, so $< is prog.c.

# CFLAGS=`pkg-config --cflags apophenia glib-2.0` -g -Wall -std=gnu11 -O3
# LDLIBS=`pkg-config --libs apophenia glib-2.0`

# Or, specify the -I, -L, and -l flags manually, like: 
#	CFLAGS=-I/home/b/root/include -g -Wall -O3 -std=gnu11
#	LDLIBS=-L/home/b/root/lib -lweirdlib

CC=clang
CXX=clang++
CFLAGS=-c -g -Wall -Wextra -Wpedantic -O3 -std=gnu11 -I/usr/local/include
CXXFLAGS=-c -g -Wall -Wextra -Wpedantic -O3 -std=c++17 -I/usr/local/include
LDFLAGS=-L/usr/local/lib

SRCDIR=src
BUILDDIR=build

EXEC=demo
#C_SOURCES=$(wildcard $(SRCDIR)/*.c)
#CXX_SOURCES=$(wildcard $(SRCDIR)/*.cpp)
C_OBJECTS=$(patsubst $(SRCDIR)/%.c,$(BUILDDIR)/%.o,$(wildcard $(SRCDIR)/*.c))
CXX_OBJECTS=$(patsubst $(SRCDIR)/%.cpp,$(BUILDDIR)/%.o,$(wildcard $(SRCDIR)/*.cpp))

all: $(BUILDDIR)/$(EXEC)

$(BUILDDIR)/$(EXEC): $(CXX_OBJECTS) $(C_OBJECTS)
	$(CXX) $(LDFLAGS) $(CXX_OBJECTS) $(C_OBJECTS) -o $@

$(CXX_OBJECTS): $(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(C_OBJECTS): $(BUILDDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) $< -o $@

dir:
	mkdir -p $(BUILDDIR)

run: clean all
	$(BUILDDIR)/$(EXEC)

clean: clean-objs
	rm -f $(BUILDDIR)/$(EXEC)
	
clean-objs:
	rm -f $(CXX_OBJECTS) $(C_OBJECTS)

.PHONY: all run clean clean-objs dir
