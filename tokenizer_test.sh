#!/usr/bin/env bash

. ./tokenizer.sh

test_string_types() {
    local test_input
    local expected_result
    local tokenizer_result

    test_input='\(14)"hello"let'
    expected_result="paren number paren string name"
    tokenizer_result=$(tokenizer "${test_input}" |cut -f1 -d':')

    assertEquals "$expected_result" "$tokenizer_result"
}

test_string_values() {
    local test_input
    local expected_result
    local tokenizer_result

    test_input='\(14)"hello"let'
    expected_result="( 1 4 ) h e l l o l e t"
    tokenizer_result=$(tokenizer "${test_input}" |cut -f2 -d':')

    assertEquals "$expected_result" "$tokenizer_result"
}

# shellcheck disable=SC1091
. shunit2