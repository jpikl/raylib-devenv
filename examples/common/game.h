#include <raylib.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

Texture2D logo;

void InitGame() {
    InitWindow(640, 480, "Hello, world!");
    ChangeDirectory(GetApplicationDirectory()); // To load assets relative to the game executable
    logo = LoadTexture("raylib.png");
}

bool IsGameRunning() {
    const char* TEST = getenv("TEST");
    if (TEST && !strcmp(TEST, "1")) {
        return false; // Early quit when running test suite
    }
    if (WindowShouldClose()) {
        return false;
    }
    return true;
}

void UpdateGame() {
    BeginDrawing();
    ClearBackground(RAYWHITE);
    DrawTexture(logo, 0, 0, WHITE);
    DrawText("Hello, world!", 250, 200, 20, DARKGRAY);
    EndDrawing();
}

void QuitGame() {
    UnloadTexture(logo);
    CloseWindow();
}
