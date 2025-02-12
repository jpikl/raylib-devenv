package main

import "build:app"
import "core:fmt"
import rl "vendor:raylib"

texture: rl.Texture2D
sound: rl.Sound
counter := 0

app :: app.App {
    init   = init,
    update = update,
    quit   = quit,
}

init :: proc() -> bool {
    rl.InitWindow(640, 480, fmt.ctprintf("%s (%s)", app.NAME, app.VERSION))
    rl.InitAudioDevice()

    // To load assets relative to the game executable
    rl.ChangeDirectory(rl.GetApplicationDirectory())
    rl.ChangeDirectory(app.ASSETS_DIR)

    texture = rl.LoadTexture("raylib.png")
    sound = rl.LoadSound("coin.wav")

    rl.IsTextureValid(texture) or_return
    rl.IsSoundValid(sound) or_return

    return true
}

update :: proc() -> bool {
    when !app.IS_WEB {
        if rl.WindowShouldClose() {
            return false
        }
    }

    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.RAYWHITE)
    rl.DrawTexture(texture, 256, 64, rl.WHITE)

    counter_text := fmt.ctprintf("Click counter: %d", counter)

    if rl.GuiButton({220, 256, 200, 64}, counter_text) || rl.IsKeyPressed(.SPACE) {
        rl.PlaySound(sound)
        counter += 1
    }

    if rl.GuiButton({220, 352, 200, 64}, "Close") {
        return false
    }

    return true
}

quit :: proc() {
    rl.UnloadTexture(texture)
    rl.UnloadSound(sound)
    rl.CloseWindow()
}
