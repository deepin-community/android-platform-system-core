NAME = libnativeloader
SOURCES = native_loader.cpp
SOURCES := $(foreach source, $(SOURCES), libnativeloader/$(source))

CPPFLAGS += \
  -Iinclude \
  -Ibase/include \
  -Ilibnativebridge/include \
  -Ilibnativeloader/include \
  -I/usr/include/android/nativehelper \

CXXFLAGS += -std=gnu++2a

LDFLAGS += \
  -shared -Wl,-soname,$(NAME).so.0 \
  -ldl \
  -Wl,-rpath=/usr/lib/$(DEB_HOST_MULTIARCH)/android \
  -L. \
  -lnativebridge -lbase

build: $(SOURCES)
	$(CXX) $^ -o $(NAME).so.0 $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS)
	ln -s $(NAME).so.0 $(NAME).so

clean:
	$(RM) $(NAME).so*
