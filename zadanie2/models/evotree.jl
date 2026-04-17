using MLJ

EvoTree = @load EvoTreeClassifier verbosity=0

function build_evotree_model()
    return OneHotEncoder() |> EvoTree()
end