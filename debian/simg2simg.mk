NAME = simg2simg
SOURCES = simg2simg.cpp sparse_crc32.cpp
SOURCES := $(foreach source, $(SOURCES), libsparse/$(source))
CPPFLAGS += -Ilibsparse/include -Iinclude -fpermissive -std=gnu++17
LDFLAGS += -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -Wl,-rpath-link=. \
           -L. -lsparse -lz -lbase

# force GCC, clang fails on:
# libsparse/simg2simg.cpp:75:11: error: assigning to 'struct sparse_file **' from incompatible type 'void *'
#  out_s = calloc(sizeof(struct sparse_file*), files);

build: $(SOURCES)
	g++ $^ -o libsparse/$(NAME) $(CPPFLAGS) $(LDFLAGS)

clean:
	$(RM) libsparse/$(NAME)
