function load_file(filepath::AbstractString) 

    df = CSV.read(filepath, DataFrame)
    return df
end

function load_dict_from_csv(filepath::AbstractString)
    
    df = CSV.read(filepath, DataFrame)
    
    dictionary = Dict(
    row[1] => row[2]
    for row in eachrow(df)
    )
    
    return dictionary
end