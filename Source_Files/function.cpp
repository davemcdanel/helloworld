/** @file function.cpp
 * @author David McDanel
 * @brief Helper functions.
 * @date 2025-02-23
 * 
 * @copyright Copyright (c) 2025 David Lee McDanel
 * @n @n This is free and unencumbered software released into the public domain under the Unlicense (see LICENSE.md).
 * 
 */
#include "function.hpp"

int add(int a, int b){
    if (a > std::numeric_limits<int>::max() - b) {
        std::cerr << "Integer overflow detected!" << std::endl;
        return std::numeric_limits<int>::max();
    }
    return a + b;
}

bool getIntegerInput(const std::string& prompt, int& value) {
    std::cout << prompt << std::flush;
    if (std::cin >> value) {
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        return true;
    }
    std::cout << "Invalid input. Clearing stream..." << std::endl;
    std::cin.clear();
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    return false;
}