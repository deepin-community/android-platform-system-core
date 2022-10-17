NAME = liblog

# copied from liblog/Android.bp
liblog_sources = \
    config_read.cpp \
    config_write.cpp \
    log_event_list.cpp \
    log_event_write.cpp \
    logger_lock.cpp \
    logger_name.cpp \
    logger_read.cpp \
    logger_write.cpp \
    logprint.cpp \
    stderr_write.cpp \

# copied from liblog/Android.bp
liblog_host_sources = \
    fake_log_device.cpp \
    fake_writer.cpp \

# copied from liblog/Android.bp
not_windows_sources = \
  event_tag_map.cpp \

SOURCES = $(liblog_sources) $(liblog_host_sources) $(not_windows_sources)
CSOURCES := $(foreach source, $(filter %.c, $(SOURCES)), liblog/$(source))
CXXSOURCES := $(foreach source, $(filter %.cpp, $(SOURCES)), liblog/$(source))
COBJECTS := $(CSOURCES:.c=.o)
CXXOBJECTS := $(CXXSOURCES:.cpp=.o)
CFLAGS += -c -fvisibility=hidden -fcommon
CXXFLAGS += -c -std=gnu++17
CPPFLAGS += \
            -Iliblog/include \
            -Iinclude \
            -DLIBLOG_LOG_TAG=1006 \
            -DFAKE_LOG_DEVICE=1 \
            -DSNET_EVENT_LOG_TAG=1397638484

LDFLAGS += -shared -Wl,-soname,$(NAME).so.0 -lpthread

build: $(COBJECTS) $(CXXOBJECTS)
	$(CXX) $^ -o $(NAME).so.0 $(LDFLAGS)
	ln -s $(NAME).so.0 $(NAME).so

clean:
	$(RM) $(COBJECTS) $(CXXOBJECTS) $(NAME).so*

$(COBJECTS): %.o: %.c
	$(CC) $< -o $@ $(CFLAGS) $(CPPFLAGS)

$(CXXOBJECTS): %.o: %.cpp
	$(CXX) $< -o $@  $(CXXFLAGS) $(CPPFLAGS)
