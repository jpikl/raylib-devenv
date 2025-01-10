package main

import fmt "core:fmt"
import rl "vendor:raylib"
import app "extras:app"

logoTexture: rl.Texture2D
coinSound: rl.Sound
clickCounter := 0

main :: proc() {
    app.run(init, update, quit)
}

init :: proc() -> bool {
    rl.InitWindow(640, 480, fmt.ctprintf("%s (%s)", app.NAME, app.VERSION))
    rl.InitAudioDevice()

    // To load assets relative to the game executable
    rl.ChangeDirectory(rl.GetApplicationDirectory())

    logoTexture = rl.LoadTexture("assets/raylib.png")
    coinSound = rl.LoadSound("assets/coin.wav")

    rl.IsTextureValid(logoTexture) or_return
    rl.IsSoundValid(coinSound) or_return

    return true
}

update :: proc() -> bool {
    if (rl.WindowShouldClose()) {
        return false
    }

    if (rl.IsMouseButtonPressed(.LEFT) || rl.IsKeyPressed(.SPACE) || rl.IsGestureDetected(.TAP)) {
        rl.PlaySound(coinSound)
        clickCounter += 1

        if (clickCounter >= 5) {
            return false
        }
    }

    rl.BeginDrawing()
    rl.ClearBackground(rl.RAYWHITE)
    rl.DrawTexture(logoTexture, 0, 0, rl.WHITE)
    rl.DrawText(fmt.ctprintf("Click counter: %d", clickCounter), 230, 200, 20, rl.DARKGRAY)
    rl.EndDrawing()

    return true
}

quit :: proc() {
    rl.UnloadTexture(logoTexture)
    rl.UnloadSound(coinSound)
    rl.CloseWindow()
}
