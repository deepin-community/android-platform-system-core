NAME = append2simg
SOURCES = append2simg.cpp
SOURCES := $(foreach source, $(SOURCES), libsparse/$(source))
CPPFLAGS += -Ilibsparse/include -Iinclude -std=gnu++17
LDFLAGS += -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -Wl,-rpath-link=. \
           -L. -lsparse

build: $(SOURCES)
	$(CXX) $^ -o libsparse/$(NAME) $(CPPFLAGS) $(LDFLAGS)

clean:
	$(RM) libsparse/$(NAME)
