#include <raylib.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

Texture2D logoTexture;
Sound coinSound;
int clickCounter = 0;
char textBuffer[255];

void InitGame() {
    InitWindow(640, 480, "Hello, world!");
    InitAudioDevice();

    // To load assets relative to the game executable
    ChangeDirectory(GetApplicationDirectory());
    ChangeDirectory("assets");

    logoTexture = LoadTexture("raylib.png");
    coinSound = LoadSound("coin.wav");
}

bool IsGameRunning() {
    const char* TEST = getenv("TEST");
    if (TEST && !strcmp(TEST, "1")) {
        return false; // Early quit when running test suite
    }
    if (WindowShouldClose()) {
        return false;
    }
    if (clickCounter >= 5) {
        return false;
    }
    return true;
}

void QuitGame();

void UpdateGame() {
    if(IsMouseButtonPressed(MOUSE_BUTTON_LEFT) || IsKeyPressed(KEY_SPACE) || IsGestureDetected(GESTURE_TAP))  {
        clickCounter++;
        PlaySound(coinSound);
    }

    snprintf(textBuffer, 255, "Click counter: %d", clickCounter);

    BeginDrawing();
    ClearBackground(RAYWHITE);
    DrawTexture(logoTexture, 0, 0, WHITE);
    DrawText(textBuffer, 230, 200, 20, DARKGRAY);
    EndDrawing();
}

void QuitGame() {
    UnloadTexture(logoTexture);
    UnloadSound(coinSound);
    CloseWindow();
}
