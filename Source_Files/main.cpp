/** Hello World! - For C++
 * \file main.cpp
 * \brief Main program entry point.
 *
 * \mainpage Hello World! - For C++
 * \version 0.0.2
 * \brief C++ edition of the classic Hello World program. This version is used to test VSCODE with MSYS2 MinGW64 but should compile on most versions of C++.
 *
 *
 * \author David Lee McDanel <smokepid@gmail.com>; <pidsynccontrol@gmail.com>
 * \date June 5, 2016, 9:36 AM
 * \copyright Copyright (c) 2021 David L. McDanel
 * This is free and unencumbered software released into the public domain.
 * Anyone is free to copy, modify, publish, use, compile, sell, or
 * distribute this software, either in source code form or as a compiled
 * binary, for any purpose, commercial or non-commercial, and by any
 * means.
 * 
 * In jurisdictions that recognize copyright laws, the author or authors
 * of this software dedicate any and all copyright interest in the
 * software to the public domain. We make this dedication for the benefit
 * of the public at large and to the detriment of our heirs and
 * successors. We intend this dedication to be an overt act of
 * relinquishment in perpetuity of all present and future rights to this
 * software under copyright law.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * For more information, please refer to <http://unlicense.org>
 */

#include <iostream>
#include <vector>
#include <string>

#ifndef BUILD_SYSTEM_OKAY
    #error "Build system not set up"
#endif

#include "function.hpp"

int main(){
    std::vector<std::string> msg {"Hello", "C++", "World", "from", "VS Code", "and the C++ extension!"};
    msg.push_back("\nHello!\n");
    
    std::cout << "\x1B[2J\x1B[H";

    for (const std::string& word : msg){
        std::cout << " " << word;
    }

    std::cout << "Some memory location: " << int(function()) << std::endl;
return 0;
}
 
/*
#include <windows.h>
/// @brief Window Proc
/// @param hWnd 
/// @param uMsg 
/// @param wParam 
/// @param lParam 
/// @return 0
LRESULT CALLBACK WindowProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_DESTROY:
            PostQuitMessage(0);
            break;
        default:
            return DefWindowProc(hWnd, uMsg, wParam, lParam);
    }
    return 0;
}

/// @brief Main window.
/// @param hInstance 
/// @param hPrevInstance 
/// @param lpCmdLine 
/// @param nCmdShow 
/// @return 
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {

    // Register window class
    WNDCLASSEX wcex = {0};
    wcex.cbSize = sizeof(WNDCLASSEX);
    wcex.style = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc = WindowProc;
    wcex.hInstance = hInstance;
    wcex.hCursor = LoadCursor(nullptr, IDC_ARROW);
    wcex.lpszClassName = "My Window Class";
    RegisterClassEx(&wcex);

    // Create window
    HWND hWnd = CreateWindowEx(0, 
        "My Window Class", 
        "Hello, Luke!", 
        WS_OVERLAPPEDWINDOW, 
        CW_USEDEFAULT, CW_USEDEFAULT, 800, 600, 
        nullptr, nullptr, hInstance, nullptr);
    ShowWindow(hWnd, nCmdShow);

    // Message loop
    MSG msg;
    while (GetMessage(&msg, nullptr, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
    return (int) msg.wParam;
}
*/
