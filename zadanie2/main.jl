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
include("data_processing/tree.model.jl")


df =preprocess_and_map("dictionaries_data/SalariesInDataScience.csv")


