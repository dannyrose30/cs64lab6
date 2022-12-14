.data
#DO NOT CHANGE
buffer: .word 0:100
array: .word 9 1 2 1 17 19 10 9 11 10
newline: .asciiz "\n"
comma: .asciiz ", "
convention: .asciiz "Convention Check\n"
depth: .asciiz "depth "
colon: .asciiz ":"

.text
    main:
        la $a0 array #the input array
        li $a1 2 #depth: number of times you need to split an array
        la $a2 buffer #the buffer array address
        li $a3 10 #array length        
        move $s0, $a0
        move $s1, $a1
        move $s2, $a2
        move $s3, $a3
        ori $s4, $0, 0
        ori $s5, $0, 0

        jal disaggregate

        #la $t1 buffer
        #lw $t0 0($t1)

        #li $v0 1
        #move $a0 $t0
        #syscall


        j exit
    
    disaggregate:
        addiu $sp, $sp, -32 #the negative of how many values we store in (stack * 4)
        #We store array address, number of time to split (depth), buffer pointer, legnth of array
        #Also small array length, big array length, ra
        
        #store all required values that need to be preserved across function calls
        
        #store array address on stack--store once
        #store n on stack
        #store buffer pointer on stack
        #store length of array on stack

        sw $ra 0($sp) #return address
        sw $s0 4($sp) #s0 input array
        sw $s1 8($sp) #s1 depth
        sw $s2 12($sp) #s2 buffer
        sw $s3 16($sp) #s3 array length

        #Since our array_len parameter becomes small/big array len
        #We need them to be what they were before the next recursive call!

        #store small array length on stack
        #store big array length on stack

        #multiple function calls overwrite ra, therefore must be preserved
        #store return address


        #print depth value, according to expected format
        la $a0, depth    
        li $v0, 4
        syscall
        li $v0, 1
        move $a0, $s1
        syscall
        la $a0, colon    
        li $v0, 4
        syscall
        
        #Don't forget to define your variables!

        #It's dangerous to go alone, take this one loop for free
        #please enjoy and use carefully
        #this code makes no assumptions on your code
        #fix this code to work with yours or vice versa
        #don't have to use this loop either can make your own too

        move $t0 $s0
        li $t2 0 
        li $t7 1

        loop:
            #find sum
            bgt $t7, $s3, func_check #this is the loop exit condition
            lw $t6, 0($t0) #an element
            
            #print array entry
            li $v0, 1
            move $a0, $t6
            syscall
            li $v0, 4
            la $a0, comma
            syscall
            
            addi $t0, $t0, 4
            addi $t7, $t7, 1
            add $t2, $t2, $t6
            j loop

        func_check:
            #Add the recursive function end condition
            #Needs to exist so that we don't end up recursing to infinity!
            #This is the recursive equivalent to our iteration condition
            #for example the i < 10 in a for/while loop
            #We have two recursive conditions: depth == 0, arr_len == 1
            #They are OR'd in the C/C++ template
            #Do you need to OR them in MIPs too? 

            beq $s1 0 function_end
            beq $s3 1 function_end
            
        #calculate the average 
        div $t2, $s3 #what register do we divide by? 
        mflo $t3 #avg

        #This is the main loop, not for free :/
        
        move $t0 $s0
        move $t1 $s2
        li $t7 1
        li $t4 0
        li $t5 0

        loop2:
            #find big and small array
            #Remember the conditions for splitting
            #if entry <= average put in small array
            #if entry > average put in big array
            
            bgt $t7, $s3, loop2exit #this is the loop exit condition
            lw $t6, 0($t0) #an element
            bgt $t6 $t3 continue 
            sw $t6 0($t1)
            addi $t4 $t4 1
            addiu $t1 $t1 4
            continue:
            addi $t7 $t7 1
            addiu $t0 $t0 4
            j loop2

        loop2exit:
            li $t7 1
            move $t0 $s0
            #t1 buffer so keep

        loop3:
            bgt $t7, $s3, closing #this is the loop exit condition
            lw $t6, 0($t0) #an element
            ble $t6 $t3 continue2 

            #li $v0 4
            #la $a0 newline
            #syscall
            #li $v0 1
            #move $a0 $t6
            #syscall

            sw $t6 0($t1)
            addi $t5 $t5 1
            addiu $t1 $t1 4
            continue2:
            addi $t7 $t7 1
            addiu $t0 $t0 4
            j loop3
        
        closing:
        #This is the section where we prepare to call the function recursively.
        


            move $s4, $t4 #save the small array length value 
            move $s5, $t5 #save the big array length value

            jal ConventionCheck #DO NOT REMOVE 

            #Make sure your $s registers have the correct values before calling
            #Remember we recursively call with small array first
            #So load small array arguments in $s registers
            
            sw $s4 20($sp)
            sw $s5 24($sp)
            move $s0 $s2

            li $t3 4
            mult $s4 $t3
            mflo $t0
            addu $t1 $s2 $t0
            move $s7 $t1
            sw $s7 28($sp)

            #This is updating the buffer so that we don't overwrite our old values
            addi $s2, $s2, 80
            #We call small array first so we load small array length as arr_len
            move $s3, $s4
            addi $s1 $s1 -1
            jal disaggregate

            jal ConventionCheck #DO NOT REMOVE
            
            #Similarly for big array, we mirror the call structure of small array as above
            #But with the values appropriate for big array. 

            addi $s2, $s2, 80
            move $s3, $s5 #big array call second
            lw $s0 28($sp)

            jal disaggregate

            j function_end
        
        function_end:
        #Here we reset our values from previous iterations
        #Be careful on which values you load before and after the $sp update if you have to 
        #We can accidentally end up loading values of current calls instead of previous calls
        #Manually drawing out the stack changes helps figure this step out
            
            #Load values before update i
            
            lw $ra 0($sp) #return address   
            lw $s0 4($sp) #s0 input array
            lw $s1 8($sp) #s1 depth
            lw $s2 12($sp) #s2 buffer
            lw $s3 16($sp) #s3 array length


            addiu $sp, $sp, 32 #?? = the positive of how many values we store in (stack * 4)
            #Load values after update if you have to   
            lw $s4 20($sp)
            lw $s5 24($sp)
            lw $s7 28($sp)
            


            jr $ra
    exit:
        li $v0, 10
        syscall

ConventionCheck:  
#DO NOT CHANGE AUTOGRADER USES THIS  
    #reset all temporary values
    addi    $t0, $0, -1
    addi    $t1, $0, -1
    addi    $t2, $0, -1
    addi    $t3, $0, -1
    addi    $t4, $0, -1
    addi    $t5, $0, -1
    addi    $t6, $0, -1
    addi    $t7, $0, -1
    ori     $v0, $0, 4
    la      $a0, convention
    syscall
    addi    $v0, $zero, -1
    addi    $v1, $zero, -1
    addi    $a0, $zero, -1
    addi    $a1, $zero, -1
    addi    $a2, $zero, -1
    addi    $a3, $zero, -1
    addi    $k0, $zero, -1
    addi    $k1, $zero, -1
    jr      $ra
