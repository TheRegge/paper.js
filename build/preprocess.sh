#!/bin/sh

# Paper.js
#
# This file is part of Paper.js, a JavaScript Vector Graphics Library,
# based on Scriptographer.org and designed to be largely API compatible.
# http://scriptographer.org/
#
# Copyright (c) 2011, Juerg Lehni & Jonathan Puckey
# http://lehni.org/ & http://jonathanpuckey.com/
#
# Distributed under the MIT license. See LICENSE file for details.
#
# All rights reserved.

# preprocess.sh
#
# A simple code preprocessing wrapper that uses a combination of cpp, jssrip.py
# and sed to preprocess JavaScript files containing C-style preprocess macros
# (#include, #ifdef, etc.). Three options offer control over wether comments
# are preserved or stripped and whitespaces are compressed.
#
# Usage:
# preprocess.sh MODE SOURCE DESTINATION ARGUMENTS
#
# ARGUMENTS:
#	e.g. "-DBROWSER"
#
# MODE:
#	commented		Preprocessed but still formated and commented
#	stripped		Formated but without comments
#	compressed		No comments and no whitespaces
#	uglified		Uses UglifyJS to further reduce file size

KEYWORD="//#"
COMMAND="./filepp.pl -kc $KEYWORD $4 $2"

case $1 in
	stripped)
		eval $COMMAND | ./jsstrip.pl -w -q | sed -n '/^[ 	][ 	]*$/d
			/./,/^$/!d
			p' > $3
		;;
	compressed)
		eval $COMMAND | ./jsstrip.pl -q > $3
		;;
	commented)
		eval $COMMAND | sed -n '/^[ 	][ 	]*$/d
			/./,/^$/!d
			p' > $3
		;;
	uglified)
		eval $COMMAND > temp.js
		../../uglifyjs/bin/uglifyjs temp.js --extra --unsafe --reserved-names "$eval,$sign" > $3
		rm temp.js
		;;
esac
