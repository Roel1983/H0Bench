function mm(x) = x;
function layer(x) = x * 0.10;
function nozzle(x) = x * 0.4;

function between(a, b, f = 0.5) = (a * (1-f) + b * f);

a = mm(8.5);
b = mm(7.5);
c = mm(1.0);
steps = 4;
d = nozzle(2);
step_h = layer(3);

steps_2 = 4;
e = mm(.3);

points_seat_bottom = [
    [0, 0],
    [b, 0]
];
points_seat_top = [
    each for(step_i = [0 : steps]) [
        [
            between(b, c, step_i / steps),
            d + step_h * step_i
        ], [
            between(b, c, step_i / steps),
            d + step_h * (step_i + 1)
        ]   
    ]
];
points_backrest_front = [
    each for(step_i = [0 : steps_2 - 1]) (
        let(
            f1 = between(d + (steps - 1) * step_h, a, step_i / steps_2),
            f2 = between(d + (steps - 1) * step_h, a, (step_i + 1) / steps_2)
        )[
            [c,     between(f1,f2,0.25)],
            [c + e, between(f1,f2,0.50)],
            [c + e, between(f1,f2,0.75)],
            [c,     between(f1,f2,1.00)],
        ]
    )
];
points_backrest_back = [
    [0, a]
];

points= concat(
    points_seat_bottom,
    points_seat_top,
    points_backrest_front,
    points_backrest_back
);
i= mm(21);

rotate(-90, [0,1,0]) {
    linear_extrude(i) polygon(points = points);

    leg();
    translate([0,0,i]) mirror([0,0,1]) leg();

    
}
module leg() {
    g = mm(4.5);
    h = mm(1.5);
    j = a - nozzle(2);
    
    translate([0,0,mm(1.0)]) linear_extrude(nozzle(4)) polygon([
        [ 0, between(0, j, 0.0)],
        [-g, between(0, j, 0.0)],
        [-g, between(0, j, 0.2)],
        [-h, between(0, j, 0.4)],
        [-h, between(0, j, 0.6)],
        [-g, between(0, j, 0.8)],
        [-g, between(0, j, 1.0)],
        [ 0, between(0, j, 1.0)]
    ]);
}