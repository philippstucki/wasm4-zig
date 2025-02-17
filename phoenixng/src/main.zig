const w4 = @import("wasm4.zig");
const std = @import("std");
const sprites = @import("sprites.zig");
const Vec2 = @import("vec2.zig").Vec2;
const random = @import("random.zig");
const starfield = @import("starfield.zig");
const Player = @import("player.zig").Player;

const screenSize = 160;

var frameCount: u32 = 0;
var global_velocity: f32 = 0.2;

export fn start() void {
    random.initRandom();
    starfield.init();
}

const bgcolor = 3;

var player = Player.create();

export fn update() void {
    for (w4.FRAMEBUFFER) |*x| {
        x.* = bgcolor | (bgcolor << 2) | (bgcolor << 4) | (bgcolor << 6);
    }

    w4.DRAW_COLORS.* = 0x30;
    for (&starfield.stars) |*star| {
        w4.rect(@intFromFloat(star.pos.x), @intFromFloat(star.pos.y), 1, 1);
        star.update(global_velocity);
    }

    frameCount += 1;

    w4.DRAW_COLORS.* = 0x42;
    w4.blit(&sprites.player, @intFromFloat(player.pos.x), @intFromFloat(player.pos.y), sprites.player_width, sprites.player_height, sprites.player_flags);
}
