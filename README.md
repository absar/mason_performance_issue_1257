# mason_performance_issue_1257
https://github.com/felangel/mason/issues/1257

Generating files using Mason from a list which is not a simple string rather a `List<Map<String, dynamic>>` takes exponentially greater time. 
For example `{{#updateMethods}}{{{usecaseName.snakeCase()}}}.dart{{/updateMethods}}` takes over 10 minutes to generate 4 files on Windows 10 i7 processor with 16gb RAM, the process consumes only around 25% CPU and negligible disk and memory activity, however if you change the name extraction from triple `{` to double e.g. `{{#updateMethods}}{{usecaseName.snakeCase()}}.dart{{/updateMethods}}` then it generates in 5 seconds, however it only generates a single file by appending all names, with all the content meant for the 4 files.
On further investigation we found that increasing number of `context.vars` might be the reason it slows down, e.g. in the config file `/bricks/templates/wallet.json` add more `properties`.
In the pre_gen.dart if you reduce `context.vars` by commenting these lines then the time is reduced exponentially, solving this issue will help adopt Mason for slightly complex use cases by reducing 
generation time from hours to seconds:
```
'notNullProperties': notNullProperties(properties),
'notNullViewProperties': notNullViewProperties(properties),
```

Setup:
Latest mason CLI, Flutter 3.16.9
Windows 10

Steps:
`mason get`
`mason make code_gen -c ./bricks/templates/wallet.json --on-conflict overwrite`

Sample input data:
```json
{
  "project_name": "Project1",
  "feature_name": "Wallet",
  "feature_directory": "wallet",
  "properties": [
    { "name": "property1", "entityDataType": "UniqueId?", "viewDataType": "UniqueId?"},
    { "name": "property2", "entityDataType": "double", "viewDataType": "double"},
    { "name": "property3", "entityDataType": "double", "viewDataType": "double"},
    { "name": "property4", "entityDataType": "double", "viewDataType": "double"},
    { "name": "property5", "entityDataType": "double", "viewDataType": "double"},
    { "name": "property6", "entityDataType": "double", "viewDataType": "double"},
    { "name": "property7", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property8", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property9", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property10", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property11", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property12", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property13", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property14", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property15", "entityDataType": "DateTime?", "viewDataType": "DateTime?"},
    { "name": "property16", "entityDataType": "int", "viewDataType": "int"},
    { "name": "property17", "entityDataType": "int", "viewDataType": "int"},
    { "name": "property18", "entityDataType": "int", "viewDataType": "int"},
    { "name": "property19", "entityDataType": "int", "viewDataType": "int"},
    { "name": "property20", "entityDataType": "int", "viewDataType": "int"}
  ],
  "updateMethods": [
    { "usecaseName": "UpdateBalance", "paramsToUpdate": [{"paramName": "balance", "paramType": "double"}]},
    { "usecaseName": "RewardA", "paramsToUpdate": [{"paramName": "balance", "paramType": "double"}, {"paramName": "rewardedCoins", "paramType": "double"}, {"paramName": "rewardedAt", "paramType": "DateTime"}]},
    { "usecaseName": "RewardB", "paramsToUpdate": [{"paramName": "balance", "paramType": "double"}, {"paramName": "rewardedCoins", "paramType": "double"}, {"paramName": "rewardedAt", "paramType": "DateTime"}]},
    { "usecaseName": "UpdateName", "paramsToUpdate": [{"paramName": "name", "paramType": "String"}]}
  ]
}
```
