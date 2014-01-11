Neo4j 2.0.0
=======================================

Welcome to Neo4j release 2.0.0, a high-performance graph database.
This is the community distribution of Neo4j, including everything you need to
start building applications that can model, persist and explore graph-like data.

In the box
----------

Neo4j runs as a server application, exposing a Web-based management
interface and RESTful endpoints for data access.

Here in the installation directory, you'll find:

* bin - scripts and other executables
* conf - server configuration
* data - database, log, and other variable files
* doc - more light reading
* lib - core libraries
* plugins - user extensions
* system - super-secret server stuff

Make it go
----------

For full instructions, see http://docs.neo4j.org/chunked/2.0.0/deployment.html

To get started with Neo4j, let's start the server and take a
look at the web interface ...

1. Open a console and navigate to the install directory.
2. Start the server:
   * Windows: use bin\Neo4j.bat
   * Linux/Mac: use ./bin/neo4j console
3. In a browser, open http://localhost:7474/
4. From any REST client or browser, open http://localhost:7474/db/data
   in order to get a REST starting point, e.g.
   curl -v http://localhost:7474/db/data
5. Shutdown the server by typing Ctrl-C in the console.

Learn more
----------

There is a manual available in the `doc` directory, which includes tutorials
and reference material.

Out on the internets, you'll find:

* Neo4j Home: http://www.neo4j.org/
* Getting Started: http://docs.neo4j.org/chunked/2.0.0/introduction.html
* The Neo4j Manual (online): http://docs.neo4j.org/chunked/2.0.0/

License(s)
----------
Various licenses apply. Please refer to the LICENSE and NOTICE files for more
detailed information.

