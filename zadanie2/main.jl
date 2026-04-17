using DataFrames
using CSV
using MLJ
using Statistics
using StatsBase
using CategoricalArrays
using MLJDecisionTreeInterface

# helpers
include("data_processing/loader.jl")
include("dictionaries_data/dictionaries.jl")

# working with data
include("data_processing/preprocessing.jl")
include("data_processing/processing.jl")

# Load and preprocess raw data
df = preprocess_and_map("dictionaries_data/SalariesInDataScience.csv")

# Create helper strata from raw salary values for stratified split
split_strata = make_split_strata(df.salary_in_usd)

# Perform stratified train/test split
train_idx, test_idx = partition(
    eachindex(split_strata),
    0.7,
    shuffle=true,
    stratify=split_strata,
    rng=173
)

# Split the full dataframe first
train_df = df[train_idx, :]
test_df  = df[test_idx, :]

# Fit salary class boundaries using train data only
salary_edges = fit_salary_edges(train_df.salary_in_usd)

# Apply the same class boundaries to both train and test targets
train_df.salary_in_usd = apply_salary_categories(train_df.salary_in_usd, salary_edges)
test_df.salary_in_usd  = apply_salary_categories(test_df.salary_in_usd, salary_edges)

# Convert feature columns to categorical types after the split
train_df = categorize_cols!(train_df)
test_df  = categorize_cols!(test_df)

# Split into features and target
Xtrain, ytrain = split_dataset(train_df, :salary_in_usd)
Xtest, ytest   = split_dataset(test_df, :salary_in_usd)

# Optional schema check
println("Train schema:")
schema(train_df)

println("\nTest schema:")
schema(test_df)