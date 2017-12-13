#!/bin/bash

# Utility script to pre-process and compile topology sources into topology test
# binaries. Currently supports simple PCM <-> component <-> SSP style tests
# using simple_test()

# fail immediately on any errors
set -e

# M4 preprocessor flags
M4_FLAGS="-I ../ -I ../m4"

# process m4 simple tests - 
# simple_test(name prefix, name suffix, pipe_name, be_name, format,
#             dai_id, dai_format, dai_phy_bits, dai_data_bits dai_bclk)
# 1) test filename prefix
# 2) test file name suffix
# 3) pipe_name - test component pipeline filename in sof/
# 4) be_name - BE DAI link name in machine driver, used for matching
# 5) format - PCM sample format
# 6) dai_id - SSP port number
# 7) dai_format - SSP sample format
# 8) dai_phy_bits - SSP physical number of BLKCs per slot/channel
# 9) dai_data_bits - SSP number of valid daat bits per slot/channel
# 10) dai_bclk - SSP BCLK in HZ
#

function simple_test {
		TFILE="$1$6-$3-$5-$7-48k-$2"
		echo "M4 pre-processing test $2 -> ${TFILE}"
		m4 ${M4_FLAGS} \
			-DTEST_PIPE_NAME="$3" \
			-DTEST_DAI_LINK_NAME="$4" \
			-DTEST_SSP_PORT=$6 \
			-DTEST_SSP_FORMAT=$7 \
			-DTEST_PIPE_FORMAT=$5 \
			-DTEST_SSP_BCLK=$10 \
			-DTEST_SSP_PHY_BITS=$8 \
			-DTEST_SSP_DATA_BITS=$9 \
			$1.m4 > ${TFILE}.conf
		echo "Compiling test $1 -> ${TFILE}.tplg"
		alsatplg -v 1 -c ${TFILE}.conf -o ${TFILE}.tplg
}

# Pre-process the simple tests
# no codec
simple_test test-ssp nocodec passthrough "NoCodec" s16le 2 s16le 20 16 1920000
simple_test test-ssp nocodec passthrough "NoCodec" s24le 2 s24le 25 24 2400000

simple_test test-ssp nocodec src "NoCodec" s16le 2 s16le 20 16 1920000
simple_test test-ssp nocodec src "NoCodec" s24le 2 s24le 25 24 2400000

simple_test test-ssp nocodec volume "NoCodec" s16le 2 s16le 20 16 1920000
simple_test test-ssp nocodec volume "NoCodec" s24le 2 s24le 25 24 2400000
simple_test test-ssp nocodec volume "NoCodec" s16le 2 s24le 25 24 2400000
simple_test test-ssp nocodec volume "NoCodec" s24le 2 s16le 20 16 1920000

# codec
simple_test test-ssp codec passthrough "SSP2-Codec" s16le 2 s16le 20 16 1920000
simple_test test-ssp codec passthrough "SSP2-Codec" s24le 2 s24le 25 24 2400000

simple_test test-ssp codec src "SSP2-Codec" s16le 2 s16le 20 16 1920000
simple_test test-ssp codec src "SSP2-Codec" s24le 2 s24le 25 24 2400000

simple_test test-ssp codec volume "SSP2-Codec" s16le 2 s16le 20 16 1920000
simple_test test-ssp codec volume "SSP2-Codec" s24le 2 s24le 25 24 2400000
simple_test test-ssp codec volume "SSP2-Codec" s16le 2 s24le 25 24 2400000
simple_test test-ssp codec volume "SSP2-Codec" s24le 2 s16le 20 16 1920000

# Baytrail Audio
simple_test test-ssp baytrail passthrough "Baytrail Audio" s16le 2 s16le 20 16 1920000
simple_test test-ssp baytrail passthrough "Baytrail Audio" s24le 2 s24le 25 24 2400000

simple_test test-ssp baytrail src "Baytrail Audio" s16le 2 s16le 20 16 1920000
simple_test test-ssp baytrail src "Baytrail Audio" s24le 2 s24le 25 24 2400000

simple_test test-ssp baytrail volume "Baytrail Audio" s16le 2 s16le 20 16 1920000
simple_test test-ssp baytrail volume "Baytrail Audio" s24le 2 s24le 25 24 2400000
simple_test test-ssp baytrail volume "Baytrail Audio" s16le 2 s24le 25 24 2400000
simple_test test-ssp baytrail volume "Baytrail Audio" s24le 2 s16le 20 16 1920000
