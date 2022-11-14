1. Explain what you think the MIPs code is doing in a paragraph (3+ lines). Sufficiently summarizing what’s happening in your MIPs code’s disaggregate function is what we expect. Do not guess what the C/C++ code is doing. (5 points)
The MIPS code uses the stack frame to deallocate enough memory to keep track of each recursive call. 
Beginning with the first we save 8 words on the stack representing different things about input array, buffer, and small/big array.
Then, we use a loop to find the average of the input array, split the input array into largest and smallest and keep track of their lengths. 
We store those values on the buffer. The buffer increments by 80 bytes each time to allow for sufficient space. 
The beginning of the buffer on a given call will point to the small array, and the address moved over the length of the small aray times four holds the big array.
The buffer is thus essentially storage for different calls of the big/small arrays.
Once we do this we recursively call the same function to continue finding the average and splitting amongst
the big and small arrays. We make sure to have an end case (when depth is zero or array size is 1), and we make sure to reallocate the stack
correctly. We want the small and big arrays' lengths to be added after the stack reallocation to be the size smaller. 
After each recursive call returns it will print the depth and array, reallocating the values correctly, and moving on.

2. Will the space used in the stack change with change in array length or change in array values? Or change in depth value? Why or why not? (5 points)
Generally, the space used in the stack will not change with respect to array valeus because the stack holds integer values and pointers to arrays.
These are of fixed length because in MIPS they all take 4 bytes (1 word). Generally, depth value will change the stack allocation because it will 
cause more recursive calls and thus allocations of stack until depth count reaches zero or there are all arrays of size 1.
However, there is the edge case for both with a sufficiently small array size. 
Here, if array length is small enough that it reaches arrays of length one before depth count decrements to zero, then less of the stack will need to be allocated.
Similarly, there is a max depth count for general arrays that can be split, which would be the size of the array to get all one-sized arrays.
Now, if the depth count is greater than that maximum, it won't change the stack because no more recursive calls are possible after.