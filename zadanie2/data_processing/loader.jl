function load_file(path)
    df = CSV.read(path, DataFrame)
    return df
end