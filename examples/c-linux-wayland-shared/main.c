#include <raylib.h>
#include <stdlib.h>

int main() {
    InitWindow(640, 480, "Hello, world!");
    SetTargetFPS(60);

    // Early quit for when running test suite
    if (getenv("TEST")) {
        CloseWindow();
        return 0;
    }

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);
        DrawText("Hello, world!", 250, 200, 20, DARKGRAY);
        EndDrawing();
    }

    CloseWindow();
    return 0;
}
