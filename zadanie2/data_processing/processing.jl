function categorize_cols!(df::DataFrame)
    df.experience_level = categorical(
        df.experience_level,
        ordered=true,
        levels=experience_vector
    )

    df.company_size = categorical(
        df.company_size,
        ordered=true,
        levels=company_size_vector
    )

    df.employment_type = categorical(df.employment_type, ordered=false)
    df.continents = categorical(df.continents, ordered=false)
    df.job_titles = categorical(df.job_titles, ordered=false)
    df.remote_type = categorical(df.remote_type, ordered=false)

    return df
end

function fit_salary_edges(col)
    q05, q30, q70, q95 = quantile(col, [0.05, 0.30, 0.70, 0.95])
    return [-Inf, q05, q30, q70, q95, Inf]
end

function apply_salary_categories(col, edges)
    return cut(
        col,
        edges;
        labels=["very_low", "low", "mid", "high", "very_high"]
    )
end

function make_split_strata(col)
    q20, q40, q60, q80 = quantile(col, [0.20, 0.40, 0.60, 0.80])

    return cut(
        col,
        [-Inf, q20, q40, q60, q80, Inf];
        labels=["bin1", "bin2", "bin3", "bin4", "bin5"]
    )
end

function split_dataset(df::DataFrame, target::Symbol)
    y, X = unpack(df, ==(target))
    return X, y
end