#ifndef FUNCTION_HPP
#define FUNCTION_HPP

#include <iostream>
#include <limits>

/**
 * @brief Adds two numbers a and b, returns the value.
 * 
 * @param a First integer
 * @param b Second integer
 * @return int Sum of a and b
 */
int function(int,int);

/**
 * @brief Get integer input using std::cin.
 * 
 * @param prompt std::string String to prompt user for input.
 * @param value Varible to assign value to.
 * @return true on sucessful integer input.
 * @return false on failure to enter integer input.
 */
bool getIntegerInput(const std::string& prompt, int& value);

#endif
