function load_file(filepath::AbstractString) 

    df = CSV.read(filepath, DataFrame)
    return df
end