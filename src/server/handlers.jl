status(req::HTTP.Request) = HTTP.Response(200, "ok")

error_response(req::HTTP.Request) = HTTP.Response(404, "ERROR")


function rescaledata(req::HTTP.Request)
    @info "Unpacking request body"
    jsondata = String(req.body)
    data     = JSON.parse(jsondata)
    dt       = Date(data["date"])
    data     = data["data"]
    date     = Date.(data["date"])
    price    = Float64.(data["price"])

    @info "Computing result"
    idx = findfirst(isequal(dt), date)
    idx == nothing && return error_response(req)
    refprice = price[idx] / 100.0  # Scale to 100 at dt
    price  ./= refprice
    price    = round.(price; digits=2)
    result   = Dict("date" => date, "price" => price)

    @info "Returning result"
    HTTP.Response(200, JSON.json(result))
end
