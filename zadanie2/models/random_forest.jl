using MLJ
using MLJDecisionTreeInterface

Forest = @load RandomForestClassifier pkg=DecisionTree verbosity=0

function build_random_forest_model()
    return OneHotEncoder() |> Forest()
end