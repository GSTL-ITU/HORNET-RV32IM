#!/bin/bash

# Configuration
LOG_FILE="simulation.log"
CC32=/opt/riscv/bin/riscv64-unknown-elf
USE_RISCVDV=1
TEST="riscv_muldiv_arithmetic_test"

PROJECT_ROOT=".."
VIVADO_DIR="${PROJECT_ROOT}/Vivado/src"
TB_FILE="${VIVADO_DIR}/sim_src/barebones_top_tb.v"
ROM_GENERATOR="${PROJECT_ROOT}/../../rom_generator"

verilator --Wno-fatal   --binary --sv --timing /home/deniz/Hornet-RV32IM/deneme/HORNET-RV32IM/Vivado/src/sim_src/barebones_top_axi4l_tb.v -I/home/deniz/Hornet-RV32IM/deneme/HORNET-RV32IM/Vivado/src   --top-module barebones_top_axi4l_tb


if [ "$USE_RISCVDV" -eq 1 ]; then
    python3.11 run.py --verbose --test "${TEST}" --simulator pyflow --isa rv32im --mabi ilp32 --sim_opts="" # --seed=2079547102

    if [ -d "out_$(date +%Y-%m-%d)" ]; then
        cd "out_$(date +%Y-%m-%d)" || exit 1
    else
        echo "Directory not found"
        exit 1
    fi

    "${CC32}-objcopy" -O binary -j .init -j .text -j .rodata -j .sdata "asm_test/${TEST}_0.o" final.bin
    "${ROM_GENERATOR}" final.bin
    cp final.data ../instruction.data

# else
#    if [ -d "../${TEST}" ]; then
#        CCFLAGS="-march=rv32im -ffp-contract=off -mabi=ilp32 -Os -fno-math-errno -T ../linksc-10000.ld -lm -nostartfiles -ffunction-sections -fdata-sections -Wl,--gc-sections -g -ggdb -o ${TEST}.elf"
#        cd "../${TEST}"
#        "${CC32}-gcc" "${TEST}.c" ../crt0.s ${CCFLAGS} # Might need to change the test extension to .c if the test is written in C
#        "${CC32}-objcopy" -O binary -j .init -j .text -j .rodata -j .sdata "${TEST}.elf" "${TEST}.bin"
#        ../rom_generator "${TEST}.bin"
#        cp "${TEST}.data" ../memory_contents/instruction.data
#        echo "Test compiled, running spike"
#        "${SPIKE_PATH}/spike" --log-commits --isa=rv32imf --priv=M -m0xf000:1,0x10000:0x8000,0x8010:1 -l --log=spike.log "${TEST}.elf"
#        echo "Spike simulation completed"
#        VIVADO_DURATION="400ms"
#    else
#        echo "Directory not found"
#        exit 1
#    fi
fi

cd .. || exit 1
./obj_dir/Vbarebones_top_axi4l_tb 

# Check exit status
if [ $? -eq 0 ]; then
    echo "Simulation completed successfully" | tee -a "${LOG_FILE}"
else
    echo "Simulation failed" | tee -a "${LOG_FILE}"
    exit 1
fi

echo "Simulation log saved to ${LOG_FILE}"

if [ "$USE_RISCVDV" -eq 1 ]; then
    python3 scripts/spike_log_to_trace_csv.py --log "out_$(date +%Y-%m-%d)/spike_sim/${TEST}_0.log" --csv spike_out.csv -f
    python3 scripts/trace_to_csv.py -l trace.log -o trace_out.csv
    python3 scripts/compare.py trace_out.csv spike_out.csv comparison_out.csv

    # Add a counter to limit repetitions
    MAX_ITER=1
    COUNTER_FILE=".run_counter"

    if [ ! -f "$COUNTER_FILE" ]; then
        echo 1 > "$COUNTER_FILE"
    fi

    COUNTER=$(cat "$COUNTER_FILE")

    if python3 scripts/compare.py trace_out.csv spike_out.csv comparison_out.csv > /dev/null 2>&1; then
        if [ $? -ne 1 ]; then
            if [ "$COUNTER" -lt "$MAX_ITER" ]; then
                COUNTER=$((COUNTER + 1))
                echo "$COUNTER" > "$COUNTER_FILE"
                echo -e "\033[1;32mRepeating the script as last test had no failures (iteration $COUNTER/$MAX_ITER)\033[0m"
                exec "$0"
            else
                echo "Maximum iterations ($MAX_ITER) reached. Stopping."
                rm -f "$COUNTER_FILE"
            fi
        else
            echo 1 > "$COUNTER_FILE"
        fi
    else
        echo 1 > "$COUNTER_FILE"
    fi
else
    cd "../riscv-dv" || exit 1
    python3 scripts/spike_log_to_trace_csv.py --log "../${TEST}/spike.log" --csv spike_out.csv -f
    python3 scripts/trace_to_csv.py -l ../trace.log -o tracer_out.csv
    python3 scripts/compare.py tracer_out.csv spike_out.csv comparison_out.csv
fi