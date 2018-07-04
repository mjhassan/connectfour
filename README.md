 <!--  README.md-->
<!--  ConnectFour-->
<!---->
<!--  Created by Jahid Hassan on 5/30/18.-->
<!--  Copyright © 2018 Jahid Hassan. All rights reserved.-->

# iOS Code Challenge 2018
## Connect Four or Four-In-A-Row Game

This is a project created to demonstrate several skills as a interview process. It's a simple "Connect Four" or "Four In a Row" game project.

## Requirements:
### Code Specification
- iPad target
- Swift
- 3rd Party libraries if needed
- Be prepared for testability (On a unit test level)
- Simple UI - You don’t need to focus on the UI part, simple boxes and 2 colors are totally fine you also don’t need to care about animations etc.
- Configure the game by using the data provided at the following endpoint: [company_name](https://private-75c7a5-blinkist.apiary-mock.com/connectFour/configuration). This configuration should be applied for each game.
- The game state should be evaluated by the device

### Game Specification
- 2 Player should play against each other (No computer)
- The board should have a grid layout of 6x7 columns
- The game is finished when either all fields are set or when one of the players have a row of 4 of their color, diagonal, horizontal or vertical.

### Bonus :
- *Think about an Architecture/interface where you could connect an AI game engine to your game and replace a second player with this piece of non existing software. Here as well you don’t need to implement any AI game logic.*
- *If you want to go the extra mile, you can also wow us with some nicer UI than boxes - This is up to you and should not extend the working hours on the task to much.*

## Implementation
- MVVM architectural pattern is used to implement the project. I find it very easy to implement test case or TDD using MVVM.
- Project is workable from iPad (5th Gen) to iPad Pro (12.9 inch); no iPhone support.
- Implemented using Swift 4.1 on Xcode 9.2
- There is only one 3rd Party library, [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD), is intergrate using Cocoapod just to demonstrate 3rd Party integration capability.
- Project is testable. You can use XCTest, which already included in project, or use Quick and Nimble.
- Blinkist service has been implemented to fetch game configuration for each game.
- The project has plugin feture to connect with AI game engine. Implement your game engine to select a column and call `func makeMove(in column: Int)` in `GameViewModel` class. There are couple of changes will be needed to integrte with game engine, but it has ability to be integrated.

## Installation
- Unzip the file and locate using terminal.
- Run `pod install --verbose` to install cocoapod. `--verbose` is just to check what is being installing.
- Double click `ConnectFour.xcworkspace` file to open the project using Xcode.
- Change device or simulator to run on iPad (iPhone will give error alert).
- For any issue please mail @ jahid.hassan.ce@gmail.com
- While you are at it, please visit [my linkedin profile](https://www.linkedin.com/in/mjhassan).

## Acknowledgement
I would like to thank [Hacking With Swift](https://www.hackingwithswift.com/read/34/overview) blog, from which this project got it's initial concept . Also thanks to the [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD) developers for awesome progress hud.
Last but not least, thank you Blinkist for the nice concept of game for interview process.
