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
#data processing
include("data_processing/preprocessing.jl")

#modeling
include("data_processing/tree.model.jl")


df =preprocess_and_map("dictionaries_data/SalariesInDataScience.csv")


