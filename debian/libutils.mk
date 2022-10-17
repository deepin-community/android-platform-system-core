
include /usr/share/dpkg/architecture.mk

NAME = libutils
SOURCES = \
        CallStack.cpp \
        FileMap.cpp \
        JenkinsHash.cpp \
        Looper.cpp \
        misc.cpp \
        NativeHandle.cpp \
        Printer.cpp \
        ProcessCallStack.cpp \
        PropertyMap.cpp \
        RefBase.cpp \
        SharedBuffer.cpp \
        StopWatch.cpp \
        String16.cpp \
        String8.cpp \
        StrongPointer.cpp \
        SystemClock.cpp \
        Threads.cpp \
        Timers.cpp \
        Tokenizer.cpp \
        Unicode.cpp \
        VectorImpl.cpp \

SOURCES := $(foreach source, $(SOURCES), libutils/$(source))
CXXFLAGS += -std=gnu++17
CPPFLAGS += \
            -Iinclude \
            -Ibase/include \
            -Icutils/include \
            -Ilibprocessgroup/include \
            -DLIBUTILS_NATIVE=1 \

LDFLAGS += -shared -Wl,-soname,$(NAME).so.0 \
           -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -lpthread -L. -llog -lcutils -lbacktrace

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifeq ($(DEB_HOST_ARCH), armel)
  LDFLAGS += -latomic
endif
ifeq ($(DEB_HOST_ARCH), mipsel)
  LDFLAGS += -latomic
endif

build: $(SOURCES)
	$(CXX) $^ -o $(NAME).so.0 $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)
	ln -s $(NAME).so.0 $(NAME).so

clean:
	$(RM) $(NAME).so*
