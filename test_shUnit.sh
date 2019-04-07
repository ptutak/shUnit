#!/bin/bash

SH_UNIT_DIR=bashUnit

source "$SH_UNIT_DIR/shUnit"
source "$SH_UNIT_DIR/test"

test_run() {
    local test_name="$1"
    local test_method_was_run="${test_name}_WAS_RUN"
    local test_method_set_up="${test_name}_WAS_SET_UP"
    run "$test_name"
    if ! "${!test_method_was_run}"; then
        return 1
    fi
    return 0
}

test_set_up_test() {
    local test_name="$1"
    local test_method_set_up="${test_name}_WAS_SET_UP"
    set_up_test "$test_name"
    if ! "${!test_method_set_up}"; then
        return 1
    fi
    return 0
}

test_was_run() {
    local test_name="$1"
    local test_method_was_run="${test_name}_WAS_RUN"
    if "${!test_method_was_run}"; then
        return 1
    fi
    was_run "$test_name"
    if ! "${!test_method_was_run}"; then
        return 1
    fi
    return 0
}

test_tear_down_test() {
    local test_name="$1"
    local test_method_tear_down="${test_name}_TEAR_DOWN"
    tear_down_test "$test_name"
    if ! "${!test_method_tear_down}"; then
        return 1
    fi
    return 0
}

test_test_method() {
    test_method
    return 0
}

test_another_method() {
    another_method
    return 0
}

test_log_status() {
    ok_message="$(log_status my_test 0)"
    failed_message="$(log_status my_test 1)"
    if [[ "$ok_message" == "OK: my_test" && "$failed_message" == "FAILED: my_test" ]]; then
        return 0
    fi
    return 1
}


run test_tear_down_test test_method
run test_another_method
run test_set_up_test test_test_method
run test_was_run test_test_method
run test_run test_test_method
run test_test_method
run test_log_status
