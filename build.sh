#!/bin/sh

# VHDL compilation (syntax check and filling "work library")

# GIVEN="UAL.vhd ROMPROG.vhd RAMDoublePort.vhd"
# PRIMITIVES="reg1.vhd reg16.vhd reg16inc.vhd mux_2_16.vhd mux_4_16.vhd mux_8_16.vhd demux_8_1.vhd mux_16_1.vhd add16.vhd"
# COMPLEX="cond_checker.vhd PO.vhd FSM.vhd Processeur.vhd GeneRGB.vhd GeneSync.vhd VGA.vhd"
# TOP="ProcesseurAndCo.vhd"
# 
# ALL="$GIVEN $PRIMITIVES $COMPLEX $TOP"
# 
# vhpcomp -incremental $ALL

PROJECT=ProcesseurAndCo
DEVICE=xc3s1000-4-ft256

XST_CONFIG=$(cat <<EOF
set -tmpdir "./xst/projnav.tmp"
set -xsthdpdir "./xst"
run -ifn ../$PROJECT.prj -ifmt vhdl -ofn $PROJECT -ofmt NGC -p $DEVICE -top $PROJECT -opt_mode Speed -opt_level 1

EOF
)

mkdir -p build/xst/projnav.tmp
cd build

# Synthesis

echo "$XST_CONFIG" | xst &> ./xst/xst.log

grep -i warning ./xst/xst.log
grep -i error ./xst/xst.log

# Implementation

ngdbuild -p $DEVICE -uc $PROJECT.ucf $PROJECT.ngc

map -detail -pr b $PROJECT.ngd

par -w $PROJECT.ncd parout.ncd $PROJECT.pcf

# not quite sure about options at that point...
bitgen -w -g StartUpClk:CClk -g CRC:Enable parout.ncd $PROJECT.bit $PROJECT.pcf

cd ..
