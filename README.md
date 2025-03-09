# Readme
# Hello World! - For C++
A C++ edition of the classic "Hello World" program, enhanced with integer addition. This project is designed to test Visual Studio Code (VSCode) with MSYS2 UCRT64 but should compile on most modern C++ environments.
## Features
- Prints "Hello C++ World!" with version information
- Adds two integers (via CLI arguments or interactive input)
- Well-documented with Doxygen support
- Released into the public domain under the Unlicense
## Requirements
- **MSYS2 UCRT64** (recommended for Windows):
  - Install required packages:
    pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain mingw-w64-ucrt-x86_64-autotools
  - Add to PATH:
    C:\msys64\ucrt64\bin
    C:\msys64\usr\bin
  - Verified g++ version: 14.2.0
- **VSCode** with the "C/C++" extension by Microsoft
- **Doxygen** (optional, for generating documentation)
## Setup
1. Clone or download the project to a directory named `helloworld`.
2. Open the `helloworld` folder in VSCode.
3. Ensure MSYS2 paths are in your system PATH as listed above.
## Build
- **Command Line**:
  make all
- **VSCode**:
  - Press `Ctrl+Shift+B` to run the default "Build" task (`make clean all`)
- **Output**: Generates `bin/helloworld.exe`
## Run
- **Command Line**:
  bin/helloworld.exe           # Interactive mode
  bin/helloworld.exe 5 10      # CLI mode
- **VSCode**:
  - Use the "Run" task (add to `tasks.json` if desired)
## Debug
- **VSCode**:
  - Press `F5` to launch with GDB in an external console
  - Supports both interactive and CLI modes (edit `launch.json` for arguments)
## Documentation
- **Generate Doxygen Docs**:
  make docs
- **Output**: Documentation in `docs/` directory
## Test Case: Overflow Checking
To verify the MSYS2 g++ and VSCode setup, the project includes overflow detection in `function(int a, int b)`:
- Returns `std::numeric_limits<int>::max()` with a warning if `a + b` exceeds `INT_MAX`
- Test it:
  bin/helloworld.exe 2147483647 1
This demonstrates standard library support, compilation, and debugging capabilities.
## License
This is free and unencumbered software released into the public domain under the Unlicense. See `LICENSE.md` for details.
### Warranty Disclaimer
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
## Author
David Lee McDanel (<smokepid@gmail.com>, <pidsynccontrol@gmail.com>)

