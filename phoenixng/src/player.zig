const Vec2 = @import("vec2.zig").Vec2;
const w4 = @import("wasm4.zig");
const sprites = @import("sprites.zig");

pub const Player = struct {
    pos: Vec2,

    pub fn create() Player {
        return Player{ .pos = Vec2{ .x = w4.SCREEN_SIZE / 2 - sprites.player_width / 2, .y = w4.SCREEN_SIZE - sprites.player_height } };
    }
    pub fn update(self: *@This()) void {
        const gamepad = w4.GAMEPAD1.*;
        const dx: f32 = if (gamepad & w4.BUTTON_LEFT != 0) -1 else if (gamepad & w4.BUTTON_RIGHT != 0) 1 else 0;
        const dy: f32 = if (gamepad & w4.BUTTON_UP != 0) -1 else if (gamepad & w4.BUTTON_DOWN != 0) 1 else 0;
        self.pos.add(Vec2{ .x = dx, .y = dy });
    }
    pub fn draw(self: *@This()) void {
        w4.DRAW_COLORS.* = 0x42;
        w4.blit(&sprites.player, @intFromFloat(self.pos.x), @intFromFloat(self.pos.y), sprites.player_width, sprites.player_height, sprites.player_flags);
    }
};
