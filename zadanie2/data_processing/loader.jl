
function load_data(filepath::AbstractString)

    df = CSV.read(filepath, DataFrame)

    return df
end