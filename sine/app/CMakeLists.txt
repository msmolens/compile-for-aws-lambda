add_executable(sine sine.cpp)

target_link_libraries(sine PRIVATE libsine)

install(TARGETS sine
        RUNTIME DESTINATION bin)
