using DataFrames
using CSV
using StatsBase
using CairoMakie

include("data_processing/loader.jl")
include("data_processing/extended_describe.jl")
include("data_processing/plotting.jl")
include("data_processing/preprocessing.jl")

# load data
df= load_file("SalariesInDataScience.csv")

# rozszerzona wersja describe()
profile, size = profile_dataset(df)

# wybieramy kolumnę salary_in_usd jako nasz target ->>> typeof(df[!,:salary_in_usd]) # <- zwróci nam typ Vector{Int64}

# NOTE - plotting
# fig1 = plot_histogram(df, :salary_in_usd, bins=30)
# save("plots/salary_histogram.svg", fig1)

# fig2 = plot_boxplot(df, :experience_level, :salary_in_usd, group_order = ["EN", "MI", "SE", "EX"])
# save("plots/experience_vs_salary.svg", fig2)

# fig3 = plot_boxplot(df, :remote_ratio, :salary_in_usd, group_order = [0, 50, 100])
# save("plots/remote_vs_salary.svg", fig3)

# display(fig1)
# display(fig2)
# display(fig3)


cols = split_columns_by_type(df)
cols_for_removal = [:salary, :salary_currency, :employee_residence]
drop_columns!(df, cols_for_removal)


countries = load_dict_from_csv("countries.csv")
map_col_by_dict(df, :company_location, countries)

include("dictionaries.jl")
map_col_by_dict(df, :experience_level, experience)
map_col_by_dict(df, :employment_type, employment)
map_col_by_dict(df, :company_size, company_size)

job_titles = load_dict_from_csv("job_titles.csv")
map_col_by_dict(df, :job_title, job_titles)

dropmissing!(df)
# profile_dataset(df)
unique(df[!, :company_location])
