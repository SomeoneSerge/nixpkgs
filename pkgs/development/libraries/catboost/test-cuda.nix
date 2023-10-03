{ runCommand, python3Packages }:

runCommand "catboost-cuda-discovery"
{
  nativeBuildInputs = [
    (python3Packages.python.withPackages (ps: [ ps.catboost ]))
  ];
  requiredSystemFeatures = [ "require-cuda" ];
} ''
  python << EOF
  from catboost import CatBoostClassifier

  train_data = [[0, 3],
                [4, 1],
                [8, 1],
                [9, 1]]
  train_labels = [0, 0, 1, 1]

  model = CatBoostClassifier(iterations=1000,
                             task_type="GPU",
                             devices='0:1')
  model.fit(train_data,
            train_labels,
            verbose=False)
  EOF
  touch $out
''
