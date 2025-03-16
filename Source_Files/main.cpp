#include "version.h"
/** Hello World! - For C++
 * @file main.cpp
 * @brief Main entry point.
 * @mainpage Hello World! - For C++
 * @version @b $(VERSION_STRING)
 * @brief C++ edition of the classic Hello World program. This version is used to test VSCODE with MSYS2 MinGW64 but should compile on most versions of C++.
 * @author David Lee McDanel <smokepid@gmail.com>; <pidsynccontrol@gmail.com>
 * @date June 5, 2016, 9:36 
 * @copyright Copyright (c) 2025 David Lee McDanel
 * @n @n This is free and unencumbered software released into the public domain under the Unlicense (see LICENSE.md).
 */ 

#include <iostream>
#include <vector>
#include <string>
#include <limits>

#ifndef VERSION_STRING
    #error "Version not set.  Please configure makefile VERSION_STRING="
#endif

#ifndef BUILD_SYSTEM_OKAY
    #error Build system not set up.
#endif

#include "function.hpp"

/** @brief Main program entry point.
 * 
 * @return int Zero on success, one on error. 
 */
int main(int argc, char* argv[]) {
    std::vector<std::string> msg {"Hello", "C++", "World!", VERSION_STRING, "\n"};
    msg.push_back("\nAdd any two numbers.\n");

    #ifdef _WIN32
        system("cls");
    #else
        std::cout << "\x1B[2J\x1B[H";
    #endif

    for (const std::string& word : msg) {
        std::cout << " " << word;
    }
    std::cout << "----------------" << std::endl;

    int a{0}, b{0}, c{0};
    const int retriesStart = 4;
    int retries = retriesStart;

    if (argc>=3){
        try{
            a = std::stoi(argv[1]);
        }catch(std::invalid_argument const& ex){
            std::cout << "CLI entry for a is not valid: " << ex.what() << "\nPlease enter new value for a.";
            return 1;
        }
        try{
            b = std::stoi(argv[2]);
        }catch(std::invalid_argument const& ex){
                std::cout << "CLI entry for a is not valid." << ex.what() << "\nPlease enter new value for b.";
                return 2;
        }
    }else {
        // Get input for a
        while (retries > 0) {
            std::cout << "Retries remaining: " << retries << std::endl;
            if (getIntegerInput("Enter value for a: ", a)) {
                std::cout << "Got valid a: " << a << std::endl;
                break;
            }
            retries--;
            std::cout << "----------------" << std::endl;
        }
        if (retries == 0) {
            std::cout << "Too many invalid attempts for a. Exiting." << std::endl;
            return 3;
        }

        // Get input for b
        retries = retriesStart;
        while (retries > 0) {
            std::cout << "Retries remaining: " << retries << std::endl;
            if (getIntegerInput("Enter value for b: ", b)) {
                std::cout << "Got valid b: " << b << std::endl;
                break;
            }
            retries--;
            std::cout << "----------------" << std::endl;
        }
        if (retries == 0) {
            std::cout << "Too many invalid attempts for b. Exiting." << std::endl;
            return 4;
        }
    }

    // This is a test for doxygen todo list and also Todo Tree.
    /// @note This is a note.
    /**
     * @warning This is a stern warning!
     * 
     * @todo This is todo is not open.
     * 
     * @todo[x] This is a markdown checkbox marked complete.
     * 
     * @todo[ ] This is a markdown checkbox not complete.
     */

    // Debug and compute
    std::cout << "Calling function with a=" << a << ", b=" << b << std::endl;
    c = add(a, b);
    std::cout << "Function returned: " << c << std::endl;
    std::cout << "Preparing output..." << std::endl;
    std::cout << "Output:\n" << a << "+" << b << "=" << c << std::endl;
    std::cout << "Program ending." << std::endl;
    if (argc >=3){return 0;}
    std::cout << "Press ENTER to continue..." << std::endl;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    std::cin.get();

    return 0;
}
