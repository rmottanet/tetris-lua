# Tetris Love2D

Welcome to Tetris Love2D\! This project implements a classic arcade-style game where you control falling tetrominoes, aiming to clear lines by forming complete rows. This game is built using Lua and the **LÖVE 2D framework**, providing a simple yet functional example of Tetris mechanics.


## Requirements

To run Tetris Love2D, you need the following:

  * **Lua 5.x:** LÖVE 2D is built on Lua, so a compatible Lua environment is inherently part of the LÖVE 2D installation.
  * **LÖVE 2D:** A free, open-source 2D game framework that handles graphics, audio, input, and other game development necessities.


## Dependencies

Tetris Love2D depends solely on the **LÖVE 2D framework**. No external Lua libraries are explicitly required beyond what LÖVE provides.


## Usage

To run Tetris Love2D, follow these steps:

1.  **Install LÖVE 2D:** Download and install LÖVE 2D from its official website: [https://love2d.org/](https://love2d.org/)

      * For **Windows**, drag the project folder onto `love.exe`.
      * For **macOS**, drag the project folder onto the LÖVE application icon.
      * For **Linux**, navigate to the project's root directory in your terminal and run: `love .`

2.  **Using an AppImage:**
    If you're using a LÖVE AppImage (e.g., `love-11.5.0-x86_64.AppImage`), ensure it's executable and specify its path followed by the project folder's path:

    ```bash
    ./appimage/love-11.5.0-x86_64.AppImage src/
    ```

    Replace `./appimage/love-11.5.0-x86_64.AppImage` with the actual path to your LÖVE AppImage if it's not in the current directory, and `src/` with the path to the `main.lua`'s containing folder if it's not in the current directory.

3.  **Run the Game:**

      * Ensure your project folder is structured as follows:
        ```text
        .
        ├── appimage/
        │   └── love-11.5.0-x86_64.AppImage
        └── src/
            └── main.lua
        ```
      * Execute the game using your LÖVE 2D installation as described above.

Enjoy playing Tetris\!


## Controls

  * **Left/Right Arrow Keys:** Move the current piece horizontally.
  * **Down Arrow Key:** Accelerate the piece's descent.
  * **Up Arrow Key / 'X' Key:** Rotate the current piece.

-----

## Old School Gaming Hub

Tetris Love2D is part of the Old School Gaming Hub organization on GitHub. The **Old School Gaming Hub** is dedicated to developing classic 2D games, primarily focusing on **C++ implementations**, to provide nostalgic gaming experiences for enthusiasts and developers alike. Explore more projects and games from [Old School Gaming Hub](https://www.google.com/search?q=https://github.com/Old-School-Gaming-Hub).

---

Thank you for choosing Tetris Love2D\! If you have any questions, issues, or suggestions, please don't hesitate to reach out. Happy gaming\! 🎮


<br />
<br />
<div align="center">
  <a href="https://bitbucket.org/rmottalabs/"><img alt="Static Badge" src="https://img.shields.io/badge/-Bitbucket?style=social&logo=bitbucket&logoSize=auto&label=Bitbucket&link=https%3A%2F%2Fbitbucket.org%2Frmottalabs%2Fworkspace%2Foverview%2F"></a>
  <a href="https://gitlab.com/rmottanet"><img alt="Static Badge" src="https://img.shields.io/badge/-Gitlab?style=social&logo=gitlab&logoSize=auto&label=Gitlab&link=https%3A%2F%2Fgitlab.com%2Frmottanet"></a>
  <a href="https://github.com/rmottanet"><img alt="Static Badge" src="https://img.shields.io/badge/-Github?style=social&logo=github&logoSize=auto&label=Github&link=https%3A%2F%2Fgithub.com%2Frmottanet"></a>
  <a href="https://hub.docker.com/"><img alt="Static Badge" src="https://img.shields.io/badge/-DockerHub?style=social&logo=docker&logoSize=auto&label=DockerHub&link=https%3A%2F%2Fhub.docker.com%2Fu%2Frmottanet"></a>
</div>
