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

    beq $a0, 32, loop_find4characters
#checking if the input character is a spacebar, i.e ' '. the ascii value of the space is 32

    beq $t0, 1, Input_isLonglabel
# if the input charcter is not space,newline or null, then it is either a valid charcter or invalid character. Regardless, this is the first character we analyse. Then we take that and the next three characters after it in a row and also set the value of t0  to 1. If we find another non-space character after that then the input is too long. $t0 is set as 1 in this case and the code executes the "Input_isLonglabel" part and send the "Input is long" message and ends(exits)

    li $t0, 1
# setting the value of $t0 value to 1 as mentioned above

# Storing the character and the next three charcters after that as mentioned above
    la $t9, users_inputstorage
    lb $a0, -1($a1)
    sb $a0, 0($t9)

    lb $a0, 0($a1)
    sb $a0, 1($t9)
    addi $a1, $a1, 1    #adding 1 to the address as we take additional characters

   lb $a0, 0($a1)
    sb $a0, 2($t9)
    addi $a1, $a1, 1    #adding 1 to the address as we take additional characters

    lb $a0, 0($a1)
#After this four characters are stored

    sb $a0, 3($t9)
