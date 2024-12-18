#include <raylib.h>
#include <emscripten/emscripten.h>

void UpdateDrawFrame() {
    BeginDrawing();
    ClearBackground(RAYWHITE);
    DrawText("Hello, world!", 250, 200, 20, DARKGRAY);
    EndDrawing();
}

int main() {
    InitWindow(640, 480, "Hello, world!");
    emscripten_set_main_loop(UpdateDrawFrame, 0, 1);
    CloseWindow();
    return 0;
}
