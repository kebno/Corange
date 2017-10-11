DEMO=teapot
CC=gcc

CFLAGS += -I../../include -I../../glad/include -I/Users/john/sw/include -std=gnu99 -Wall -Werror -Wno-unused -O3 -g

PLATFORM = $(shell uname)

ifeq ($(findstring Linux,$(PLATFORM)),Linux)
	OUT=$(DEMO)
	LFLAGS= -lcorange -lGL -lSDL2 -lSDL2_net -lSDL2_mixer -lm
endif

ifeq ($(findstring Darwin,$(PLATFORM)),Darwin)
	OUT=$(DEMO)
	LFLAGS= -L/Users/john/sw/lib -lcorange -lSDL2main -lSDL2 -lSDL2_net -lSDL2_mixer -framework OpenGL
endif

ifeq ($(findstring MINGW,$(PLATFORM)),MINGW)
	OUT=$(DEMO).exe
	LFLAGS= ../../corange.res -lcorange -lmingw32 -lSDL2main -lSDL2 -lSDL2_net -lSDL2_mixer -lopengl32
endif

$(OUT): teapot.c
	$(CC) $^ ../../glad.o $(CFLAGS) $(LFLAGS) -o $@

clean:
	rm -f $(OUT)

