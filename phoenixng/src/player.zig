const Vec2 = @import("vec2.zig").Vec2;
const w4 = @import("wasm4.zig");
const sprites = @import("sprites.zig");

pub const Player = struct {
    pos: Vec2,

    pub fn create() Player {
        return Player{ .pos = Vec2{ .x = w4.SCREEN_SIZE / 2 - sprites.player_width / 2, .y = w4.SCREEN_SIZE - sprites.player_height } };
    }
    pub fn update(self: *@This(), direction: Vec2) void {
        self.pos.add(direction);
    }
};
