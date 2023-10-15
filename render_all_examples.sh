#!/bin/bash

mkdir -p stl
for ((i=0; i<23; i++))
do
	openscad -o stl/H0bench_$i.stl -D example_index=$i H0Bench.scad
done
