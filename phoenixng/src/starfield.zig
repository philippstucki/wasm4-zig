const Vec2 = @import("vec2.zig").Vec2;
const w4 = @import("wasm4.zig");

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
        self.pos = .{ .x = getRandomPos(), .y = getRandomPos() };
        self.velocity = .{ .x = 0, .y = getRandomVelocity() };
    }

    pub fn restart(self: *Star) void {
        self.pos = .{ .x = getRandomPos(), .y = 0 };
    }
};
