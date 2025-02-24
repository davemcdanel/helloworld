/** @file function.cpp
 * @author David McDanel
 * @brief Helper functions.
 * @version 0.1
 * @date 2025-02-23
 * 
 * @copyright Copyright (c) 2025
 * 
 */
#include "function.hpp"

int function(int a, int b){
    return a+b;
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