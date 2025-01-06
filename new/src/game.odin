package main

import fmt "core:fmt"
import os "core:os"
import rl "vendor:raylib"

GAME_CODE :: #config(GAME_CODE, "Unknown")
GAME_NAME :: #config(GAME_NAME, "unknown")
GAME_VERSION :: #config(GAME_VERSION, "unknown")

logoTexture: rl.Texture2D
coinSound: rl.Sound
clickCounter := 0

init :: proc() -> bool {
    rl.InitWindow(640, 480, fmt.ctprintf("%s (%s)", GAME_NAME, GAME_VERSION))
    rl.InitAudioDevice()

    // To load assets relative to the game executable
    rl.ChangeDirectory(rl.GetApplicationDirectory())

    logoTexture = rl.LoadTexture("assets/raylib.png")
    coinSound = rl.LoadSound("assets/coin.wav")

    rl.IsTextureValid(logoTexture) or_return
    rl.IsSoundValid(coinSound) or_return

    return true
}

is_running :: proc() -> bool {
    if os.get_env("TEST") != "" {
        return false // Early quit when running test suite
    }
    if (rl.WindowShouldClose()) {
        return false
    }
    if (clickCounter >= 5) {
        return false
    }
    return true
}

update :: proc() {
    if (rl.IsMouseButtonPressed(rl.MouseButton.LEFT) ||
           rl.IsKeyPressed(rl.KeyboardKey.SPACE) ||
           rl.IsGestureDetected(rl.Gesture.TAP)) {
        clickCounter += 1
        rl.PlaySound(coinSound)
    }

    rl.BeginDrawing()
    rl.ClearBackground(rl.RAYWHITE)
    rl.DrawTexture(logoTexture, 0, 0, rl.WHITE)
    rl.DrawText(fmt.ctprintf("Click counter: %d", clickCounter), 230, 200, 20, rl.DARKGRAY)
    rl.EndDrawing()

    free_all(context.temp_allocator)
}

quit :: proc() {
    rl.UnloadTexture(logoTexture)
    rl.UnloadSound(coinSound)
    rl.CloseWindow()
}
