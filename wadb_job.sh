#!/bin/sh

# SPDX-FileCopyrightText: NONE
#
# SPDX-License-Identifier: Unlicense

PREFIX=/data/data/com.termux/files/usr
termux-job-scheduler --period-ms 900000 --job-id 34221 -s $PREFIX/libexec/wadb.sh

