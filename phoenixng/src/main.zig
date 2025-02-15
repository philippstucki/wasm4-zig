const w4 = @import("wasm4.zig");
const std = @import("std");
const sprites = @import("sprites.zig");

const screenSize = 160;

var prng: std.rand.DefaultPrng = undefined;
var random: std.rand.Random = undefined;

fn Vec2(comptime T: type) type {
    return struct {
        x: T,
        y: T,
        pub fn add(self: *@This(), other: @This()) void {
            self.x += other.x;
            self.y += other.y;
        }

        pub fn multiply(self: *@This(), scalar: T) void {
            self.x *= scalar;
            self.y *= scalar;
        }
    };
}

fn getRandomPos() f32 {
    return random.float(f32) * screenSize;
}

fn getRandomVelocity() f32 {
    return if (random.float(f32) > 0.5) 0.4 else 0.2;
}

const Star = struct {
    pos: Vec2(f32),
    velocity: Vec2(f32),

    pub fn update(self: *Star, speed: f32) void {
        self.pos.add(self.velocity);
        var s = Vec2(f32){ .x = 0, .y = 1 };
        s.multiply(speed);
        self.pos.add(s);
        if (self.pos.y > screenSize) {
            self.restart();
        }
    }

    pub fn init(self: *Star) void {
        self.pos = .{ .x = getRandomPos(), .y = getRandomPos() };
        self.velocity = .{ .x = 0, .y = getRandomVelocity() };
    }

    pub fn restart(self: *Star) void {
        self.pos = .{ .x = getRandomPos(), .y = 0 };
    }
};

var frameCount: u32 = 0;

// var stars: [50]Star =[_]Star{Star{ .pos = .{}, .acceleration = .{}, .velocity = .{} }} ** 50;
var stars: [80]Star = undefined;
var global_velocity: f32 = 0;

fn init_stars() void {
    // *star is used to pass it as *Star
    for (&stars) |*star| {
        star.init();
    }
}

export fn start() void {
    prng = std.rand.DefaultPrng.init(0);
    random = prng.random();

    init_stars();
}

const bgcolor = 3;

var player_pos = Vec2(f32){ .x = screenSize / 2, .y = screenSize - sprites.player_height };

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

    // if (frameCount % 10 == 0) {
    //     global_velocity += 0.11;
    // }
}
