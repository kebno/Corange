AR=ar

SRC = $(wildcard src/*.c) $(wildcard src/*/*.c)
OBJ = $(addprefix obj/,$(notdir $(SRC:.c=.o)))

OBJ += glad.o

CFLAGS = -I ./include -std=gnu99 -Wall -Werror -Wno-unused -O3 -g -Wl,-no_compact_unwind
LDFLAGS = -shared -g

PLATFORM = $(shell uname)

ifeq ($(findstring Linux,$(PLATFORM)),Linux)
	DYNAMIC = libcorange.so
	STATIC = libcorange.a
	CFLAGS += -fPIC
	LFLAGS += -lGL -lSDL2 -lSDL2_mixer -lSDL2_net
endif

ifeq ($(findstring Darwin,$(PLATFORM)),Darwin)
	DYNAMIC = libcorange.so
	STATIC = libcorange.a
	CFLAGS += -I./glad/include -I/Users/john/sw/include -fPIC -D__unix__=1
    LDFLAGS += -L/Users/john/sw/lib -L./glad/src -lSDL2 -lSDL2_net -lSDL2_mixer -framework OpenGL
endif

ifeq ($(findstring MINGW,$(PLATFORM)),MINGW)
	DYNAMIC = corange.dll
	STATIC = libcorange.a
	LFLAGS = -lmingw32 -lopengl32 -lSDL2main -lSDL2 -lSDL2_mixer -lSDL2_net -shared -g
	OBJ += corange.res
endif


all: $(DYNAMIC) $(STATIC)

$(DYNAMIC): $^
	$(CC) $^ $(LDFLAGS) -o $@ $(CFLAGS)

$(STATIC): $(OBJ)
	$(AR) rcs $@ $^

obj/%.o: src/%.c | obj
	$(CC) $< -c $(CFLAGS) -o $@

obj/%.o: src/*/%.c | obj
	$(CC) $< -c $(CFLAGS) -o $@

obj:
	mkdir obj

glad.o: glad/src/glad.c
	${CC} ${CFLAGS} -c $^ -o $@

corange.res: corange.rc
	windres $< -O coff -o $@

clean:
	rm $(OBJ) $(STATIC) $(DYNAMIC)

install: $(STATIC)
	cp $(STATIC) /Users/john/sw/lib/$(STATIC)

install_win32: $(STATIC)
	cp $(STATIC) C:/MinGW/lib/$(STATIC)

install_win64: $(STATIC) $(DYNAMIC)
	cp $(STATIC) C:/MinGW64/x86_64-w64-mingw32/lib/$(STATIC)
	cp $(DYNAMIC) C:/MinGW64/x86_64-w64-mingw32/bin/$(DYNAMIC)
