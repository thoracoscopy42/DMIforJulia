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

end


function categorize_salary!(col)
    
    q05, q30, q70,q95 = quantile(col, [0.05, 0.30, 0.70, 0.95])

    col = cut(
        #column
        col,
        #ranges for categorization
        [-Inf, q05, q30, q70, q95, Inf];
        #category for each range
        labels=["very_low", "low", "mid", "high", "very_high"]
    )

    return col
end




function split_dataset(df::DataFrame, target::Symbol)
    y, X = unpack(df, ==(target))
    return X, y
end

