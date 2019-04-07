#!/bin/bash
set -ue
#test_test_method_WAS_SET_UP="false"

run() {
    local test_method="$1"
    shift
    local args=($@)
    set_up_test "$test_method"
    $test_method "${args[@]}"
    result="$?"
    was_run "$test_method"
    tear_down_test "${test_method}"
    return "$result"
}

was_run() {
    local test_name="$1"
    eval "${test_name}_WAS_RUN=true"
    return 0
}

set_up() {
    return 0
}

tear_down() {
    return 0
}


set_up_test() {
    local test_name="$1"
    eval "${test_name}_WAS_RUN=false"
    set_up
    eval "${test_name}_WAS_SET_UP=true"
    return 0
}

tear_down_test() {
    local test_name="$1"
    tear_down
    eval "${test_name}_TEAR_DOWN=true"
    return 0
}

test_method() {
    return 0
}

another_method() {
    return 0
}


test_run() {
    local test_name="$1"
    local test_method_was_run="${test_name}_WAS_RUN"
    local test_method_set_up="${test_name}_WAS_SET_UP"
    run "$test_name"
    if ! "${!test_method_was_run}"; then
        echo "Failed after was_run $test_name"
        return 1
    fi
    eval "${test_name}_WAS_SET_UP=false"
    eval "${test_name}_WAS_RUN=false"
    echo "OK test_run $test_name"
    return 0
}

test_set_up_test() {
    local test_name="$1"
    local test_method_set_up="${test_name}_WAS_SET_UP"
    set_up_test "$test_name"
    if ! "${!test_method_set_up}"; then
        echo "Failed $test_name test_set_up_test"
        return 1
    fi
    eval "$test_method_set_up=false"
    echo "OK test_set_up_test $test_name"
    return 0
}

test_was_run() {
    local test_name="$1"
    local test_method_was_run="${test_name}_WAS_RUN"
    if "${!test_method_was_run}"; then
        echo "Failed $test_name test_was_run before"
        return 1
    fi
    was_run "$test_name"
    if ! "${!test_method_was_run}"; then
        echo "Failed $test_name test_was_run after"
        return 1
    fi
    eval "$test_method_was_run=false"
    echo "OK test_was_run $test_name"
    return 0
}

test_tear_down_test() {
    local test_name="$1"
    local test_method_tear_down="${test_name}_TEAR_DOWN"
    tear_down_test "$test_name"
    if ! "${!test_method_tear_down}"; then
        echo "Failed $test_name test_tear_down_test"
        return 1
    fi
    echo "OK test_tear_down_test $test_name"
    return 0
}

test_test_method() {
    test_method
    echo "OK test_test_method"
    return 0
}

test_another_method() {
    another_method
    echo "OK test_another_method"
    return 0
}

run test_tear_down_test test_method
run test_another_method
run test_set_up_test test_test_method
run test_was_run test_test_method
run test_run test_test_method
run test_test_method

