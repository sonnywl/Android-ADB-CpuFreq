CpuFreq-ADB
===========

Android ADB Cpu Controller

  This is a shell script for controlling the cpu frequency on any given Android device from the computer. This script allows configuration of each cpu core's frequency and governor.
  
cpus - get avaiable cpus

online - [01]+ - toggle cpu core

freqs - [0-9]+ - avaiable frequencies for a given cpu

cur - [0-9]+ - current frequency for a given cpu

max - [0-9]+ -current max frequency for a given cpu

min - [0-9]+ -current min frequency for a given cpu

getp - [0-9]+ - get current policy for a given cpu

setf - [0-9]+, [frequency] - set frequency to a given cpu (userland)

setmax - [0-9]+, [frequency] - set max frequency to a given cpu (userland)

setmin - [0-9]+, [frequency] - set min frequency to a given cpu (userland)

setp - [0-9]+, [policy] - set policy to a given cpu"

reset - - sets the core's max and min frequency and back to the ondemand governor
