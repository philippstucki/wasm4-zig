const std = @import("std");
const w4 = @import("wasm4.zig");

var prng: std.rand.DefaultPrng = undefined;
var random: std.rand.Random = undefined;

pub fn initRandom() void {
    prng = std.rand.DefaultPrng.init(0);
    random = prng.random();
}

pub fn getRandomPos() f32 {
    return random.float(f32) * w4.SCREEN_SIZE;
}

pub fn getRandomVelocity() f32 {
    return if (random.float(f32) > 0.5) 0.4 else 0.2;
}
