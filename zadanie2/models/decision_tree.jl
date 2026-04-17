using MLJ
using MLJDecisionTreeInterface

Tree = @load DecisionTreeClassifier pkg=DecisionTree verbosity=0

function build_decision_tree_model()
    return OneHotEncoder() |> Tree()
end