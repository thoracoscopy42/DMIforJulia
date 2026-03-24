
function profile_dataset(df::DataFrame)
    
    size_val = dataset_size(df)
    ext_desc = add_more_metrics(df)    

    return ext_desc, size_val
end

##################################################
##################################################
function dataset_size(df::DataFrame)
    size_val = (nrow(df), ncol(df))
    return size_val
end

function add_more_metrics(df::DataFrame)

    ext_desc = describe(df)
    # adds a percent missing col
    ext_desc.missing_percent = ext_desc.nmissing ./ nrow(df) .* 100

    # count unique values in cols
    nunique_vals = [length(unique(skipmissing(df[!, col]))) for col in names(df)]
    ext_desc.nunique_values = nunique_vals

    # count the mode in all cols
    mode_val = [mode_helper(df[!,col]) for col in names(df)]
    ext_desc.mode_value = mode_val

    return ext_desc
end


function mode_helper(col) #if the value is not "missing" but just empty
    vals = collect(skipmissing(col))
    if isempty(vals)
        return missing
    else
        return mode(vals)
    end
end