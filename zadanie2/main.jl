using DataFrames
using CSV
using MLJ
using Statistics
using StatsBase
using CategoricalArrays



include("data_processing/loader.jl")
include("data_processing/preprocessing.jl")
include("dictionaries.jl")


function main()

df = load_file("SalariesInDataScience.csv")

#removal of redundant cols
cols_for_removal = [:salary, :salary_currency, :employee_residence]
remove_cols!(df, cols_for_removal)

#import smaller categories for job titles and countries
countries  = load_dict_from_csv("countries.csv")
job_titles = load_dict_from_csv("job_titles.csv")
#map them to cols and remove old ones
map_column!(df, :company_location, :continents, countries)
map_column!(df, :job_title, :job_titles, job_titles)
map_column!(df, :remote_ratio, :remote_type, remote)
#encoding with native Julia tools

#order matters
ordinal_encode_ordered!(df, :experience_level, experience_vector)
ordinal_encode_ordered!(df, :employment_type,  employment_vector)
ordinal_encode_ordered!(df, :company_size,   company_size_vector)
ordinal_encode_ordered!(df, :experience_level, experience_vector)

#ordered randomly
ordinal_encode_unordered!(df, :continents, location_vector)
ordinal_encode_unordered!(df, :job_titles, job_titles_vector)
ordinal_encode_unordered!(df, :remote_type, remote_vector)

X, y = divide_dataset(df, :salary_in_usd)


end

main()



