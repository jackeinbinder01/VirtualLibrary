# Virtual Library - Java Library Management System

### Prerequisites:
- Python 3.8 or higher
- MySQL Database Server
- Python Libraries:
  - Pymysql
  - Datetime
  - Tabulate
  - PyQt6 package
    - (If install unsuccessful) Windows users need Microsoft Visual C++ 14.0 or greater to build the PyQt6-sip package. If needed, that can be downloaded here: https://visualstudio.microsoft.com/visual-cpp-build-tools/
    - Once installed, select the C++ Build Tools workload and ensure these are selected:
      - MSVC v143 (or higher)- VS 2022 C++ x64/x86 build tools
      - Windows 10 SDK (or higher)
    - After installation, restart your computer and retry the install of PyQt6

### Setting up the database:
- Ensure your MySQL server is running
- Import the database using the dump file provided “virtual_library_db_dump_d2” and execute the script
- All procedures are included in the dump file
