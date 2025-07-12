# SpeedrunKit Command Manual

This manual contains all available commands for building, testing, and using SpeedrunKit with their outputs.

## Table of Contents

- [Building Commands](#building-commands)
- [Testing Commands](#testing-commands)
- [CLI Commands](#cli-commands)
- [Documentation Commands](#documentation-commands)
- [Docker Commands](#docker-commands)
- [Package Management](#package-management)
- [Git Operations](#git-operations)

---

## Building Commands

<details>
<summary>🔨 Basic Build</summary>

```bash
swift build
```

**Output:**
```
[1/1] Compiling plugin Swift-DocC Preview
[2/2] Compiling plugin Swift-DocC
Building for debugging...
[2/9] Write sources
[4/9] Write swift-version-5BD8B568FD16BF8B.txt
[6/54] Compiling SpeedrunKit Genre.swift
[7/54] Compiling SpeedrunKit Leaderboard.swift
...
[58/59] Linking speedrun-cli
Build complete! (9.20s)
```

</details>

<details>
<summary>🔨 Build with Verbose Output</summary>

```bash
swift build -v
```

Shows detailed compilation steps and flags used by the Swift compiler.

</details>

<details>
<summary>🔨 Build Release Version</summary>

```bash
swift build -c release
```

Builds optimized release binaries without debug symbols.

</details>

<details>
<summary>🔨 Build Specific Product</summary>

```bash
swift build --product SpeedrunKit
swift build --product speedrun-cli
```

Builds only the specified product (library or executable).

</details>

<details>
<summary>🔨 Build CLI Tool for Release</summary>

```bash
swift build --product speedrun-cli -c release
```

**Output:**
```
Building for production...
[0/5] Write sources
[2/5] Write swift-version-5BD8B568FD16BF8B.txt
[4/6] Compiling SpeedrunKit CategoriesAPI.swift
[5/7] Compiling SpeedrunCLI main.swift
[5/7] Write Objects.LinkFileList
[6/7] Linking speedrun-cli
Build of product 'speedrun-cli' complete! (5.61s)
```

</details>

<details>
<summary>🔨 Clean Build</summary>

```bash
swift package clean
swift build
```

Removes all build artifacts and rebuilds from scratch.

</details>

---

## Testing Commands

<details>
<summary>🧪 Run All Tests</summary>

```bash
swift test
```

**Output:**
```
[0/1] Planning build
[1/1] Compiling plugin Swift-DocC Preview
[2/2] Compiling plugin Swift-DocC
Building for debugging...
...
Test Suite 'All tests' started at 2025-07-08 15:43:50.174
Test Suite 'debug.xctest' started at 2025-07-08 15:43:50.177
Test Suite 'AssetTests' started at 2025-07-08 15:43:50.177
Test Case 'AssetTests.testDecoding' started at 2025-07-08 15:43:50.177
Test Case 'AssetTests.testDecoding' passed (0.0 seconds)
...
Test Suite 'All tests' passed at 2025-07-08 15:43:50.381
	 Executed 40 tests, with 0 failures (0 unexpected) in 0.204 (0.204) seconds
◇ Test run started.
↳ Testing Library Version: 5.9 (swift-5.9-RELEASE)
↳ Target Platform: x86_64-unknown-linux-gnu
✔ Test run with 0 tests passed after 0.001 seconds.
```

</details>

<details>
<summary>🧪 Run Tests with Verbose Output</summary>

```bash
swift test -v
```

Shows detailed test execution with compiler flags and individual test progress.

</details>

<details>
<summary>🧪 Run Specific Test Suite</summary>

```bash
swift test --filter SpeedrunKitTests.NamesTests
```

Runs only tests matching the specified filter pattern.

</details>

<details>
<summary>🧪 Run Tests in Parallel</summary>

```bash
swift test --parallel
```

Executes test suites in parallel for faster execution.

</details>

<details>
<summary>🧪 Generate Test Coverage</summary>

```bash
swift test --enable-code-coverage
```

Generates code coverage data that can be analyzed with tools like `xcov` or `llvm-cov`.

</details>

<details>
<summary>🧪 List Available Tests</summary>

```bash
swift test --list-tests
```

Lists all available test cases without running them.

</details>

---

## SpeedrunKit CLI

### Overview

The `speedrun-cli` is a fully featured command-line application that uses the SpeedrunKit SDK to interact with the speedrun.com API. It provides comprehensive access to games, users, leaderboards, runs, and more.

### Command Structure

```
speedrun-cli [global-options] <command> [command-options]
```

### Global Options

```bash
--api-key <key>      # API key for authenticated requests
--format <format>    # Output format: table, json, csv (default: table)
--no-color          # Disable colored output
--quiet             # Suppress non-essential output
--debug             # Enable debug logging
--help, -h          # Show help information
--version, -v       # Show version information
```

### Building the CLI

<details>
<summary>🔨 Build CLI Tool</summary>

**Build release version:**
```bash
swift build --product speedrun-cli -c release
```

**Build debug version:**
```bash
swift build --product speedrun-cli
```

</details>

### Installation

<details>
<summary>💻 Install CLI System-wide</summary>

```bash
# Build release version
swift build --product speedrun-cli -c release

# Copy to /usr/local/bin (requires sudo)
sudo cp .build/release/speedrun-cli /usr/local/bin/speedrun-cli

# Or copy to user's bin directory
mkdir -p ~/.local/bin
cp .build/release/speedrun-cli ~/.local/bin/speedrun-cli

# Add to PATH if using ~/.local/bin
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

After installation, you can run the CLI from anywhere:
```bash
speedrun-cli --help
```

</details>

### Main Commands

<details>
<summary>💻 Help Command</summary>

**Command:**
```bash
speedrun-cli --help
```

**Output:**
```
speedrun-cli - SpeedrunKit Command Line Interface

USAGE:
    speedrun-cli [global-options] <command> [command-options]

GLOBAL OPTIONS:
    --api-key <key>      API key for authenticated requests
    --format <format>    Output format: table, json, csv (default: table)
    --no-color          Disable colored output
    --quiet             Suppress non-essential output
    --debug             Enable debug logging
    --help, -h          Show help information
    --version, -v       Show version information

COMMANDS:
    games           Manage and search games
    help            Show help information
    leaderboards    View game and level leaderboards
    runs            Manage speedrun submissions
    search          Search across games, users, and series
    series          Browse game series
    test            Run SDK test suite
    users           Manage users and view profiles
    version         Show version information

Run 'speedrun-cli <command> --help' for more information on a command.
```

</details>

<details>
<summary>💻 Version Command</summary>

**Command:**
```bash
speedrun-cli version
```

**Output:**
```
speedrun-cli version 1.0.0
SpeedrunKit SDK version 1.0.0
Swift version 5.9
```

</details>

### Games Commands

<details>
<summary>📦 List Games</summary>

**Command:**
```bash
speedrun-cli games list --max 5
```

**Output:**
```
ID       | Name                                  | Abbreviation                         | Released
--------------------------------------------------------------------------------------------------
pdv9v5k1 |  Alex Kidd 3 - Curse in Miracle World | _Alex_Kidd_3__Curse_in_Miracle_World | Yes     
v1plx046 |  Battle Mania                         | _Battle_Mania                        | Yes     
o1y32j26 |  Bike Unchained 2                     | _bike_unchained_2                    | Yes     
y65rm041 |  BIRDIE WING -Golf Girls' Story-      | _birdie_wing_golf_girls_story        | Yes     
j1n4pkx6 |  Body by Milk Race and Refuel         | bbmrr                                | Yes     

Showing 5 games (offset: 0)
```

**With JSON format:**
```bash
speedrun-cli --format json games list --max 2
```

**Output:**
```json
{
  "data" : [
    {
      "abbreviation" : "_Alex_Kidd_3__Curse_in_Miracle_World",
      "id" : "pdv9v5k1",
      "names" : {
        "international" : " Alex Kidd 3 - Curse in Miracle World"
      },
      "released" : 2021,
      "weblink" : "https://www.speedrun.com/_Alex_Kidd_3__Curse_in_Miracle_World"
    },
    {
      "abbreviation" : "_Battle_Mania",
      "id" : "v1plx046",
      "names" : {
        "international" : " Battle Mania"
      },
      "released" : 1991,
      "weblink" : "https://www.speedrun.com/_Battle_Mania"
    }
  ],
  "pagination" : {
    "max" : 2,
    "offset" : 0,
    "size" : 2
  }
}
```

**With CSV format:**
```bash
speedrun-cli --format csv games list --max 3
```

**Output:**
```csv
id,name,abbreviation,released,weblink
"pdv9v5k1"," Alex Kidd 3 - Curse in Miracle World","_Alex_Kidd_3__Curse_in_Miracle_World","Yes","https://www.speedrun.com/_Alex_Kidd_3__Curse_in_Miracle_World"
"v1plx046"," Battle Mania","_Battle_Mania","Yes","https://www.speedrun.com/_Battle_Mania"
"o1y32j26"," Bike Unchained 2","_bike_unchained_2","Yes","https://www.speedrun.com/_bike_unchained_2"
```

</details>

<details>
<summary>📦 Get Game Details</summary>

**Command:**
```bash
speedrun-cli games get sm64
```

**Output:**
```
Game: Super Mario 64
ID: o1y9wo6q
Abbreviation: sm64
Release Date: 23 Jun 1996
Platforms: w89rwelk, nzelreqp, v06dr394, 7m6ylw9p
Weblink: https://www.speedrun.com/sm64

Moderators:
  - 8q316z7j: moderator
  - 8q34l9oj: moderator
  - 8q3dqn7j: moderator
  - xyld2znj: moderator
  - zx7gkrx7: super-moderator
  - j4232gmx: moderator
  - 8l0nq548: moderator
  - kjp9nvk8: moderator
  - 8lpgwllj: moderator
  - jm6o02e8: moderator
  - 8e6k1loj: moderator
  - zx71oy0x: moderator
  - j2w1w5lj: moderator
  - 8qrv5k0j: moderator
```

</details>

<details>
<summary>📦 Get Game Categories</summary>

**Command:**
```bash
speedrun-cli games categories sm64
```

**Output:**
```
ID       | Name      | Type      | Misc
---------------------------------------
zdnq4oqd | Stage RTA | per-level | No  
wkpoo02r | 120 Star  | per-game  | No  
7dgrrxk4 | 70 Star   | per-game  | No  
n2y55mko | 16 Star   | per-game  | No  
7kjpp4k3 | 1 Star    | per-game  | No  
xk9gg6d0 | 0 Star    | per-game  | No
```

</details>

<details>
<summary>📦 Search Games</summary>

**Command:**
```bash
speedrun-cli games search mario --max 5
```

**Output:**
```
ID       | Name                    | Released
--------------------------------------------
4d74n31e | Mario Sports Mix        | Yes     
pdvqek6w | MARIO                   | Yes     
4d7nrxn6 | Mario.exe               | Yes     
4d74xld7 | Cat Mario               | Yes     
pd0wvj31 | SUPER MARIO 3D BOWLING  | Yes     

Showing 5 games
```

</details>

### User Commands

<details>
<summary>👤 Get User Profile</summary>

**Command:**
```bash
speedrun-cli users get cheese05
```

**Output:**
```
User: cheese05
ID: v815d1pj
Role: user
Weblink: https://www.speedrun.com/user/cheese05
Member Since: 1 Nov 2018
```

</details>

<details>
<summary>👤 Get User Personal Bests</summary>

**Command:**
```bash
speedrun-cli users pbs cheese05 --top 5
```

**Output:**
```
Place | Game     | Category | Time       
-----------------------------------------
#1    | o1y9wo6q | n2y55mko | PT14M41S   
#1    | o1y9wo6q | 7kjpp4k3 | PT7M21.290S
#1    | o1y9wo6q | xk9gg6d0 | PT6M27.380S
#2    | o1y9wo6q | 7dgrrxk4 | PT48M19S   
#3    | o1y9wo6q | wkpoo02r | PT1H39M20S
```

</details>

<details>
<summary>👤 Search Users</summary>

**Command:**
```bash
speedrun-cli users search --name mario --max 5
```

**Output:**
```
ID       | Name              | Role
----------------------------------
qxkmd76j | mario             | user
x725kpy8 | mario_            | user
8l3wepr8 | MARIO_0141        | user
8rveepp8 | Mario1            | user
j8lmd4nj | Mario10           | user
```

</details>

### Leaderboard Commands

<details>
<summary>🏆 View Game Leaderboard</summary>

**Command:**
```bash
speedrun-cli leaderboards game sm64 n2y55mko --top 5
```

**Output:**
```
Place | Player  | Time        | Date      
------------------------------------------
#1    | Unknown | 14m 35.500s | 22/03/2023
#2    | Unknown | 14m 41.210s | 21/11/2023
#3    | Unknown | 14m 45.210s | 18/01/2024
#4    | Unknown | 14m 52s     | 06/07/2022
#5    | Unknown | 14m 53.400s | 30/07/2024
```

**Note:** Player names show as "Unknown" because embeds are disabled to avoid API errors.

</details>

### Run Commands

<details>
<summary>🏃 List Recent Runs</summary>

**Command:**
```bash
speedrun-cli runs list --max 5
```

**Output:**
```
ID       | Game     | Player  | Time    | Status  
--------------------------------------------------
1wzpqgyq | nj1ne1p4 | Unknown | 21m 52s | rejected
opydqjmn | nj1ne1p4 | Unknown | 22m     | rejected
onz139me | nj1ne1p4 | Unknown | 22m 28s | rejected
6n3r4xye | nj1ne1p4 | Unknown | 23m 52s | rejected
q8zp0enx | nj1ne1p4 | Unknown | 24m 14s | rejected

Showing 5 runs (offset: 0)
```

</details>

<details>
<summary>🏃 Filter Runs by Status</summary>

**Command:**
```bash
speedrun-cli runs list --status verified --max 3
```

**Output:**
```
ID       | Game     | Player  | Time      | Status   
----------------------------------------------------
6n31d1ye | 4d74xld7 | Unknown | 33.550s   | verified
xzn3e9op | 4d74xld7 | Unknown | 22.860s   | verified
xzn3eq1p | 4d74xld7 | Unknown | 20.510s   | verified

Showing 3 runs (offset: 0)
```

</details>

### Series Commands

<details>
<summary>🎯 List Series</summary>

**Command:**
```bash
speedrun-cli series list --max 5
```

**Output:**
```
ID       | Name                   | Abbreviation          
----------------------------------------------------------
q4zpejvn |  Senko no Ronde Series | _Senko_no_Ronde_Series
8nwjpj7y | .hack//                | .hack                 
m72kkx17 | 10 Gnomes              | 10_gnomes             
3dxk9exy | 1080°                  | 1080                  
3dxkqezy | 16 Ways to Kill...     | 16waystokill          

Showing 5 series (offset: 0)
```

</details>

<details>
<summary>🎯 Get Series Details</summary>

**Command:**
```bash
speedrun-cli series get mario
```

**Output:**
```
Series: Mario
ID: rv7emz49
Abbreviation: mario
Weblink: https://www.speedrun.com/mario
Created: 12 Jul 2014

Moderators:
  - 48gkve1j: moderator
```

</details>

<details>
<summary>🎯 List Games in Series</summary>

**Command:**
```bash
speedrun-cli series games mario --max 5
```

**Output:**
```
ID       | Name                                  | Released
---------------------------------------------------------
pdv0vl7d | Dr. Mario (Game Boy)                  | Yes     
jdz55j1p | Dr. Mario (NES/Famicom)               | Yes     
4pd04ll6 | Dr. Mario 64                          | Yes     
yd43w0g6 | Dr. Mario Express                     | Yes     
268n62ld | Dr. Mario Online Rx                   | Yes     

Showing 5 games (offset: 0)
```

</details>

### Search Commands

<details>
<summary>🔍 Global Search</summary>

**Command:**
```bash
speedrun-cli search mario --max 3
```

**Output:**
```
=== GAMES ===
ID       | Name      | Released
-------------------------------
pdvqek6w | MARIO     | Yes     
4d7nrxn6 | Mario.exe | Yes     
4d74xld7 | Cat Mario | Yes     

=== USERS ===
ID       | Name       | Role
----------------------------
qxkmd76j | mario      | user
x725kpy8 | mario_     | user
8l3wepr8 | MARIO_0141 | user

=== SERIES ===
No series found
```

</details>

<details>
<summary>🔍 Search with Type Filter</summary>

**Command:**
```bash
speedrun-cli search mario --type games --max 5
```

**Output:**
```
ID       | Name      | Released
-------------------------------
pdvqek6w | MARIO     | Yes     
4d7nrxn6 | Mario.exe | Yes     
4d74xld7 | Cat Mario | Yes     
pd0wvj31 | SUPER MARIO 3D BOWLING | Yes     
v1pojo5d | Mario & Sonic at the Olympic Games | Yes
```

</details>

### Test Command

<details>
<summary>🧪 Run SDK Test Suite</summary>

**Command:**
```bash
speedrun-cli test
```

**Output:**
```
🏃 Running SpeedrunKit Test Suite
=================================

Starting API tests...

📦 Testing Games API...
  • Listing games...
    Found 5 games
    First game:  Alex Kidd 3 - Curse in Miracle World
  • Getting game details...
    Game:  Alex Kidd 3 - Curse in Miracle World
    Released: Yes
  • Getting game categories...
    Found 1 categories
  • Getting game levels...
    Found 0 levels
  • Getting game variables...
    Found 0 variables
  • Testing game search...
    Found 3 games matching 'Mario'
  ✓ Games API tests passed

🏷️ Testing Categories API...
  • Getting category details...
    Category: Any%
    Type: per-game
  • Getting category variables...
    Found 0 variables
  ✓ Categories API tests passed

[... continues for all APIs ...]

✅ All tests completed successfully!
```

</details>

### Output Formats

<details>
<summary>📄 Table Format (Default)</summary>

```bash
speedrun-cli games list --max 3
```

**Output:**
```
ID       | Name                                  | Abbreviation                         | Released
--------------------------------------------------------------------------------------------------
pdv9v5k1 |  Alex Kidd 3 - Curse in Miracle World | _Alex_Kidd_3__Curse_in_Miracle_World | Yes     
v1plx046 |  Battle Mania                         | _Battle_Mania                        | Yes     
o1y32j26 |  Bike Unchained 2                     | _bike_unchained_2                    | Yes
```

</details>

<details>
<summary>📄 JSON Format</summary>

```bash
speedrun-cli --format json users get cheese05
```

**Output:**
```json
{
  "hitbox" : null,
  "id" : "v815d1pj",
  "links" : [
    {
      "rel" : "self",
      "uri" : "https://www.speedrun.com/api/v1/users/v815d1pj"
    },
    {
      "rel" : "runs",
      "uri" : "https://www.speedrun.com/api/v1/runs?user=v815d1pj"
    },
    {
      "rel" : "games",
      "uri" : "https://www.speedrun.com/api/v1/games?moderator=v815d1pj"
    },
    {
      "rel" : "personal-bests",
      "uri" : "https://www.speedrun.com/api/v1/users/v815d1pj/personal-bests"
    }
  ],
  "location" : null,
  "names" : {
    "international" : "cheese05",
    "japanese" : null
  },
  "role" : "user",
  "signup" : "2018-11-01T02:00:38Z",
  "speedrunslive" : "",
  "twitch" : null,
  "twitter" : null,
  "weblink" : "https://www.speedrun.com/user/cheese05",
  "youtube" : null
}
```

</details>

<details>
<summary>📄 CSV Format</summary>

```bash
speedrun-cli --format csv series list --max 3
```

**Output:**
```csv
id,name,abbreviation,weblink
"q4zpejvn"," Senko no Ronde Series","_Senko_no_Ronde_Series","https://www.speedrun.com/_Senko_no_Ronde_Series"
"8nwjpj7y",".hack//",".hack","https://www.speedrun.com/.hack"
"m72kkx17","10 Gnomes","10_gnomes","https://www.speedrun.com/10_gnomes"
```

</details>

### Common Usage Patterns

<details>
<summary>💡 Finding and Viewing a Game's Leaderboard</summary>

```bash
# 1. Search for the game
speedrun-cli games search "Super Mario 64" --max 5

# 2. Get game details and categories
speedrun-cli games get sm64
speedrun-cli games categories sm64

# 3. View the 16 Star leaderboard
speedrun-cli leaderboards game sm64 n2y55mko --top 10
```

</details>

<details>
<summary>💡 Checking a User's Profile and Records</summary>

```bash
# 1. Get user profile
speedrun-cli users get cheese05

# 2. View their personal bests
speedrun-cli users pbs cheese05 --top 10

# 3. See their recent runs
speedrun-cli users runs cheese05 --max 10
```

</details>

<details>
<summary>💡 Exploring a Game Series</summary>

```bash
# 1. Find the series
speedrun-cli search zelda --type series

# 2. Get series details
speedrun-cli series get zelda

# 3. List all games in the series
speedrun-cli series games zelda --max 20
```

</details>

<details>
<summary>💡 Working with Different Output Formats</summary>

```bash
# Get JSON for processing with jq
speedrun-cli --format json games get sm64 | jq '.names.international'

# Export to CSV for spreadsheets
speedrun-cli --format csv games list --max 100 > games.csv

# Pipe table output to grep
speedrun-cli users search --name mario | grep -i "super"
```

</details>

### Environment Variables

<details>
<summary>⚙️ CLI Configuration</summary>

The CLI respects the following environment variables:

```bash
# API key for authenticated endpoints
export SPEEDRUN_API_KEY="your-api-key"

# Default output format
export SPEEDRUN_FORMAT="json"

# Disable colored output
export SPEEDRUN_NO_COLOR="true"

# Request timeout in seconds
export SPEEDRUN_REQUEST_TIMEOUT="60"

# Enable debug logging
export SPEEDRUN_DEBUG="true"
```

Usage example:
```bash
# Set API key for session
export SPEEDRUN_API_KEY="your-key-here"

# Now all commands will use this key
speedrun-cli profile get
speedrun-cli profile notifications
```

</details>

### Troubleshooting

<details>
<summary>🔧 Common Issues</summary>

**Rate Limit Errors:**
If you encounter rate limit errors, the SDK will automatically retry with exponential backoff. For heavy usage, add delays between requests or reduce the page size.

**Authentication Errors:**
Some endpoints require authentication. Set the `SPEEDRUN_API_KEY` environment variable or use the `--api-key` flag:
```bash
speedrun-cli --api-key YOUR_KEY profile get
```

**Empty Results:**
Some games/categories may have no data. Try different search terms or check the game ID on speedrun.com.

**Player Names Show as "Unknown":**
This happens when embeds are disabled. The CLI currently doesn't use embeds to avoid API errors with certain endpoints.

</details>

---

## Documentation Commands

<details>
<summary>📚 Generate Documentation</summary>

```bash
swift package generate-documentation --target SpeedrunKit
```

**Output:**
```
Building for debugging...
[0/9] Write sources
[3/9] Write swift-version-5BD8B568FD16BF8B.txt
[5/11] Emitting module Snippets
[6/12] Wrapping AST for Snippets for debugging
[8/12] Emitting module SymbolKit
[9/13] Wrapping AST for SymbolKit for debugging
...
Building documentation for 'SpeedrunKit'...
Finished building documentation for 'SpeedrunKit' (0.56s)
Generated documentation archive at:
  /home/marcus/Dev/swift/SpeedrunKit/.build/plugins/Swift-DocC/outputs/SpeedrunKit.doccarchive
```

</details>

<details>
<summary>📚 Generate Static Documentation Website</summary>

```bash
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target SpeedrunKit \
    --output-path ./docs \
    --transform-for-static-hosting \
    --hosting-base-path SpeedrunKit
```

Generates a static website suitable for GitHub Pages hosting.

</details>

<details>
<summary>📚 Preview Documentation Locally</summary>

```bash
swift package --disable-sandbox preview-documentation --target SpeedrunKit
```

Opens documentation in your browser with live reloading.

</details>

---

## Docker Commands

### Overview

SpeedrunKit provides comprehensive Docker support for containerized development, testing, and deployment.

### Docker Images

<details>
<summary>🐳 Build Docker Image</summary>

```bash
docker build -t speedrunkit .
```

**Output:**
```
[+] Building 45.2s (18/18) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load .dockerignore
 => [internal] load metadata for docker.io/library/swift:5.9-jammy
 => [builder 1/9] FROM docker.io/library/swift:5.9-jammy
 => [internal] load build context
 => CACHED [builder 2/9] RUN apt-get update && apt-get install -y libcurl4-openssl-dev
 => [builder 3/9] WORKDIR /build
 => [builder 4/9] COPY Package.swift Package.resolved ./
 => [builder 5/9] RUN swift package resolve
 => [builder 6/9] COPY Sources ./Sources
 => [builder 7/9] COPY Tests ./Tests
 => [builder 8/9] RUN swift build -c release
 => [builder 9/9] RUN swift test
 => [runtime 1/4] RUN apt-get update && apt-get install -y libcurl4
 => [runtime 2/4] WORKDIR /app
 => [runtime 3/4] COPY --from=builder /build/.build/release/speedrun-cli /app/
 => [runtime 4/4] COPY --from=builder /usr/lib/swift/linux/*.so* /usr/lib/
 => exporting to image
 => => exporting layers
 => => writing image sha256:abc123...
 => => naming to docker.io/library/speedrunkit
```

</details>

<details>
<summary>🐳 Run Docker Container</summary>

```bash
# Run CLI tool
docker run --rm speedrunkit

# Run with API key
docker run --rm -e SPEEDRUN_API_KEY="your-key" speedrunkit

# Run specific command
docker run --rm speedrunkit games list --max 5

# Run interactive shell
docker run --rm -it speedrunkit /bin/bash
```

</details>

<details>
<summary>🐳 Docker Compose Commands</summary>

```bash
# Build the project
docker-compose run --rm dev

# Run tests
docker-compose run --rm test

# Run CLI tool
docker-compose run --rm cli

# Generate documentation
docker-compose run --rm docs

# Run with custom command
docker-compose run --rm dev swift build --product SpeedrunKit
```

</details>

---

## Package Management

<details>
<summary>📦 Update Dependencies</summary>

```bash
swift package update
```

Updates all package dependencies to their latest compatible versions.

</details>

<details>
<summary>📦 Resolve Dependencies</summary>

```bash
swift package resolve
```

Resolves package dependencies without building.

</details>

<details>
<summary>📦 Show Dependencies</summary>

```bash
swift package show-dependencies
```

**Output:**
```
.
└── swift-docc-plugin<https://github.com/swiftlang/swift-docc-plugin@1.4.5>
    └── swift-docc-symbolkit<https://github.com/swiftlang/swift-docc-symbolkit@1.0.0>
```

</details>

<details>
<summary>📦 Reset Package</summary>

```bash
swift package reset
```

Removes all build products and dependencies.

</details>

---

## Git Operations

<details>
<summary>🔧 Create and Push to GitHub</summary>

```bash
# Create repository on GitHub first, then:
git remote add origin https://github.com/guitaripod/SpeedrunKit.git
git branch -M main
git push -u origin main
```

</details>

<details>
<summary>🔧 Tag a Release</summary>

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag to remote
git push origin v1.0.0

# Push all tags
git push --tags
```

</details>

---

## Additional Commands

<details>
<summary>🛠️ Swift Version Info</summary>

```bash
swift --version
```

**Output:**
```
Swift version 5.9 (swift-5.9-RELEASE)
Target: x86_64-unknown-linux-gnu
```

</details>

<details>
<summary>🛠️ Package Tools Version</summary>

```bash
swift package tools-version
```

**Output:**
```
5.9
```

</details>

---

## Troubleshooting

<details>
<summary>❓ Common Issues and Solutions</summary>

### Build Errors

**Issue:** `error: missing required module 'FoundationNetworking'`
**Solution:** This occurs on Linux. The code already handles this with conditional imports.

### API Errors

**Issue:** Rate limit exceeded
**Solution:** The SDK handles rate limits automatically with retries. For heavy usage, add delays between requests.

**Issue:** Authentication required
**Solution:** Set the `SPEEDRUN_API_KEY` environment variable or pass it with the `--api-key` flag.

**Issue:** Player names show as "Unknown" in leaderboards
**Solution:** This is because embeds are currently disabled to avoid API decoding errors. The player IDs are still available in the run data.

### Docker Issues

**Issue:** `permission denied` errors
**Solution:** Run Docker commands with `sudo` or add your user to the docker group:
```bash
sudo usermod -aG docker $USER
```

</details>

---

## Performance Tips

<details>
<summary>⚡ Optimization Commands</summary>

### Build Performance

```bash
# Use release mode for production
swift build -c release

# Enable whole module optimization
swift build -c release -Xswiftc -O -Xswiftc -whole-module-optimization

# Use parallel builds
swift build --jobs 8
```

### Test Performance

```bash
# Run tests in parallel
swift test --parallel

# Skip slow tests
swift test --skip "SlowTests"
```

### Docker Performance

```bash
# Use BuildKit for faster builds
DOCKER_BUILDKIT=1 docker build -t speedrunkit .

# Use cache mounts
docker build --build-arg BUILDKIT_INLINE_CACHE=1 -t speedrunkit .
```

</details>

---

## Quick Reference

<details>
<summary>📋 Command Cheatsheet</summary>

```bash
# Building
swift build                           # Debug build
swift build -c release               # Release build
swift build --product speedrun-cli   # Build specific product

# Testing
swift test                           # Run all tests
swift test --filter NamesTests       # Run specific tests
swift test --parallel                # Parallel execution

# Documentation
swift package generate-documentation --target SpeedrunKit

# Docker
docker build -t speedrunkit .        # Build image
docker run --rm speedrunkit          # Run container
docker-compose run --rm test         # Run tests in Docker

# Package Management
swift package update                 # Update dependencies
swift package resolve                # Resolve dependencies
swift package clean                  # Clean build

# CLI Usage
speedrun-cli --help                  # Show help
speedrun-cli games list              # List games
speedrun-cli users get username      # Get user profile
speedrun-cli search "query"          # Search all resources
```

</details>

---

## Contributing

For contributing guidelines, please see the main [README.md](README.md#contributing) file.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.