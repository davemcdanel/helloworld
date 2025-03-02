#include "version.h"
/** Hello World! - For C++
 * \file main.cpp
 * \brief Main entry point.
 * \mainpage Hello World! - For C++
 * \version \b $(VERSION_STRING)
 * \brief C++ edition of the classic Hello World program. This version is used to test VSCODE with MSYS2 MinGW64 but should compile on most versions of C++.
 * \author David Lee McDanel <smokepid@gmail.com>; <pidsynccontrol@gmail.com>
 * \date June 5, 2016, 9:36 AM
 * \copyright Copyright (c) 2021 David L. McDanel
 * \n \n This is free and unencumbered software released into the public domain.
 * Anyone is free to copy, modify, publish, use, compile, sell, or
 * distribute this software, either in source code form or as a compiled
 * binary, for any purpose, commercial or non-commercial, and by any
 * means.
 * \n \n In jurisdictions that  recognize copyright laws, the author or authors
 * of this software dedicate any and all copyright interest in the
 * software to the public domain. We make this dedication for the benefit
 * of the public at large and to the detriment of our heirs and successors.
 * We intend this dedication to be an overt act of relinquishment in
 * perpetuity of all present and future rights to this software under
 * copyright law.
 * \n \n THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * \n \n For more information, please refer to <http://unlicense.org>
 */ 

#include <iostream>
#include <vector>
#include <string>
#include <limits>

#ifndef VERSION_STRING
    #error "Version not set.  Please configure makefile VERSION_STRING="
#endif

#ifndef BUILD_SYSTEM_OKAY
    #error "Build system not set up"
#endif

#include "function.hpp"

/** @brief Main program entry point.
 * 
 * @return int Zero on sucsess, one on error. 
 */
int main() {
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
    int retries = 5;

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
        return 1;
    }

    // Get input for b
    retries = 5;
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
        return 1;
    }

    /// @todo This is a thing to do.
    

    // Debug and compute
    std::cout << "Calling function with a=" << a << ", b=" << b << std::endl;
    c = function(a, b);
    std::cout << "Function returned: " << c << std::endl;
    std::cout << "Preparing output..." << std::endl;
    std::cout << "Output:\n" << a << "+" << b << "=" << c << std::endl;
    std::cout << "Program ending." << std::endl;
    std::cout << "Press ENTER to continue..." << std::endl;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    std::cin.get();

    return 0;
}
