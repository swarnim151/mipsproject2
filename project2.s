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

    addi $a1, $a1, 1     #adding 1 to the address as we take additional characters
    j loop_find4characters

    loop1_exit_check:
    beq $t0, 0, emptyInputlabel         # The null character can be at many places in the input depending upon the length of the input. However, if it occurs before any character(expect space) then the input is empty. We know that no characters(expect space) have been analysed if $t0 = 0. So, if $t0 = 0, then the string is empty

# Initialysing registers that hold values needed to calculate the value if the string is valid
    li $t8, 0
    li $t1, 1
    li $t2, 0

la $t9, users_inputstorage +4

loop_findvalue:
    beq $t2, 4, check_if_loop_continues        #this checks if we have gone through all the values. It ends the loop
    addi $t2, $t2, 1                    # incresing value of the loop count as we loop through the string from behind

    addi $t9, $t9, -1                   #increasing the value of the address by 1.In the next loop we look at the 2nd last, then 2nd and 1st chracter
    lb $t3, ($t9)                # loading the value of the byte to $t3

    beq $t3, 10, loop_findvalue      # check if the character is a new line. We will ignore it if it is

    beq $t3, 32, check_forspace        # check if the character is a space. We will ignore it if it is

    beq $t3, 0, loop_findvalue        # check if the character is a null. We will ignore it if it is

    li $a3, 1                # initializing the value as we reach the last valid character

#characater could be numbers or letters

#For numbers
    slti $t4, $t3, 58                     #anything below 58 is either a number or invalid
    li $t5, 47

    slt $t5, $t5, $t3
    and $t5, $t5, $t4
    addi $t0, $t3, -48            # t0 stores the actual value of the number
    beq $t5, 1, findvalue

#For Capital letters
    slti $t4, $t3, 95             #anything below 95 are capital letters or invalid
    li $t5, 64
    slt $t5, $t5, $t3
    and $t5, $t5, $t4
    addi $t0, $t3, -55

    beq $t5, 1, findvalue

#For small letters
    slti $t4, $t3, 122         #anything below 95 are capital letters or invalid
    li $t5, 96
    slt $t5, $t5, $t3
    and $t5, $t5, $t4

    addi $t0, $t3, -87
    bne $t5, 1, Input_isInvalidlabel
    j findvalue


#when we find a character that is not space, null or newline after the first we store the first four characters we need to analyse, this label is executed. It prints "Input is too long." and ends the program
Input_isLonglabel:
    li $v0, 4
    la $a0, Input_isLong
    syscall
    j exit
#If the string has no characters or if the string has only space in it, then this label executes. It prints "Input is empty." and ends the program
emptyInputlabel:
    li $v0, 4
    la $a0, emptyInput
    syscall
    j exit
#When we check if the character is a number or a letter, this label will execute if we find an invalid character.It prints ""Invalid base-35 number." and ends the program
Input_isInvalidlabel:
    li $v0, 4
    la $a0, Input_isInvalid
    syscall
    j exit

# checking if there is a space in between two valid characters. Like "abc" is valid but "ab c" is invalid
check_forspace:
    beq $a3, 1, Input_isInvalidlabel
    j loop_findvalue            #

#the loop will stop the program will exit if it has gone through all values
check_if_loop_continues:
    li $v0, 1
    add $a0, $zero, $t8
    syscall
    j exit

#findvalue will mutliply the value of the string with the exponent and add it to the sum
findvalue:
    mul $t6, $t1, $t0
    add $t8, $t8, $t6
    mul $t1, $t1, 35
    j loop_findvalue

#The program exits after printing the result
exit:
    li $v0, 10
    syscall
