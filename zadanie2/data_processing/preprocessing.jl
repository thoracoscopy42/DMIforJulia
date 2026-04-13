
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

function split_dataset(df::DataFrame, target::Symbol)

    y = df[!, target]

    X = select!(df, Not(target))

    return X, y
end

function create_salary_class!(df::DataFrame)

    q05 = quantile(df.salary_in_usd, 0.05)
    q30 = quantile(df.salary_in_usd, 0.30)
    q70 = quantile(df.salary_in_usd, 0.70)
    q95 = quantile(df.salary_in_usd, 0.95)

    df.salary_class = map(df.salary_in_usd) do s

        if s ≤ q05
            "very_low"

        elseif s ≤ q30
            "low"

        elseif s ≤ q70
            "mid"

        elseif s ≤ q95
            "high"

        else
            "very_high"

        end

    end

    df.salary_class = categorical(
        df.salary_class;
        ordered=true,
        levels=[
            "very_low",
            "low",
            "mid",
            "high",
            "very_high"
        ]
    )

    select!(df, Not(:salary_in_usd))
    
    return df

end