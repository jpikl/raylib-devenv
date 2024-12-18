#include <raylib.h>

void GameInit() {
    InitWindow(640, 480, "Hello, world!");
}

void GameUpdate() {
    BeginDrawing();
    ClearBackground(RAYWHITE);
    DrawText("Hello, world!", 250, 200, 20, DARKGRAY);
    EndDrawing();
}

void GameQuit() {
    CloseWindow();
}
