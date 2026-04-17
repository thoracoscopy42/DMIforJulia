
function preprocess_and_map(path::AbstractString)

    df = load_file(path)
    
    #removal of redundant cols
    cols_for_removal = [:salary, :salary_currency, :employee_residence, :work_year]
    remove_cols!(df, cols_for_removal)
    
    
    #import smaller categories for job titles and countries
    countries  = load_dict_from_csv("dictionaries_data/countries.csv")
    job_titles = load_dict_from_csv("dictionaries_data/job_titles.csv")
    #map them to cols and remove old ones
    map_column!(df, :company_location, :continents, countries)
    map_column!(df, :job_title, :job_titles, job_titles)
    map_column!(df, :remote_ratio, :remote_type, remote)

    dropmissing!(df)

    return df
end

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
