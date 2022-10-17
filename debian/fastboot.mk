NAME = fastboot
fastboot_SOURCES = \
          bootimg_utils.cpp \
          fastboot.cpp \
          fastboot_driver.cpp \
          fs.cpp \
          main.cpp \
          socket.cpp \
          tcp.cpp \
          udp.cpp \
          usb_linux.cpp \
          util.cpp \

fs_mgr_liblp_SOURCES := \
        builder.cpp \
        images.cpp \
        partition_opener.cpp \
        reader.cpp \
        utility.cpp \
        writer.cpp \

SOURCES := \
  $(foreach source, $(fastboot_SOURCES), fastboot/$(source)) \
  $(foreach source, $(fs_mgr_liblp_SOURCES), fs_mgr/liblp/$(source)) \

CXXFLAGS += -std=gnu++2a -fpermissive
CPPFLAGS += \
            -DPLATFORM_TOOLS_VERSION='"$(PLATFORM_TOOLS_VERSION)"' \
            -D_FILE_OFFSET_BITS=64 \
            -Iinclude \
            -Imkbootimg/include/bootimg \
            -Iadb \
            -Ibase/include \
            -Idemangle/include \
            -Idiagnose_usb/include \
            -Ifs_mgr/include \
            -Ifs_mgr/include_fstab \
            -Ifs_mgr/liblp/include \
            -I/usr/include/android/openssl \
            -Ilibsparse/include \
            -Ilibziparchive/include
LDFLAGS += -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -fuse-ld=gold \
           -Wl,-rpath-link=. \
           -L. -lziparchive -lsparse -lbase -lcutils -ladb -lcrypto -lext4_utils \
           -L/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -l7z \

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifneq ($(filter armel mipsel,$(DEB_HOST_ARCH)),)
  LDFLAGS += -latomic
endif

build: $(SOURCES)
	$(CXX) $^ -o fastboot/$(NAME) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)

clean:
	$(RM) fastboot/$(NAME)
