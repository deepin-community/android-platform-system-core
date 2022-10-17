NAME = simg2img
SOURCES = simg2img.cpp sparse_crc32.cpp
SOURCES := $(foreach source, $(SOURCES), libsparse/$(source))
CPPFLAGS += -Ilibsparse/include -Iinclude -std=gnu++17
LDFLAGS += -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -Wl,-rpath-link=. \
           -L. -lsparse

build: $(SOURCES)
	$(CXX) $^ -o libsparse/$(NAME) $(CPPFLAGS) $(LDFLAGS)

clean:
	$(RM) libsparse/$(NAME)
