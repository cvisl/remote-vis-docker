#!/bin/bash

cd /sw/adf
. ./adfbashrc.sh

adfjobs &

exec mate-session