#include <emscripten/emscripten.h>
#include "../common/game.h"

int main() {
    InitGame();
    emscripten_set_main_loop(UpdateGame, 0, 1);
    QuitGame();
    return 0;
}
