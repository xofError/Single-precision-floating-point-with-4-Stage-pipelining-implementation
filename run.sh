#!/bin/bash

# Directory containing the Verilog files
VERILOG_DIR="./folder"

# Testbenches to run
TESTBENCHES=(
    "tb_PipelinedFAdd.v PipelinedFAdd.v FloatingAdder.v FloatingAllign.v FloatingCompare.v FloatingNormalizer.v"
)

# Create build directory if it doesn't exist
mkdir -p build

# Loop through each testbench
for tb in "${TESTBENCHES[@]}"; do
    # Extract the testbench name for output file naming
    tb_name=$(echo $tb | awk '{print $1}' | sed 's/.v//')
    
    # Compile the testbench and its dependencies
    iverilog -o build/${tb_name}.out $(echo $tb | sed "s| | $VERILOG_DIR/|g" | sed "s|^|$VERILOG_DIR/|")
    
    # Run the simulation
    vvp build/${tb_name}.out
    
    # Check if waveform file exists and open it in GTKWave
    if [ -f build/waveform.vcd ]; then
        echo "Opening waveform for $tb_name in GTKWave..."
        gtkwave build/waveform.vcd &
    fi
done