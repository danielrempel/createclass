..I'm working from Geany, so I needed a little tool to create classes with all this boring text that I need to write every time.  
  
And here it is. It is as simple, as it could be:  
$ createClass \<classname\>  
..and it creates cpp & hpp files in current directory.  

The script may receive up to three parameters:
>>[-s] [<dir>] <classname>
Where:
 * -s -- create a singleton class
 * <dir> -- directory to put sources and headers into
 * <classname> -- the name of the class to be created
