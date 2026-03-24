
#SECTION - Main function

function prepare_for_modeling!(df::DataFrame)

end

#TODO - below

# !column helpers

function get_numeric_columns(df::DataFrame)

end

function get_categorical_columns(df::DataFrame)

end

function drop_columns!(df::DataFrame, cols::Vector{Symbol})
    
end

# !outliers


function detect_outliers_iqr(df::DataFrame, cols::Vector{Symbol})
    
end

function remove_outliers_iqr!(df::DataFrame, cols::Vector{Symbol})
    
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