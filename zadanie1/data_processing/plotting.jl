
function plot_histogram(df::DataFrame, col; bins=30, title=nothing)
    col_in_use = collect(skipmissing(df[!, col]))
    
    fig = Figure(size=(900, 600))
    
    
    ax = Axis(
        fig[1,1],
        title = isnothing(title) ? "Histogram $(col_in_use)" : title,
        xlabel = string(col),
        ylabel = "Liczność"
        )

    hist!(ax, col_in_use, bins=bins)
    
    return fig


end