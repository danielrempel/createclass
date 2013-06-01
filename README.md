..I'm working from Geany, so I needed a little tool to create classes with all this boring text that I need to write every time.

And here it is. It is as simple, as it could be:
$ createClass <classname>
..and it creates cpp & hpp files in corresponding directories.

Directories are defined on top of script with SRCDIR and INCDIR variables.

Also it recognizes --relative flag that is defining that the tool should create class source files with relative includes, not with global (include <filename.hpp>).

