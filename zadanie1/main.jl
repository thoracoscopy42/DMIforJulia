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

fig1 = plot_histogram(df, :salary_in_usd, bins=30)
save("plots/salary_histogram.svg", fig1)

fig2 = plot_boxplot(df, :experience_level, :salary_in_usd)
save("plots/experience_vs_salary.svg", fig2)

fig3 = plot_boxplot(df, :remote_ratio, :salary_in_usd)
save("plots/remote_vs_salary.svg", fig3)

display(fig1)
display(fig2)
display(fig3)