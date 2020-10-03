# - Config file for the simple_ics_uvm package
# It defines the following variables
#  simple_ics_uvm_INCLUDE_DIRS      - include directories for simple_ics_uvm package
#  simple_ics_uvm_SRC_FILES         - source files for implementation.
#  simple_ics_uvm_SIM_FILES         - simulation files. Compile required.
#  simple_ics_uvm_DEFINITIONS_VLOG  - additional compile option for vlog.
#  simple_ics_uvm_DEPENDENCIES      - simple_ics_uvm components list. use for target depends.

# Compute paths
find_package(simple_uart_uvm REQUIRED)
if(CMAKE_VERSION VERSION_GREATER 3.10)
    if (NOT ${PACKAGE_NAME}_FOUND)
        require(simple_uart_uvm)
    endif()
endif()
set(simple_ics_uvm_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/include")
set(simple_ics_uvm_SRC_FILES "") #empty. this package is for simulation only.
file(GLOB simple_ics_uvm_SIM_FILES ${CMAKE_CURRENT_LIST_DIR}/src/*.sv)
set(simple_ics_uvm_DEFINITIONS_VLOG "-i ${simple_ics_uvm_INCLUDE_DIRS}")
file(GLOB simple_ics_uvm_DEPENDENCIES   ${CMAKE_CURRENT_LIST_DIR}/include/*.svh
                                        ${CMAKE_CURRENT_LIST_DIR}/src/*.sv)

#message("simple_ics_uvm_INCLUDE_DIRS:${simple_ics_uvm_INCLUDE_DIRS}")
#message("simple_ics_uvm_TESTBENCH_FILES:${simple_ics_uvm_TESTBENCH_FILES}")

