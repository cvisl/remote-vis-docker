#!/bin/bash

cd /sw/adf
. ./adfbashrc.sh

vglrun -d :1 adfjobs &

exec mate-session