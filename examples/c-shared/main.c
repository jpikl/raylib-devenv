#include <raylib.h>
#include "../common/game.h"

int main() {
    GameInit();

    while (!WindowShouldClose()) {
        GameUpdate();
    }

    GameQuit();
    return 0;
}
