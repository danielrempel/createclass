#!/bin/bash

# author: danil.rempel <danil.rempel@gmail.com>

VERSION="0.9"
# 0.2: added uppercasing in "ifndef HAVE_CLASSNAME_HPP" statement
# 0.3: added --relative. it isn't enough useful, but i hope, someone will like it:)
#		note: it isn't sensitive to arguments order
#		but any non-"--relative" text it will treat as class name
# 0.4: checks if class definition or implementation files exist and dies if any
# 0.5: added ';' after class definiton ^_^'', (changed CPP to HPP in include lock)
# 0.6: added "class CLASSNAME;" statement after include lock. I use it
#		to prevent recursive includes when classes are not found
#		added "public:" and "private:" lines to class definition body
# 0.7: return to ordinary way: only one src dir, all sources have relative (within one directory paths)
# 0.8: rewritten, simplified
# 0.9: add a key to create a singleton class

function create () {
	
	HEADER_FILE=$3.hpp
	HEADER=$2/${HEADER_FILE}
	SOURCE=$2/$3.cpp
	CLASS=$3
	UCLASS=`echo $3 | awk '{print toupper($0)}'`
	if [ -e "${HEADER}" -o -e "${SOURCE}" ];
	then
		echo "File(s) already exist: ${HEADER}, ${SOURCE}"
		exit 1;
	fi
	
	touch ${HEADER}
	
	cat >> $HEADER <<EOF
#ifndef __HAVE_${UCLASS}_HPP__
#define __HAVE_${UCLASS}_HPP__
class ${CLASS};

class ${CLASS}
{
EOF

	if [ "$1" == "1" ];
	then
		cat >> $HEADER <<EOF
	public: // Singleton stuff
		static ${CLASS}& getInstance();
		${CLASS}(${CLASS} const&)			= delete;
		void operator=(${CLASS} const&)		= delete;
EOF
	fi
	
	cat >> $HEADER <<EOF

	public:
		${CLASS}();
		virtual ~${CLASS}();
	protected:
	private:
};

#endif // __HAVE_${UCLASS}_HPP__
EOF
	
	touch ${SOURCE}
	
	cat >> $SOURCE <<EOF
#include "${HEADER_FILE}"
EOF

	if [ "$1" == "1" ];
	then
		cat >> $SOURCE <<EOF

${CLASS}& ${CLASS}::getInstance()
{
	// according to loki-astari@stackoverflow,
	// this way the singleton is guaranteed to
	// be destroyed
	static ${CLASS} instance;
	return instance;
}
EOF
	fi

	cat >> $SOURCE <<EOF

${CLASS}::${CLASS}()
{
	
}

${CLASS}::~${CLASS}()
{
	
}
EOF
	
}

function parse () {
	if [ "$1" == "--help" ];
	then
		# show help text
		echo "Class creation tool v${VERSION}"
		echo "Creates C++ classes with base headers in given directory"
		echo "Usage: $0 <dir> <classname> | $0 <classname>"
		exit 0;
	fi
	if [ "$1" == "-s" ]
	then
		# create a singleton class
		SINGLETON=1
		if [ -z "$3" ];
		then
			# createclass <classname>
			DIR=.
			CLASS=$2
		else
			# createclass <dir> <classname>
			DIR=$2
			CLASS=$3
		fi
	else
		SINGLETON=0
		if [ -z "$2" ];
		then
			# createclass <classname>
			DIR=.
			CLASS=$1
		else
			# createclass <dir> <classname>
			DIR=$1
			CLASS=$2
		fi
	fi
	
	create $SINGLETON $DIR $CLASS
}

if [ -z $1 ];
then 
	echo "Usage: $0 [-s] [<dir>] <classname> | $0 --help"
else
	parse $@
fi
