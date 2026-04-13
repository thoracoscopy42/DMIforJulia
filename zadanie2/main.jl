using DataFrames
using CSV
using MLJ
using Statistics
using StatsBase
using CategoricalArrays
using MLJDecisionTreeInterface



include("data_processing/loader.jl")
include("data_processing/preprocessing.jl")
include("dictionaries.jl")


function main()

df = load_file("SalariesInDataScience.csv")

#removal of redundant cols
cols_for_removal = [:salary, :salary_currency, :employee_residence, :work_year]
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
ordinal_encode_ordered!(df, :company_size,   company_size_vector)
ordinal_encode_ordered!(df, :experience_level, experience_vector)

#ordered randomly
ordinal_encode_unordered!(df, :continents, location_vector)
ordinal_encode_unordered!(df, :job_titles, job_titles_vector)
ordinal_encode_unordered!(df, :remote_type, remote_vector)
ordinal_encode_unordered!(df, :employment_type, employment_vector)

#whoopsie
dropmissing!(df)


create_salary_class!(df)

X, y = split_dataset(df, :salary_class)

train, test = partition(eachindex(y), 0.7, shuffle = true, rng=173)

#TODO - make a function for each model 

Tree = @load DecisionTreeClassifier pkg=DecisionTree

model = ContinuousEncoder() |> Tree()


mach = machine(model, X, y)
fit!(mach, rows=train)

y_pred = predict_mode(mach, rows=test)

acc = accuracy(y_pred, y[test])
f1  = f1score(y_pred, y[test])

println("Accuracy: ", acc)
println("F1-score: ", f1)

end

main()



