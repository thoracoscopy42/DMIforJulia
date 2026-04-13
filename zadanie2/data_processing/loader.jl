function load_file(path::AbstractString)
    df = CSV.read(path, DataFrame)
    return df
end

function load_dict_from_csv(path::AbstractString)

    df = CSV.read(path, DataFrame)

    dictionary = Dict(

    row[1] => row[2]
    for row in eachrow(df)

    )

    return dictionary
end

    