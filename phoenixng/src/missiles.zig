const Vec2 = @import("vec2.zig").Vec2;
const w4 = @import("wasm4.zig");

pub var missiles: [40]Missile = undefined;
var current_missile: u32 = 0;

pub fn create(pos: Vec2) void {
    const p = &missiles[current_missile];
    current_missile = (current_missile + 1) % missiles.len;
    p.*.active = true;
    // p.*.pos = Vec2{ .x = 50, .y = 50 };
    p.*.pos = pos;
    p.*.velocity = Vec2{ .x = 0, .y = -1.3 };
}

pub const Missile = struct {
    pos: Vec2,
    velocity: Vec2,
    active: bool,

    pub fn update(self: *Missile) void {
        if (self.active) {
            self.pos.add(self.velocity);
        }
    }

    pub fn draw(self: *Missile) void {
        w4.DRAW_COLORS.* = 0x31;
        w4.oval(@intFromFloat(self.pos.x), @intFromFloat(self.pos.y), 3, 3);
    }
};
