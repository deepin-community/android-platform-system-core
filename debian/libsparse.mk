NAME = libsparse
SOURCES = \
        backed_block.cpp \
        output_file.cpp \
        sparse.cpp \
        sparse_crc32.cpp \
        sparse_err.cpp \
        sparse_read.cpp \

CSOURCES := $(foreach source, $(filter %.c, $(SOURCES)), libsparse/$(source))
CXXSOURCES := $(foreach source, $(filter %.cpp, $(SOURCES)), libsparse/$(source))
COBJECTS := $(CSOURCES:.c=.o)
CXXOBJECTS := $(CXXSOURCES:.cpp=.o)
CFLAGS += -c
CXXFLAGS += -c -std=gnu++17
CPPFLAGS += -Iinclude -Ilibsparse/include -Ibase/include
LDFLAGS += \
  -shared -Wl,-soname,$(NAME).so.0 \
  -lz \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -L. \
  -lbase


build: $(COBJECTS) $(CXXOBJECTS)
	$(CXX) $^ -o $(NAME).so.0 $(LDFLAGS)
	ln -s $(NAME).so.0 $(NAME).so

clean:
	$(RM) $(CXXOBJECTS) $(COBJECTS) $(NAME).so*

$(COBJECTS): %.o: %.c
	$(CC) $< -o $@ $(CFLAGS) $(CPPFLAGS)

$(CXXOBJECTS): %.o: %.cpp
	$(CXX) $< -o $@  $(CXXFLAGS) $(CPPFLAGS)
