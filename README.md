# pmd-ci
Continuous Integration and False Positive management
for PMD extensible cross-language static code analyzer.

### install
make sure [PMD](https://pmd.github.io/) is in you execution path ($PATH)
configure PMD for your project
copy run-pmd.sh and pmd-post-process.rb to ./bin folder in your project


### report of open issues:
At the root of your project run:
```
run-pmd.sh
```

### generate report of false positives: 
```
run-pmd.sh --report
```


