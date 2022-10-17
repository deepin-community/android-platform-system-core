NAME := libadb

LIBADB_SRC_FILES := \
    adb.cpp \
    adb_io.cpp \
    adb_listeners.cpp \
    adb_trace.cpp \
    adb_unique_fd.cpp \
    adb_utils.cpp \
    fdevent.cpp \
    services.cpp \
    sockets.cpp \
    socket_spec.cpp \
    sysdeps/errno.cpp \
    transport.cpp \
    transport_fd.cpp \
    transport_local.cpp \
    transport_usb.cpp \

LIBADB_posix_srcs := \
    sysdeps_unix.cpp \
    sysdeps/posix/network.cpp \

LIBADB_linux_SRC_FILES := \
    client/auth.cpp \
    client/usb_dispatch.cpp \
    client/usb_libusb.cpp \
    client/usb_linux.cpp \

LOCAL_SRC_FILES := \
    $(LIBADB_SRC_FILES) \
    $(LIBADB_posix_srcs) \
    $(LIBADB_linux_SRC_FILES) \

LIBDIAGNOSE_USB_SRC_FILES = diagnose_usb/diagnose_usb.cpp

GEN := transport_mdns_unsupported.cpp

SOURCES := $(foreach source, $(LOCAL_SRC_FILES), adb/$(source)) $(LIBDIAGNOSE_USB_SRC_FILES) $(GEN)
CXXFLAGS += -std=gnu++2a
CPPFLAGS += \
            -Iadb \
            -Ibase/include \
            -Idiagnose_usb/include \
            -Ilibcrypto_utils/include \
            -Iinclude \
            -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
            -DADB_HOST=1 -DADB_VERSION='"$(DEB_VERSION)"'

LDFLAGS += -shared -Wl,-soname,$(NAME).so.0 \
           -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -L/usr/lib/$(DEB_HOST_MULTIARCH)/android -lcrypto \
           -lpthread -L. -lbase -lcutils -lcrypto_utils -lusb-1.0

$(NAME).so: $(SOURCES)
	$(CXX) $^ -o $(NAME).so.0 $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)
	ln -s $(NAME).so.0 $(NAME).so

transport_mdns_unsupported.cpp:
	echo 'void init_mdns_transport_discovery(void) {}' > transport_mdns_unsupported.cpp

clean:
	$(RM) $(NAME).so* transport_mdns_unsupported.cpp
