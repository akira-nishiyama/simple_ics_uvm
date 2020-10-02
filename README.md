# simple_ics_uvm
Simple ics verification ip. Main target is vivado simulator.
This package contains simple_ics and simple_ics_slave class.

# Dependency
Vivado 2019.2  
CMake 3.1 or later  
Ninja(Make also works)  
vivado_cmake_helper
simple_uart_uvm(https://github.com/akira-nishiyama/simple_urat_uvm.git)

# Setup
- get source
```bash
git clone https://github.com/akira-nishiyama/simple_ics_uvm
```
- find simple_uart_uvm package.
vivado_cmake_helper implements require statement.
If you use Cmake > 3.11, the following statement fetch the necessary repository.
```
require(simple_uart_uvm
        GIT_REPOSITORY https://github.com/akira-nishiyama/simple_urat_uvm.git
       )
```
For CMake < 3.11, use the git command to get the repository.
Then Cmake with -Dsimple_uart_uvm_DIR=<path to the repository>, you will get the same results as above "require".
```
git clone https://github.com/akira-nishiyama/simple_urat_uvm.git <path-to-repository>
```

# Usage
## simple_ics
Instance the simple_ics_env and provide simple_ics_uart_seq_item
through sequence.
setup is below.

find_package(simple_ics_uvm) would be setup compilation.
Add simple_ics_uvm_SIM_FILES to project.
Then add include path to the vlog option.
The option is provided with simple_ics_uvm_DEFINITION_VLOG.
see CMakeLists.txt.

Create instance of the simple_ics_env in you test and environment.
Connect simple_uart_if in uvm_config_db as vif.
Configs for uart is same as [simple_uart_uvm](https://github.com/akira-nishiyama/simple_urat_uvm.git).

simple_ics_env has agent(simple_uart_agent), monitor, sequencer.

The agent is actual bus drive and monitor.
The agent is an instance of simple_uart_agent which is component of simple_uart_uvm package.

The monitor has analysis_port named item_port that through all detected simple_ics_seq_item.
The monitor convert simple_uart_seq_item to simple_ics_seq_item.

The sequencer accepts simple_ics_seq_item for stimulus.
The sequencer transfer the simple_ics_seq_item to agent.sequencer.
agent.sequencer runs ics_item_to_uart_item_seq to converts simple_ics_seq_item into simple_uart_seq_item.

## simple_ics_slave
Instance the simple_ics_slave_env and connect vif with dut.
setup is below.

find_package(simple_ics_uvm), add simple_ics_uvm_SIM_FILES and
compile with simple_ics_uvm_DEFINITION_VLOG is same as simple_ics.

Create instance of the simple_ics_slave_env in you test and environment.
Connect simple_uart_if in uvm_config_db.
Configs for uart is same as [simple_uart_uvm](https://github.com/akira-nishiyama/simple_urat_uvm.git).

simple_ics_slave_env has ics_env(simple_ics_env), react_req_fifo, storage and sequencer.

The ics_env is actual bus driver.
The ics_env is instance of simple_ics_env described in above.

react_req_fifo is connected to ics_env.monitor.react_req_port
to get reaction required sequence item(react_req_port is transfer only CMD item).

The storage contains 32 slave data.
Each data is consists of 64byte eeprom_data and 5 registers.

# Restritionm
ics ID command is not supported.
The reason is that Difficult to reognize ID or ID responce.
In addition, it is not used in normal operation.

# Example Setup
- Install Vivado.

- Install CMake and Ninja
```bash
apt install cmake ninja-build
```

- Clone vivado_cmake_helper. The path can be anywhere.
```bash
git clone https://github.com/akira-nishiyama/vivado_cmake_helper ~
```

- Clone simple_uart_uvm.
```bash
git clone https://github.com/akira-nishiyama/simple_urat_uvm.git <path-to-uart-repository>
```

- Clone gp_scoreboard.
```bash
gic clone https://github.com/akira-nishiyama/uvm_component.git <path-to-scrbd-repository>
```

# Example build
```bash
source <vivado_installation_path>/settings64.sh
source ~/vivado_cmake_helper/setup.sh
mkdir build
cd build
cmake .. -GNinja -Dsimple_uart_uvm_DIR=<path-to-uart-repository> -Duvm_component_DIR=<path-to-scrbd-repository>
ninja elaborate_all
ctest
```

# License
This software is released under the MIT License, see LICENSE.
