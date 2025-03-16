/** @file function.hpp
 * @author David McDanel
 * @brief Helper function prototypes.
 * @date 2025-02-23
 * 
 * @copyright Copyright (c) 2025 David Lee McDanel
 * @n @n This is free and unencumbered software released into the public domain under the Unlicense (see LICENSE.md).
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
int add(int a,int b);

/** @brief Get integer input using std::cin.
 * 
 * @param prompt std::string String to prompt user for input.
 * @param value Variable to assign value to.
 * @return true on successful integer input.
 * @return false on failure to enter integer input.
 */
bool getIntegerInput(const std::string& prompt, int& value);

#endif
