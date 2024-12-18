#include <raylib.h>
#include <emscripten/emscripten.h>
#include "../common/game.h"

int main() {
    GameInit();
    emscripten_set_main_loop(GameUpdate, 0, 1);
    GameQuit();
    return 0;
}
