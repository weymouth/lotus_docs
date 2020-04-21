#!/usr/bin/env python3
# ----------------------------------------- #
# itscript.py
# ----------------------------------------- #
#
import os
import sys

fileSource = open("lotus.f90","r")
fileText = fileSource.read()
fileSource.close()
fileLines = fileText.split("\n")
fileLines[14] = "    real,parameter     :: c = {0}".format(float(sys.argv[1])*64)
fileText = "\n".join(fileLines)
fileOutput = open("lotus.f90","w")
fileOutput.write(fileText)
