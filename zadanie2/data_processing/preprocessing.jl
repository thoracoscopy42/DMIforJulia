
function remove_cols!(df::DataFrame, cols::Vector{Symbol})
    select!(df, Not(cols))
    
    return df
end

function remove_cols!(df::DataFrame, cols::Symbol)
    select!(df, Not(cols))
    
    return df
end

function map_column!(df::DataFrame, source_col::Symbol, new_col::Symbol, dict::Dict)

    df[!, new_col] = get.(Ref(dict), df[!, source_col], missing)

    remove_cols!(df, source_col)

    return df
end

function ordinal_encode_ordered!(df::DataFrame, col::Symbol, levels::Vector{String})

    df[!, col] = categorical(df[!, col]; levels = levels, ordered = true)

    return df
end

function ordinal_encode_unordered!(df::DataFrame, col::Symbol, levels::Vector{String})

    df[!, col] = categorical(df[!, col]; levels = levels, ordered = false)

    return df
end

function divide_dataset(df::DataFrame, target::Symbol)

    y = df[!, target]

    X = select!(df, Not(target))

    return X, y
end