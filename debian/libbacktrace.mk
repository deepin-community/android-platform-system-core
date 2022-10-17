
include /usr/share/dpkg/architecture.mk

NAME = libbacktrace

libbacktrace_SOURCES = \
          Backtrace.cpp \
          BacktraceCurrent.cpp \
          BacktraceMap.cpp \
          BacktracePtrace.cpp \
          ThreadEntry.cpp \
          UnwindMap.cpp \
          UnwindStack.cpp \
          UnwindStackMap.cpp \

libunwindstack_SOURCES := \
        ArmExidx.cpp \
        DwarfCfa.cpp \
        DwarfEhFrameWithHdr.cpp \
        DwarfMemory.cpp \
        DwarfOp.cpp \
        DwarfSection.cpp \
        Elf.cpp \
        ElfInterface.cpp \
        ElfInterfaceArm.cpp \
        Global.cpp \
        JitDebug.cpp \
        Log.cpp \
        MapInfo.cpp \
        Maps.cpp \
        Memory.cpp \
        LocalUnwinder.cpp \
        Regs.cpp \
        RegsArm.cpp \
        RegsArm64.cpp \
        RegsX86.cpp \
        RegsX86_64.cpp \
        RegsMips.cpp \
        RegsMips64.cpp \
        Unwinder.cpp \
        Symbols.cpp \

# these might still be needed by libart/dexdump/dexlist
libunwindstack_dexfile_SOURCES := \
        DexFile.cpp \
        DexFiles.cpp \

ifeq ($(DEB_HOST_ARCH), amd64)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsX86_64.S
endif
ifeq ($(DEB_HOST_ARCH), i386)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsX86.S
endif
ifeq ($(DEB_HOST_ARCH), armel)
  # TODO port me!
endif
ifeq ($(DEB_HOST_ARCH), armhf)
  # TODO port me!
endif
ifeq ($(DEB_HOST_ARCH), arm64)
  # TODO port me!
endif
ifeq ($(DEB_HOST_ARCH), mips)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsMips.S
endif
ifeq ($(DEB_HOST_ARCH), mipsel)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsMips.S
endif
ifeq ($(DEB_HOST_ARCH), mips64el)
  SOURCES_ASSEMBLY = libunwindstack/AsmGetRegsMips64.S
endif

demangle_srcs = demangle/Demangler.cpp

SOURCES = \
  $(foreach source, $(filter %.cpp, $(libbacktrace_SOURCES)), libbacktrace/$(source)) \
  $(foreach source, $(filter %.cpp, $(libunwindstack_SOURCES)), libunwindstack/$(source)) \
  $(demangle_srcs)

CXXOBJECTS = $(SOURCES:.cpp=.o)
OBJECTS_ASSEMBLY := $(SOURCES_ASSEMBLY:.S=.o)
CXXFLAGS += -c -std=gnu++2a -fno-omit-frame-pointer
CPPFLAGS += \
            -DNO_LIBDEXFILE_SUPPORT \
            -Iinclude \
            -Ibase/include \
            -Idemangle/include \
            -Ilibprocinfo/include \
            -Ilibunwindstack/include \
            -I/usr/include/android/lzma \
            -I/usr/include/android/unwind
LDFLAGS += -shared -Wl,-soname,$(NAME).so.0 \
           -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
           -L/usr/lib/$(DEB_HOST_MULTIARCH)/android -lunwind \
           -L. -lbase -llog -lpthread -l7z

# -latomic should be the last library specified
# https://github.com/android/ndk/issues/589
ifeq ($(DEB_HOST_ARCH), armel)
  LDFLAGS += -latomic
endif
ifeq ($(DEB_HOST_ARCH), mipsel)
  LDFLAGS += -latomic
endif

build: $(COBJECTS) $(CXXOBJECTS) $(OBJECTS_ASSEMBLY)
	$(CXX) $^ -o $(NAME).so.0 $(LDFLAGS)
	ln -s $(NAME).so.0 $(NAME).so

clean:
	$(RM) $(COBJECTS) $(CXXOBJECTS) $(NAME).so*

$(CXXOBJECTS): %.o: %.cpp
	$(CXX) $< -o $@ $(CXXFLAGS) $(CPPFLAGS)

$(COBJECTS): %.o: %.c
	$(CC) $< -o $@ $(CFLAGS) $(CPPFLAGS)

$(OBJECTS_ASSEMBLY): %.o: %.S
	$(CC) -c -o $@ $(CFLAGS) $(CPPFLAGS) -D__ASSEMBLY__ $^

