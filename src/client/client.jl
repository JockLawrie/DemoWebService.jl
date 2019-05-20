module client

using CSV
using DataFrames
using Dates
using HTTP
using JSON  # For posting data to the remote server
using Logging
using YAML  # For reading in the config


"Main client routine."
function main(filename::String, dt::Date)
    @info "Unpacking config"
    config  = YAML.load_file(filename)
    datadir = config["datadir"]
    host    = config["remotehost"]
    port    = config["remoteport"]

    @info "Preparing data"
    data = DataFrame(CSV.File(joinpath(datadir, "input_sp500_monthly.tsv")))
    data = Dict(colname => data[colname] for colname in names(data))  # Can be JSONified

    @info "Posting data to remote server"
    url = "http://$(host):$(port)/rescaledata"
    hdr = ["Content-Type" => "application/json"]
    bdy = JSON.json(Dict("date" => dt, "data" => data))
    res = HTTP.post(url, hdr, bdy)

    @info "Parsing the response"
    data = JSON.parse(String(res.body))

    @info "Constructing result"
    haskey(data, "ERROR") && error("Invalid response received.")
    result = DataFrame(date=Date.(data["date"]), price=data["price"])

    @info "Writing result to disk"
    CSV.write(joinpath(datadir, "output_sp500_monthly.tsv"), result; delim='\t')
    @info "Done"
end


end
