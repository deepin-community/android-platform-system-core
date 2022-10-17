NAME = libbase
SOURCES = \
          chrono_utils.cpp \
          cmsg.cpp \
          errors_unix.cpp \
          file.cpp \
          logging.cpp \
          mapped_file.cpp \
          parsenetaddress.cpp \
          properties.cpp \
          quick_exit.cpp \
          stringprintf.cpp \
          strings.cpp \
          test_utils.cpp \
          threads.cpp \

SOURCES := $(foreach source, $(SOURCES), base/$(source))
CXXFLAGS += -std=gnu++17 -D_FILE_OFFSET_BITS=64
CPPFLAGS += -Iinclude -Ibase/include
LDFLAGS += -shared -Wl,-soname,$(NAME).so.0

build: $(SOURCES)
	$(CXX) $^ -o $(NAME).so.0 $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)
	ln -s $(NAME).so.0 $(NAME).so

clean:
	$(RM) $(NAME).so*
