const w4 = @import("wasm4.zig");
const std = @import("std");
const sprites = @import("sprites.zig");
const Vec2 = @import("vec2.zig").Vec2;
const random = @import("random.zig");
const starfield = @import("starfield.zig");
const Player = @import("player.zig").Player;
const missiles = @import("missiles.zig");

const screenSize = 160;

var frameCount: i32 = 0;
var global_velocity: f32 = 0.2;
var missileCoolDown: i32 = 0;

export fn start() void {
    // w4.PALETTE[0] = 0xf8e3c4;
    // w4.PALETTE[1] = 0xcc3495;
    // w4.PALETTE[2] = 0x203671;
    // w4.PALETTE[3] = 0x0b0630;

    random.initRandom();
    starfield.init();
}

const bgcolor = 3;

var player = Player.create();

export fn update() void {
    const gamepad = w4.GAMEPAD1.*;

    // bg
    w4.DRAW_COLORS.* = 0x04;
    w4.rect(0, 0, w4.SCREEN_SIZE, w4.SCREEN_SIZE);

    // starfield
    w4.DRAW_COLORS.* = 0x30;
    for (&starfield.stars) |*star| {
        star.draw();
        star.update(global_velocity);
    }

    // player
    player.update();
    player.draw();

    // missiles
    if (gamepad & w4.BUTTON_1 != 0 and missileCoolDown == 0) {
        missileCoolDown = 7;
        missiles.create(player.pos);
    }
    missileCoolDown -= 1;
    if (missileCoolDown < 0) missileCoolDown = 0;
    for (&missiles.missiles) |*missile| {
        missile.update();
        missile.draw();
    }

    frameCount += 1;
}
