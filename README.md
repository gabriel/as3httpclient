# AS3 Http Client Library

An http library written on top of flash.net.Socket (and as3crypto) to be used with AIR or flash runtimes.

For more info see: [http://code.google.com/p/as3httpclientlib/](http://code.google.com/p/as3httpclientlib/)

For info on airake, which is used to build and test see: [http://airake.rubyforge.org/](http://airake.rubyforge.org/) and [http://github.com/gabriel/gh-unit/tree/master](http://github.com/gabriel/gh-unit/tree/master)

## Building

To build the swc:

	compc -load-config=build-swc.xml
	
To build and run tests under airake:

	rake
	rake test
	rake adl
