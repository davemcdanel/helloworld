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
    
    for (const std::string& word : msg){
        std::cout << " " << word;
    }

    std::cout << int(function()) << std::endl;
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
