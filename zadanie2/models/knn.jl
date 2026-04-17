using MLJ
using NearestNeighborModels

KNN = @load KNNClassifier pkg=NearestNeighborModels verbosity=0

function build_knn_model()
    return OneHotEncoder() |> KNN()
end