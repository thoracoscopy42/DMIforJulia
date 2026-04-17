using MLJ
using Statistics
using StatsBase
using DataFrames

function evaluate_model_on_features(
    model_builder::Function,
    model_name::String,
    feature_set_name::String,
    features::Vector{Symbol},
    train_df::DataFrame,
    test_df::DataFrame,
    target::Symbol
)
    train_subset = select(train_df, vcat(features, [target]))
    test_subset  = select(test_df, vcat(features, [target]))

    Xtrain, ytrain = split_dataset(train_subset, target)
    Xtest, ytest   = split_dataset(test_subset, target)

    model = model_builder()
    mach = machine(model, Xtrain, ytrain)
    fit!(mach)

    yhat = MLJ.predict(mach, Xtest)
    ypred = mode.(yhat)

    acc = accuracy(ypred, ytest)
    bal_acc = balanced_accuracy(ypred, ytest)

    println("\nModel: ", model_name, " | Feature set: ", feature_set_name)
    println("accuracy: ", acc)
    println("balanced accuracy: ", bal_acc)

    return DataFrame(
        model = [model_name],
        feature_set = [feature_set_name],
        n_features = [length(features)],
        accuracy = [acc],
        balanced_accuracy = [bal_acc]
    )
end