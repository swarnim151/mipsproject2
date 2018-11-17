.data
#creating output in the case the input is wrong
    Input_isLong: .asciiz "Input is too long."
    emptyInput: .asciiz "Input is empty."
    Input_isInvalid: .asciiz "Invalid base-35 number."
    # creating space for user to input
    Input_askUser: .space 2000
# storing the first four non-space characters. If the input has less than 4 characters, then the null value will be stored
    users_inputstorage: .space 4
.text

main: