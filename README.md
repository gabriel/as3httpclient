An HTTP/HTTPS client library for Actionscript 3.

# Building

To build the swc:

	compc -load-config=build-swc.xml

To build and run tests under airake:

	rake
	rake test
	rake adl

For info on airake, which is used to build and test see: [http://airake.rubyforge.org/](http://airake.rubyforge.org/) and [http://github.com/gabriel/airake/tree/master](http://github.com/gabriel/airake/tree/master)

# Info

If anybody from Adobe is reading this: Please add outputProgress event to Socket. (This is the same behavior as outputProgress event in FileStream?) Otherwise it is impossible to determine the ouput progress on socket writes.. see [http://rel.me/2008/1/17/socket-output-progress-in-air](http://rel.me/2008/1/17/socket-output-progress-in-air) for more info.

Everyone else: [Vote for the fix!](https://bugs.adobe.com/jira/browse/FP-6)

In order to use flash.net.Socket in a Flash sandbox environment, you need to have a flash socket policy server. (AIR does not have this restriction.) Look at [http://www.adobe.com/devnet/flashplayer/articles/socket_policy_files.html](http://www.adobe.com/devnet/flashplayer/articles/socket_policy_files.html). To debug in the environment, I would use a standalone flash debug player with logging configured and you will see it attempt to connect to flash socket policy server at port 843. Because of this restriction, this library might be more suited for AIR apps.
HTTPS doesn't always work. There are some minor bugs with the as3crypto library, so for example https at yahoo and yahoo owned domains (like delicious) don't currently work.

# Goals

The goals for this project are:

- Learn the HTTP protocol by trying to implement a client.
- Use AS3Crypto TLSSocket support for implementing HTTPS.
- Use it as a replacement for Flash's URLRequest/URLStream API.
- Support the Flash and AIR runtimes.

Working:

- GET, HEAD, PUT, POST, DELETE
- multipart/form-data (PUT and POST)
- HTTPS support using AS3Crypto TLS
- Post with application/x-www-form-urlencoded
- Reading chunked (Transfer-Encoding)

Next to implement:

- The other http verbs
- Connection keep-alive
- gzip compression
- ...

For examples see, [EXAMPLES](http://github.com/gabriel/as3httpclient/blob/master/EXAMPLES.md)
