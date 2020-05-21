cmake_minimum_required(VERSION 3.8)

project(sine LANGUAGES CXX)

find_package(SndFile REQUIRED)

add_subdirectory(src)
add_subdirectory(app)
