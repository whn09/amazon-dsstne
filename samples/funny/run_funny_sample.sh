#!/bin/bash
#
# Downloads the MovieLens dataset and trains a small model for 10 epochs before
# writing predictions to a file called 'recs'.
#

# Convert train_ph.txt to format supported by generateNetCDF
echo "Converting train_ph.txt to DSSTNE format"
awk -f convert_ratings.awk train_ph.txt > train_ph
awk -f convert_ratings.awk test_ph.txt > test_ph

# Generate NetCDF files for input and output layers
generateNetCDF -d gl_input  -i train_ph -o gl_input.nc  -f features_input  -s samples_input -c
generateNetCDF -d gl_output -i train_ph -o gl_output.nc -f features_output -s samples_input -c

# Train the network
train -c config.json -i gl_input.nc -o gl_output.nc -n gl.nc -b 256 -e 10

# Generate predictions
predict -b 256 -d gl -i features_input -o features_output -k 10 -n gl.nc -f train_ph -s recs -r train_ph
