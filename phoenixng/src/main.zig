const w4 = @import("wasm4.zig");
const std = @import("std");
const sprites = @import("sprites.zig");
const Vec2 = @import("vec2.zig").Vec2;
const random = @import("random.zig");

const screenSize = 160;

const Star = struct {
    pos: Vec2,
    velocity: Vec2,

    pub fn update(self: *Star, speed: f32) void {
        self.pos.add(self.velocity);
        var s = Vec2{ .x = 0, .y = 1 };
        s.multiply(speed);
        self.pos.add(s);
        if (self.pos.y > screenSize) {
            self.restart();
        }
    }

    pub fn init(self: *Star) void {
        self.pos = .{ .x = random.getRandomPos(), .y = random.getRandomPos() };
        self.velocity = .{ .x = 0, .y = random.getRandomVelocity() };
    }

    pub fn restart(self: *Star) void {
        self.pos = .{ .x = random.getRandomPos(), .y = 0 };
    }
};

const Missile = struct {};

var frameCount: u32 = 0;

var stars: [80]Star = undefined;
var global_velocity: f32 = 0;

var missiles: [10]Missile = undefined;

fn init_stars() void {
    for (&stars) |*star| {
        star.init();
    }
}

export fn start() void {
    random.initRandom();
    init_stars();
}

const bgcolor = 3;

var player_pos = Vec2{ .x = screenSize / 2 - sprites.player_width / 2, .y = screenSize - sprites.player_height };

export fn update() void {
    for (w4.FRAMEBUFFER) |*x| {
        x.* = bgcolor | (bgcolor << 2) | (bgcolor << 4) | (bgcolor << 6);
    }

    w4.DRAW_COLORS.* = 0x30;
    for (&stars) |*star| {
        w4.rect(@intFromFloat(star.pos.x), @intFromFloat(star.pos.y), 1, 1);
        star.update(global_velocity);
    }

    frameCount += 1;

    w4.DRAW_COLORS.* = 0x42;
    w4.blit(&sprites.player, @intFromFloat(player_pos.x), @intFromFloat(player_pos.y), sprites.player_width, sprites.player_height, sprites.player_flags);
}
