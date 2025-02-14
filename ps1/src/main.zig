const w4 = @import("wasm4.zig");
const std = @import("std");

const ssize = 160;
const ssize_2 = 80;

const Vec2 = struct {
    x: f32,
    y: f32,
    pub fn add(self: *Vec2, other: Vec2) void {
        self.x += other.x;
        self.y += other.y;
    }
};

var prng: std.rand.DefaultPrng = undefined;
var random: std.rand.Random = undefined;

const Particle = struct {
    pos: Vec2,
    acceleration: Vec2,
    velocity: Vec2,
    lifetime: i32,

    pub fn new() Particle {
        const vx: f32 = (random.float(f32) - 0.5) * 1.2;
        const vy: f32 = (random.float(f32) - 0.5) * 0.2;
        return Particle{
            .pos = .{ .x = 80, .y = 15 },
            .acceleration = .{ .x = 0.01, .y = 0.04 },
            .velocity = .{ .x = vx, .y = vy },
            .lifetime = 120,
        };
    }

    pub fn update(self: *Particle) void {
        self.velocity.add(self.acceleration);
        self.pos.add(self.velocity);
        if (self.lifetime > 0) {
            self.lifetime -= 1;
        }
    }
};

var frame: u32 = 0;

var particles: [50]Particle = undefined;
var next_particle: usize = 0;

fn create_particle() void {
    particles[next_particle] = Particle.new();
    next_particle = (next_particle + 1) % particles.len;
}

export fn start() void {
    prng = std.rand.DefaultPrng.init(0);
    random = prng.random();

    create_particle();
}

const psize = 9;
const poffset = (psize / 2);

export fn update() void {
    // cls
    for (w4.FRAMEBUFFER) |*x| {
        x.* = 0 | (0 << 2) | (0 << 4) | (0 << 6);
    }

    // draw particles
    for (&particles) |*particle| {
        const p = particle.*;

        if (p.lifetime > 0) {
            w4.oval(@intFromFloat(p.pos.x - poffset), @intFromFloat(p.pos.y - poffset), psize, psize);
        }
        particle.update();
    }

    if (frame % 6 == 0) {
        create_particle();
    }

    frame += 1;
}
