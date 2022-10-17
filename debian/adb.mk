NAME = adb

SOURCES = client/adb_client.cpp \
	client/bugreport.cpp \
	client/commandline.cpp \
	client/file_sync_client.cpp \
	client/main.cpp \
	client/console.cpp \
	client/adb_install.cpp \
	client/line_printer.cpp \
	shell_service_protocol.cpp

SOURCES := $(foreach source, $(SOURCES), adb/$(source))
CXXFLAGS += -std=gnu++2a
CPPFLAGS += -Iinclude -Iadb -Ibase/include \
            -DADB_VERSION='"$(DEB_VERSION)"' -DADB_HOST=1 -D_GNU_SOURCE
LDFLAGS += -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android -Wl,-rpath-link=. \
           -lpthread -L. -ladb -lbase

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

build: $(SOURCES)
	$(CXX) $^ -o adb/$(NAME) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

clean:
	$(RM) adb/$(NAME)
