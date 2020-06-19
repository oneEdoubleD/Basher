#!/usr/bin/env bash

tokenizer() {
    readonly input=$1
    readonly input_length=$(printf %s "$input" | wc -c) 

    local current=1
    local types=()
    local values=()

    while [ $current -lt $(( input_length + 1 )) ]
    do
        local char
        char=$(expr substr "${input}" $current 1)

        case $char in
            "\\")
                current=$(( current + 1 ))
                ;;
            "(")
                types+=('paren')
                values+=('(')

                current=$(( current + 1 ))
                ;;
            
            

            ")")
                types+=('paren')
                values+=(')')

                current=$(( current + 1 ))
                ;;
            
            " ")
                current=$(( current + 1 ))
                ;;

            ([0-9])
                local value=()
                while [[ "$char" =~ ^[0-9]+$ ]]
                do
                    value+=("$char")

                    current=$(( current + 1 ))
                    char=$(expr substr $input $current 1)
                done

                types+=("number")
                values+=("${value[@]}")
                ;;

            '"')
                local value=()

                current=$(( current + 1 ))
                char=$(expr substr $input $current 1)

                while [[ "$char" != '"' ]]
                do
                    value+=("$char")

                    current=$(( current + 1 ))
                    char=$(expr substr $input $current 1)
                done

                current=$(( current + 1 ))
                char=$(expr substr $input $current 1)

                types+=("string")
                values+=("${value[@]}")
                ;;

            ([[:alpha:]])
                local value=()
                while [[ "$char" =~ [[:alpha:]] ]]
                do
                    value+=("$char")

                    current=$(( current + 1 ))
                    char=$(expr substr $input $current 1)
                done

                types+=("name")
                values+=("${value[@]}")
                ;;

            *)
                exit 1
                ;;
        esac
    done    

    # shellcheck disable=SC2145 # this is intentional
    echo "${types[@]}"":""${values[@]}"
}
