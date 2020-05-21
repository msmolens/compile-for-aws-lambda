add_library(libsine STATIC libsine.cpp ../include/libsine/libsine.h)

target_include_directories(libsine PUBLIC ../include)

target_compile_features(libsine PUBLIC cxx_std_11)

target_link_libraries(libsine PRIVATE SndFile::sndfile)
