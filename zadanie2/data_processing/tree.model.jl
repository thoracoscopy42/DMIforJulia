
function model_tree(df::DataFrame)

    create_salary_class!(df)

    X, y = split_dataset(df, :salary_class)

    train, test = partition(eachindex(y), 0.7, shuffle = true, rng=173)

    Tree = @load DecisionTreeClassifier pkg=DecisionTree

    model = ContinuousEncoder() |> Tree()


    mach = machine(model, X, y)
    
    fit!(mach, rows=train)

    y_pred = predict_mode(mach, rows=test)

    acc = accuracy(y_pred, y[test])
    f1  = f1score(y_pred, y[test])

    println("Accuracy: ", acc)
    println("F1-score: ", f1)


end