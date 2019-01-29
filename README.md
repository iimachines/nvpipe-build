# How to build 

- Install the [NVidia CUDA SDK](https://developer.nvidia.com/cuda-downloads)

- Clone [NVidia NvPipe](https://github.com/NVIDIA/NvPipe)

- webrtc requires static linking, so we must patch `NvPipe`

    - Change the cloned `CMakeLists.txt` to include:

        ```cmake
        foreach(flag_var
                CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
           if(${flag_var} MATCHES "/MD")
              string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
           endif(${flag_var} MATCHES "/MD")

        endforeach(flag_var)

        add_compile_definitions(_HAS_ITERATOR_DEBUGGING=0)
        add_compile_definitions(_ITERATOR_DEBUG_LEVEL=0)
        ```

    - make the `cuda_add_library` static:
        ```cmake
        cuda_add_library(${PROJECT_NAME} STATIC ${NVPIPE_SOURCES})
        ```

- Also see the example `CMakeLists.txt` in this repo.

- Then build and install the cmake project as usual, and copy the include and libs

- You might want to update the static CUDA libraries too





