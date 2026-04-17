using MLJ
using MLJLinearModels

Multinom = @load MultinomialClassifier pkg=MLJLinearModels verbosity=0

function build_multinomial_model()
    return OneHotEncoder() |> Multinom()
end