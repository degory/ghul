# Visual Studio Code language extension server

The ANALYSER class is the entry point for requests from the Visual Studio Code language extension. The other classes in this folder provide support for parsing and servicing requests. The extension uses a very simple plain text protocol to communicate with the compiler, because early versions of the compiler were not capable of handling JSON.