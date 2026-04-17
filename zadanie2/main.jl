using DataFrames
using CSV
using MLJ
using Statistics
using StatsBase
using CategoricalArrays
using MLJDecisionTreeInterface

#helpers
include("data_processing/loader.jl")
include("dictionaries_data/dictionaries.jl")
#working with data
include("data_processing/preprocessing.jl")
include("data_processing/processing.jl")
#modeling


# preprocessing improved a bit from zadanie1
df =preprocess_and_map("dictionaries_data/SalariesInDataScience.csv")

#categorization of cols, and adding proper scitypes
categorize_cols(df)

# schema(df) returns this, which means there is no need to coaerse!() the data, as scitypes are compatible with MLJ library
# ┌──────────────────┬──────────────────┬────────────────────────────────────┐
# │ names            │ scitypes         │ types                              │
# ├──────────────────┼──────────────────┼────────────────────────────────────┤
# │ experience_level │ OrderedFactor{4} │ CategoricalValue{String3, UInt32}  │
# │ employment_type  │ Multiclass{4}    │ CategoricalValue{String3, UInt32}  │
# │ salary_in_usd    │ OrderedFactor{5} │ CategoricalValue{String, UInt32}   │
# │ company_size     │ OrderedFactor{3} │ CategoricalValue{String1, UInt32}  │
# │ continents       │ Multiclass{6}    │ CategoricalValue{String15, UInt32} │
# │ job_titles       │ Multiclass{8}    │ CategoricalValue{String, UInt32}   │
# │ remote_type      │ Multiclass{3}    │ CategoricalValue{String, UInt32}   │
# └──────────────────┴──────────────────┴────────────────────────────────────┘

X, y = split_dataset(df, :salary_in_usd)


train, test =
    partition(eachindex(y),
              0.7,
              shuffle=true,
              rng=123)