#!/bin/bash

# author: danil.rempel <danil.rempel@gmail.com>

VERSION="0.5"
# version 0.5
# 0.2: added uppercasing in "ifndef HAVE_CLASSNAME_HPP" statement
# 0.3: added --relative. it isn't enough useful, but i hope, someone will like it:)
#		note: it isn't sensitive to arguments order
#		but any non-"--relative" text it will treat as class name
# 0.4: checks if class definition or implementation files exist and dies if any
# 0.5: added ';' after class definiton ^_^'', (changed CPP to HPP in include lock)

SRCDIR=src
INCDIR=include

function allok () {
	if [ $1 == "--relative" ];
		then rel="t"
			arg=$2;
		else rel="f"
			arg=$1;
	fi;
	if [ ! -z $2 ];
	then
		if [ $2 == "--relative" ];
		then rel="t";
		fi;
	#else rel="f";
	fi;
	if [ -z $arg ];
	then
		echo "Usage: $0 [--relative] <classname>"
		exit 1;
	fi;
	#echo "Arg: $arg";
	
	if [ -e "$SRCDIR/$1.cpp" ];
	then echo "$0: $SRCDIR/$1.cpp exists"
		exit 1;
	fi;
	if [ -e "$INCDIR/$1.hpp" ];
	then echo "$0: $INCDIR/$1.hpp exists"
		exit 1;
	fi;
	
	touch $SRCDIR/$1.cpp;
	
	if [ "t" == $rel ];
	then echo -e "#include \"../$INCDIR/$1.hpp\"" >> $SRCDIR/$1.cpp;
	else echo -e "#include <$1.hpp>" >> $SRCDIR/$1.cpp;
	fi;
	
	touch $INCDIR/$1.hpp;
	toClass=`echo $1 | awk '{print toupper($0)}' `;
	echo -e "#ifndef HAVE_${toClass}_HPP" >> $INCDIR/$1.hpp;
	echo -e "#define HAVE_${toClass}_HPP" >> $INCDIR/$1.hpp;
	echo -e "" >> $INCDIR/$1.hpp;   
	echo -e "class $1 {" >> $INCDIR/$1.hpp;
	echo -e "" >> $INCDIR/$1.hpp;
	echo -e "};" >> $INCDIR/$1.hpp;
	echo -e "" >> $INCDIR/$1.hpp;
	echo -e "#endif" >> $INCDIR/$1.hpp;
	
}

if [ -z $1 ];
then 
	echo "Usage: $0 [--relative] <classname> | $0 --help"
else
	if [ $1 == "--help" ];
		then echo "Class creation tool v${VERSION}"
			echo "Creates C++ classes with base headers in configured directories (src/, include/)"
			echo "Usage: $0 [--relative] <classname>"
			echo -e "\t --relative: when passed classes are created with"
			echo -e "\trelative includes (include \"file.hpp\"), else"
			echo -e "\tfiles are created with global includes (include <file.hpp>)"
			exit 0;
	fi;
	allok $@;
fi;
