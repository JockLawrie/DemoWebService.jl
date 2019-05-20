# DemoWebService.jl


## Once-off set up

This code downloads and builds all dependencies.

```
$ git clone https://github.com/JockLawrie/DemoWebService.jl.git
$ cd DemoWebService.jl
$ julia
julia> ]
(v1.1) pkg > activate .
(v1.1) pkg > instantiate
```


## Run the server

Run this from the package directory containing this package:

```julia
using Pkg
Pkg.activate(".")
using DemoWebService: server
server.main("data/serverconfig.yaml")
```


## Run the client

In a separate terminal, run this from the package directory containing this package:

```julia
using Pkg
Pkg.activate(".")
using DemoWebService: client
using Dates
client.main("data/clientconfig.yaml")
```
