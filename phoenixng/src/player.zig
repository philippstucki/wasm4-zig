const Vec2 = @import("vec2.zig").Vec2;

pub const Player = struct {
    pos: Vec2,
    pub fn update(self: *@This(), direction: Vec2) void {
        self.pos.add(direction);
    }
};
