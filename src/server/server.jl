module server

using Dates
using HTTP
using JSON
using Logging
using YAML

# Handlers
include("handlers.jl")

# Routes: route => handler
const routes = Dict{String, Function}()
routes["/status"]      = status
routes["/rescaledata"] = rescaledata


"""
Main handler for the server.

Takes in a HTTP.Request and returns a HTTP.Response.

This is the entry point for all requests, and the exit point for all responses.

Can replace this implementation with any of these implementations:

1. mainhandler = (req) -> haskey(routes, req.target) ? routes[req.target](req) : error_response(req)

2. mainhandler(req) = haskey(routes, req.target) ? routes[req.target](req) : error_response(req)

3. haskey(routes, req.target) && return routes[req.target](req)
   error_response(req)
"""
function mainhandler(req)
    if haskey(routes, req.target)
        return routes[req.target](req)
    else
        return error_response(req)
    end
end


# Run server
function main(filename::String)
    try
        @info "Configuring server"
        config = YAML.load_file(filename)
        host   = config["host"]
        port   = config["port"]

        @info "Starting server"
        HTTP.serve(mainhandler, host, port)
        exit(0)
    catch e
        if isa(e, InterruptException)
            @error "Server killed manually"
        else
            @error "Server failed. Error is:\n$(e)"
        end
        cleanup()
        exit(1)
    end
end


function cleanup()
    println("Do clean up tasks here.")
end


end
