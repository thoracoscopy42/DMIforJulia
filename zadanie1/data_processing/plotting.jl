
function plot_histogram(df::DataFrame, col; bins=30, title=nothing)

    col_in_use = collect(skipmissing(df[!, col]))
    
    fig = Figure(size=(900, 600))
    
    col = replace(string(col), "_" => " ")

    ax = Axis(
        fig[1,1],
        title = isnothing(title) ? "Histogram: $(col)" : title,
        xlabel = string(col),
        ylabel = "Count"
        )

    hist!(ax, col_in_use, bins=bins)

    return fig
end

function plot_boxplot(df::DataFrame, feature, target; title=nothing, group_order=nothing)
    valid_rows = .!ismissing.(df[!, feature]) .& .!ismissing.(df[!, target])
    
    feature_vals = df[valid_rows, feature]
    target_vals  = df[valid_rows, target]

    feature_label = replace(string(feature), "_" => " ")
    target_label  = replace(string(target),  "_" => " ")


    groups = isnothing(group_order) ? unique(feature_vals) : group_order

    x_positions = [findfirst(==(x), groups) for x in feature_vals]

    fig = Figure(size=(900,600))
    
    ax = Axis(
    fig[1,1],
    title = isnothing(title) ? "Boxplot: $(feature_label) vs $(target_label)" : title,
    xlabel = feature_label,
    ylabel = target_label,
    xticks = (1:length(groups), string.(groups))

    )

    boxplot!(ax, x_positions, target_vals)

    return fig
end