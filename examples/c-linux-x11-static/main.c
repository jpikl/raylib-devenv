#include "../common/game.h"

int main() {
    InitGame();
    while (IsGameRunning()) UpdateGame();
    QuitGame();
    return 0;
}
