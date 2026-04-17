using Plots
using DataFrames

function plot_accuracy_by_feature_set(results::DataFrame)
    plotly()

    models = unique(results.model)

    plt = plot(
        title = "Accuracy by model and feature set",
        xlabel = "Feature set",
        ylabel = "Accuracy",
        legend = :outertopright,
        size = (1200, 700)
    )

    for m in models
        sub = filter(row -> row.model == m, results)
        plot!(
            plt,
            sub.feature_set,
            sub.accuracy,
            seriestype = :bar,
            label = m
        )
    end

    display(plt)
    return plt
end

function plot_balanced_accuracy_by_feature_set(results::DataFrame)
    plotly()

    models = unique(results.model)

    plt = plot(
        title = "Balanced accuracy by model and feature set",
        xlabel = "Feature set",
        ylabel = "Balanced accuracy",
        legend = :outertopright,
        size = (1200, 700)
    )

    for m in models
        sub = filter(row -> row.model == m, results)
        plot!(
            plt,
            sub.feature_set,
            sub.balanced_accuracy,
            seriestype = :bar,
            label = m
        )
    end

    display(plt)
    return plt
end

function plot_accuracy_heatmap(results::DataFrame)
    plotly()

    models = unique(results.model)
    feature_sets = unique(results.feature_set)

    z = zeros(length(models), length(feature_sets))

    for (i, m) in enumerate(models)
        for (j, fs) in enumerate(feature_sets)
            row = filter(r -> r.model == m && r.feature_set == fs, results)
            if nrow(row) == 1
                z[i, j] = row.accuracy[1]
            end
        end
    end

    plt = heatmap(
        feature_sets,
        models,
        z,
        title = "Accuracy heatmap",
        xlabel = "Feature set",
        ylabel = "Model",
        size = (1200, 700)
    )

    display(plt)
    return plt
end

function plot_balanced_accuracy_heatmap(results::DataFrame)
    plotly()

    models = unique(results.model)
    feature_sets = unique(results.feature_set)

    z = zeros(length(models), length(feature_sets))

    for (i, m) in enumerate(models)
        for (j, fs) in enumerate(feature_sets)
            row = filter(r -> r.model == m && r.feature_set == fs, results)
            if nrow(row) == 1
                z[i, j] = row.balanced_accuracy[1]
            end
        end
    end

    plt = heatmap(
        feature_sets,
        models,
        z,
        title = "Balanced accuracy heatmap",
        xlabel = "Feature set",
        ylabel = "Model",
        size = (1200, 700)
    )

    display(plt)
    return plt
end