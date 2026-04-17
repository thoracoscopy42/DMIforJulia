function categorize_cols(df::DataFrame)

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