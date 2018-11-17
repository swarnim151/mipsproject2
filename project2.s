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

#aprompting the user to input the string
    li $v0, 8
    la $a0, Input_askUser
    li $a1, 2000
    syscall

la $a1, Input_askUser
    li $t0, 0                #t0 remains 0 until a valid character is entered. Then, it changes to 1 this distinction is necessary to find out if the input is valid or not

loop_find4characters:
    lb $a0,($a1)                    # load the first byte the first time the loop executes and subsequent bytes after that
    addi $a1, $a1, 1                # add 1 to the memory location, the goal is to load the next byte when the loop runs again

    beq $a0, 0, loop1_exit_check        #checking if the input character is a null character. the ascii value of the null character is 0

    beq $a0, 10, loop1_exit_check
#checking if the input character is newline. the ascii value of the newline is 10
