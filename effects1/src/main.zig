const w4 = @import("wasm4.zig");
const math = @import("std").math;

const ssize = 160;
const ssize_2 = 80;

const Particle = struct { x: i32, y: i32 };

var frame: u32 = 0;
const palette: [4]u32 = .{ 0xfff6d3, 0xf9a875, 0xeb6b6f, 0x7c3f58 };
var paletteshift: u8 = 0;

export fn start() void {}

export fn update() void {
    for (w4.FRAMEBUFFER) |*x| {
        x.* = 0 | (1 << 2) | (2 << 4) | (3 << 6);
    }
    frame += 1;
    if (frame % 15 == 0) {
        paletteshift = (paletteshift + 1) % 3;
        w4.PALETTE[0] = palette[paletteshift % 3];
        w4.PALETTE[1] = palette[(paletteshift + 1) % 3];
        w4.PALETTE[2] = palette[(paletteshift + 2) % 3];
        w4.PALETTE[3] = palette[(paletteshift + 3) % 3];
    }
}
