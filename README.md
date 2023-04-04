# Advance Wars in LOVE2D
#### Video Demo: https://www.youtube.com/watch?v=-_ZbTNCRx-0
#### To Play the Game:
It's advance wars. It plays as closely as possible to AdvanceWarsByWeb and the original Game Boy games.<br>
Control is shared between users of the computer the game is running on.<br>
There is unfortunately no online mode or AI.<br>
I would've loved to add them but this project was lengthy enough at it is.<br>

To launch the game:<br>
Take the .love file from the "game" branch and run it!<br>
Alternatively, rename the .love file to .zip and extract the contents to your environment with LOVE2D installed.<br>
Enter the following command to launch:<br>
love . map-name<br>
Examples:<br>
love . FourCorners<br>
love . KeyholeCave<br>
love . TweenIsle<br>

Controls:<br>
Arrow keys to move the cursor<br>
Z to give commands<br>
X to "back out"<br>
Mouse drag to change the map camera<br>
Mouse scroll wheel to zoom in/ zoom out<br>
Escape to exit the game<br>

To make your own maps:<br>
Create a 2D rectangular table of numbers that correspond to key values shown in keys.txt<br>
Assign this table to the variable "Tilemap".<br>
If you want predeployed units, create a table "Unitmap" and fill it out. Each unit is represented by a table in the format:<br>
{unit-name,y-coordinate,x-coordinate,team-value}<br>
where Red = 1, Blue = 2, Yellow = 3, Green = 4, Black = 5<br>
For instance a Blue mech on the space Tilemap[5][2] can be represented as: {Mech,5,2,2}.<br>
Note that the game will only let you place a unit if that team's corresponding headquarters or lab exists on the map.<br>

#### Description:
I have written 3600+ lines of code for this game in the course of 5 weeks.<br>
The game has a working map editor that uses a tile translation algorithm that automatically picks the correct version of the tile type it is given.<br>
Filesystem breakdown is as follows:<br>
Graphics folder houses all the spritemaps<br>
Libraries folder contains the one and only external library for this project, classic.lua which simulates OOP<br>
Maps folder contains all the maps I've created for this release.<br>
Music folder is just unused assets at this time<br>
Units folder contains all Advance Wars units up to Dual Strike including an init file which requires the whole folder and a base class unit file<br>
Border.py, Indexer.py, and Transparent.py are all small python scripts that helped me edit the spritemaps to be usable for the game all from the command line.<br>
Keys.txt shows the identifiers to the tile values you see in each map file.<br>
Linecounter.py and Todo.txt just helped me keep track of my progress when working on this project.<br>
Main.lua is the actual game.<br>
Mapgen.lua generates the map and players at the start of the game.<br>
Menu.lua controls how the menu works and how units respond to commands from the player.<br>
Movement.lua controls how units are allowed to move. (Breath-First Search + A* algorithm)<br>
PriorityQueue.lua is what it says it is.<br>
Test.lua and Test.py are just files where I can test snippets.<br>

Stuff I didn't have time to add to the game that I wanted to do:
Additional control scheme option that allows you to move the cursor with the mouse and the camera with the keyboard.
Fog mechanic that obscures vision outside of your units' "vision range"
Music (Love2Ds default audio module thinks all my mp3s are corrupted and I just could not find any help online and I don't feel like finding another library just to do audio)
Individual COs with their day-to-day abilities, and various CO powers