const w4 = @import("wasm4.zig");
const math = @import("std").math;

const delta_t: f64 = 1.0 / 60.0;
var t: f64 = 0;

const ssize = 160;
const ssize_2 = 80;

export fn start() void {}

export fn update() void {
    const gamepad = w4.GAMEPAD1.*;
    if (gamepad & w4.BUTTON_1 != 0) {
        w4.DRAW_COLORS.* = 4;
    }
    w4.text("Press \x87 to blink", 16, 90);

    const pos_y: i32 = ssize_2 - @as(i32, @intFromFloat(math.sin(2 * math.pi * t) * ssize_2));

    w4.text("*", ssize_2, pos_y);
    t += delta_t;
}
