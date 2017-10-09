$arg=$args[0];
$workspace=(pwd).path

if (${arg}.EndsWith('.ghul')) {
    if (${arg}.ToLower().StartsWith(${workspace}.ToLower())) {
        ${test}=split-path -Leaf (split-path -Parent ${arg})

        echo "Run test containing ${arg}, test case ${test}"
    } else {
        echo "Run all tests"
    }
} elseif (compare-object "${arg}" "") {
    echo "Run all test cases"
} elseif (test-path "test/cases/" + ${arg}) {
    $test=$arg
    echo "Run test case ${test}"
} else {
    echo "Run all tests"    
}

docker run --rm -e GHULFLAGS -v ${workspace}:/home/dev/source/ -w /home/dev/source -t ghul/compiler:stable ./test.sh ${test}
