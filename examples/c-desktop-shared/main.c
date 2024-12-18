#include <raylib.h>

int main() {
    InitWindow(640, 480, "Hello, world!");
    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("Hello, world!", 250, 200, 20, DARKGRAY);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
