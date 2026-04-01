using DataFrames
using CSV
using MLJ
using Statistics
using StatsBase


include("data_processing/loader.jl")

df = load_data("SalariesInDataScience.csv")



