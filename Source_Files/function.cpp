#include <stdio.h>

/// @brief This function gets the address of a pointer and returns the address.
/// @return The address of a pointer.
void* function(){
    int junk = 1;
    int* j;
    j = &junk;

    return j;
}
