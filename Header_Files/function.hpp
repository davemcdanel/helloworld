/** @file function.hpp
 * @author David McDanel
 * @brief Helper function prototypes.
 * @version 0.1
 * @date 2025-02-23
 * 
 * @copyright Copyright (c) 2025
 * 
 */
#ifndef FUNCTION_HPP
#define FUNCTION_HPP

#include <iostream>
#include <limits>

/** @brief Adds two numbers a and b, returns the value.
 * 
 * @param a First integer
 * @param b Second integer
 * @return int Sum of a and b
 */
int function(int a,int b);

/** @brief Get integer input using std::cin.
 * 
 * @param prompt std::string String to prompt user for input.
 * @param value Varible to assign value to.
 * @return true on sucessful integer input.
 * @return false on failure to enter integer input.
 */
bool getIntegerInput(const std::string& prompt, int& value);

#endif
