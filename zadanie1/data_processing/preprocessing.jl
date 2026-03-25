
#SECTION - Main function 

function prepare_for_modeling!(df::DataFrame, config::Dict)

    divided_columns = split_columns_by_type(df)


end

#TODO - below

# !column helpers

function split_columns_by_type(df::DataFrame)

    numeric_cols     = get_numeric_columns(df)
    categorical_cols = get_categorical_columns(df)

    return (numeric = numeric_cols, categorical = categorical_cols)
end

function get_numeric_columns(df::DataFrame)

    return [
        col for col in Symbol.(names(df))
        if Base.nonmissingtype(eltype(df[!, col])) <: Number
    ]
end

function get_categorical_columns(df::DataFrame)

    return [
        col for col in Symbol.(names(df)) 
        if !(Base.nonmissingtype(eltype(df[!, col])) <: Number)
        ]
end

function drop_columns!(df::DataFrame, cols::Vector{Symbol})
    select!(df, Not(cols))
    return df
end

# !outliers


function detect_outliers_iqr(df::DataFrame, cols::Vector{Symbol})
    outlier_mask = falses(nrow(df))

    for col in cols

        x = df[!, col]

        q1 = quantile(x, 0.25)
        q3 = quantile(x, 0.75)

        iqr = q3 - q1

        lower = q1 - iqr * 1.5
        upper = q3 + iqr * 1.5

        col_mask = (x .< lower) .| (x .> upper)

        
        outlier_mask .|= col_mask
    end

    return outlier_mask
end

function remove_outliers_iqr!(df::DataFrame, cols::Vector{Symbol})

    outlier_mask = detect_outliers_iqr(df, cols)

    filtered_df = df[.!outlier_mask, :]

    empty!(df)
    append!(df, filtered_df)

    return df
end

# !missing values

function impute_missing!(df::DataFrame)
    
end

# !encoding

function ordinal_encode!(df::DataFrame, col::Symbol, mapping::Dict)

end

# !scaling

function standardize_columns!(df::DataFrame, cols::Vector{Symbol})

end

function normalize_minmax!(df::DataFrame, cols::Vector{Symbol})

end

# !helpers

function map_col_by_dict(df::DataFrame,col::Symbol,dict::Dict)

    df[!,col] = get.(Ref(dict), df[!,col], missing)

    return df
end