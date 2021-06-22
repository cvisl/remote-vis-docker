#!/bin/bash

cd /sw/adf
. ./adfbashrc.sh

vglrun -d ${DISPLAY} adfjobs &

exec mate-session