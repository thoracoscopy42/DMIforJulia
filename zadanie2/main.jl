using DataFrames
using CSV
using MLJ
using Statistics
using StatsBase
using CategoricalArrays
using MLJDecisionTreeInterface
using Plots

# helpers
include("data_processing/loader.jl")
include("dictionaries_data/dictionaries.jl")

# working with data
include("data_processing/preprocessing.jl")
include("data_processing/processing.jl")

# models
include("models/utils.jl")
include("models/decision_tree.jl")
include("models/random_forest.jl")
include("models/knn.jl")
include("models/multinomial.jl")
include("models/evotree.jl")

#features
include("experiments/feature_sets.jl")

# plots
include("plots/benchmark_plots.jl")



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



# define feature sets
feature_sets = get_feature_sets()

# define model builders
model_builders = [
    ("Decision Tree", build_decision_tree_model),
    ("Random Forest", build_random_forest_model),
    ("KNN", build_knn_model),
    ("Multinomial", build_multinomial_model),
    ("EvoTree", build_evotree_model)
]

# benchmark all models on all feature sets
results = DataFrame(
    model = String[],
    feature_set = String[],
    n_features = Int[],
    accuracy = Float64[],
    balanced_accuracy = Float64[]
)

for (model_name, model_builder) in model_builders
    for (feature_set_name, features) in feature_sets
        row = evaluate_model_on_features(
            model_builder,
            model_name,
            feature_set_name,
            features,
            train_df,
            test_df,
            :salary_in_usd
        )

        append!(results, row)
    end
end

println("\n--- benchmark results ---")
display(results)

# sort results for easier reading
sorted_results = sort(results, [:balanced_accuracy, :accuracy], rev=true)

println("\n--- sorted benchmark results ---")
display(sorted_results)

# interactive plots
acc_plot = plot_accuracy_by_feature_set(results)
bal_acc_plot = plot_balanced_accuracy_by_feature_set(results)
acc_heatmap = plot_accuracy_heatmap(results)
bal_acc_heatmap = plot_balanced_accuracy_heatmap(results)



# create output directory
mkpath("results")

# save tables
CSV.write("results/benchmark_results.csv", results)
CSV.write("results/benchmark_results_sorted.csv", sorted_results)

# save interactive plots
savefig(acc_plot, "results/accuracy_by_feature_set.html")
savefig(bal_acc_plot, "results/balanced_accuracy_by_feature_set.html")
savefig(acc_heatmap, "results/accuracy_heatmap.html")
savefig(bal_acc_heatmap, "results/balanced_accuracy_heatmap.html")

results_to_save = copy(results)
sorted_to_save = copy(sorted_results)

results_to_save.accuracy = round.(results_to_save.accuracy, digits=4)
results_to_save.balanced_accuracy = round.(results_to_save.balanced_accuracy, digits=4)

sorted_to_save.accuracy = round.(sorted_to_save.accuracy, digits=4)
sorted_to_save.balanced_accuracy = round.(sorted_to_save.balanced_accuracy, digits=4)

mkpath("results")

CSV.write("results/benchmark_results.csv", results_to_save)
CSV.write("results/benchmark_results_sorted.csv", sorted_to_save)

savefig(acc_plot, "results/accuracy_by_feature_set.html")
savefig(bal_acc_plot, "results/balanced_accuracy_by_feature_set.html")
savefig(acc_heatmap, "results/accuracy_heatmap.html")
savefig(bal_acc_heatmap, "results/balanced_accuracy_heatmap.html")

open("results/summary.txt", "w") do io
    println(io, "Benchmark summary")
    println(io, "=================")
    println(io)

    top_n = min(10, nrow(sorted_to_save))

    println(io, "Top configurations by balanced accuracy:")
    println(io)

    for i in 1:top_n
        row = sorted_to_save[i, :]
        println(io, "Rank ", i)
        println(io, "  model: ", row.model)
        println(io, "  feature set: ", row.feature_set)
        println(io, "  number of features: ", row.n_features)
        println(io, "  accuracy: ", row.accuracy)
        println(io, "  balanced accuracy: ", row.balanced_accuracy)
        println(io)
    end
end

println("\nSaved outputs to results/")