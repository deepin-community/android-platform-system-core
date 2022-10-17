NAME = libcutils

# copied from libcutils/Android.bp
libcutils_nonwindows_sources = \
    fs.cpp \
    hashmap.cpp \
    multiuser.cpp \
    socket_inaddr_any_server_unix.cpp \
    socket_local_client_unix.cpp \
    socket_local_server_unix.cpp \
    socket_network_client_unix.cpp \
    sockets_unix.cpp \
    str_parms.cpp \

# copied from libcutils/Android.bp
cc_library_srcs = \
        config_utils.cpp \
        canned_fs_config.cpp \
        iosched_policy.cpp \
        load_file.cpp \
        native_handle.cpp \
        record_stream.cpp \
        sockets.cpp \
        strdup16to8.cpp \
        strdup8to16.cpp \
        strlcpy.c \
        threads.cpp \

# copied from libcutils/Android.bp
cc_library_target_not_windows_srcs = \
                ashmem-host.cpp \
                fs_config.cpp \
                trace-host.cpp \

SOURCES = \
  $(libcutils_nonwindows_sources) \
  $(cc_library_srcs) \
  $(cc_library_target_not_windows_srcs)


CSOURCES := $(foreach source, $(filter %.c, $(SOURCES)), libcutils/$(source))
CXXSOURCES := $(foreach source, $(filter %.cpp, $(SOURCES)), libcutils/$(source))
COBJECTS := $(CSOURCES:.c=.o)
CXXOBJECTS := $(CXXSOURCES:.cpp=.o)
CFLAGS += -c
CXXFLAGS += -c -std=gnu++17
CPPFLAGS += \
            -Ibase/include \
            -Ilibcutils/include \
            -Iinclude \

LDFLAGS += -shared -Wl,-soname,$(NAME).so.0 \
           -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android -lpthread -L. -llog -lbase

build: $(COBJECTS) $(CXXOBJECTS)
	$(CXX) $^ -o $(NAME).so.0 $(LDFLAGS)
	ln -s $(NAME).so.0 $(NAME).so

clean:
	$(RM) $(CXXOBJECTS) $(COBJECTS) $(NAME).so*

$(COBJECTS): %.o: %.c
	$(CC) $< -o $@ $(CFLAGS) $(CPPFLAGS)

$(CXXOBJECTS): %.o: %.cpp
	$(CXX) $< -o $@  $(CXXFLAGS) $(CPPFLAGS)
