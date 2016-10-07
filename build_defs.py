#!/usr/bin/python3

import os
import platform
import sys
from subprocess import call
import subprocess

# Paths to build tools, depending on OS

if platform.system() == "Windows":
	asBinary = "AS/Win32/asw.exe";
	s1p2binBinary = "AS/Win32/s1p2bin.exe";
	s1p2binplusBinary = "AS/Win32/s1p2bin_plus.exe";

elif platform.system() == "Darwin": # Osx
	asBinary = "AS/Osx/asl";
	s1p2binBinary = "AS/Osx/s1p2bin";
	s1p2binplusBinary = "AS/Osx/s1p2bin_plus";

elif platform.system() == "Linux":
	if sys.maxsize > 2**32:	# detect if running in 64-bit environment
		asBinary = "AS/Linux/asl"
		s1p2binBinary = "AS/Linux/s1p2bin"
		s1p2binplusBinary = "AS/Linux/s1p2bin_plus";
	else:
		asBinary = "AS/Linux32/asl"
		s1p2binBinary = "AS/Linux32/s1p2bin"
		s1p2binplusBinary = "AS/Linux32/s1p2bin_plus";

else:
	print("Unknown platform")

def delete(path):
	if os.path.isfile(path):
		os.remove(path);

def move(path1, path2):
	if os.path.isfile(path1):
		os.rename(path1, path2);

def update_checksum(path):
	with open(path, "r+b") as file:
		# Read the whole file in memory
		bytes = file.read();

		# Calculate the checksum
		checksum = 0;
		for i in range(0x200, len(bytes), 2):
			checksum += (bytes[i + 0] << 8) + (bytes[i + 1] << 0);
			checksum &= 0xFFFF;

		# Write the checksum to the header
		file.seek(0x18E);
		file.write(bytearray([(checksum >> 8) & 0xFF, (checksum >> 0) & 0xFF]));

def run(altcomp):
	if platform.system() == "Windows":
		os.environ["AS_MSGPATH"] = "AS/Win32";
		os.environ["USEANSI"] = "n";

	# Build ROM
	print("Building s1built");

	# Create full paths for all files
	romPath = "s1built.bin";	
	romPathPrev = "s1built.prev.bin";
	errorsPath = "sonic.log";
	outputPath = "_Output.txt";
	binaryOutputPath = "_BinaryOutput.txt";

	print("  Cleaning previous build");
	# Remove old output
	delete(romPathPrev);
	move(romPath, romPathPrev);
	delete(errorsPath);
	delete(outputPath);
	delete(binaryOutputPath);
	delete("sonic.p");

	assembleCommand = [asBinary, "-xx", "-n", "-q", "-A", "-L"];

	# Input asm file
	assembleCommand.append("sonic.asm");

	print("  Assembling .p file");

	assembleProcess = subprocess.Popen(assembleCommand, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	output, errors = assembleProcess.communicate()
	errorsFile = open(errorsPath, "wb")
	errorsFile.write(errors)
	errorsFile.close()
	outputFile = open(outputPath, "wb")
	outputFile.write(output)
	outputFile.close()

	# Detect if there was an error
	if os.path.isfile("sonic.p") == False:
		print("There was a fatal error during assembly: see sonic.log for details");
		exit();

	# Create binary

	if altcomp:
		binaryCommand = [s1p2binplusBinary, "sonic.p", romPath];
	else:
		binaryCommand = [s1p2binBinary, "sonic.p", romPath];

	# Output file

	print("  Converting .p to .bin");

	binaryProcess = subprocess.Popen(binaryCommand, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	output, errors = binaryProcess.communicate()
	outputFile = open(binaryOutputPath, "wb")
	outputFile.write(output)
	outputFile.close()

	# Fixing checksum

	print("  Calculating checksum");
	update_checksum(romPath);

	print("  Removing temporary files");

	# delete working files
	delete("sonic.p");

	print("Finished!");
