const Vec2 = @import("vec2.zig").Vec2;
const w4 = @import("wasm4.zig");
const random = @import("random.zig");

pub var stars: [80]Star = undefined;

pub fn init() void {
    for (&stars) |*star| {
        star.init();
    }
}

pub const Star = struct {
    pos: Vec2,
    velocity: Vec2,

    pub fn update(self: *Star, speed: f32) void {
        self.pos.add(self.velocity);
        var s = Vec2{ .x = 0, .y = 1 };
        s.multiply(speed);
        self.pos.add(s);
        if (self.pos.y > w4.SCREEN_SIZE) {
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
