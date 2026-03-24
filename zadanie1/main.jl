using DataFrames
using CSV
using StatsBase
using CairoMakie

include("data_processing/loader.jl")
include("data_processing/extended_describe.jl")
include("data_processing/plotting.jl")


# ładujemy dane z csv
df= load_file("SalariesInDataScience.csv")


# przygotowujemy rozszerzona wersję describe()
profile, size = profile_dataset(df)

# wybieramy kolumnę salary_in_usd jako nasz target
# typeof(df[!,:salary_in_usd]) # <- zwróci nam typ Vector{Int64}

plot_histogram(df, :salary_in_usd)
