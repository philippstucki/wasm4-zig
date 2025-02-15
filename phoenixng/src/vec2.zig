pub const Vec2 = struct {
    x: f32,
    y: f32,
    pub fn add(self: *@This(), other: @This()) void {
        self.x += other.x;
        self.y += other.y;
    }

    pub fn multiply(self: *@This(), scalar: f32) void {
        self.x *= scalar;
        self.y *= scalar;
    }
};
