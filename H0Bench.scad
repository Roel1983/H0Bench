// The part to be generated
part                      = "Bench"; // ["Bench", "Examples"]

/* [Bench] */

// Width of the bench (m)
bench_width               = 1.8;  // [0.50 : 0.05 : 5.00]

bench_corner_left         = 0;    // [-90 : 15 : 90]

bench_corner_right        = 0;    // [-90 : 15 : 90]

/* [Seat] */

// Type of seat
seat_type                 = "Planks"; // ["Flat", "Planks"]

// Depth of the seat (m)
seat_depth                = 0.75; // [0.50 : 0.05 : 2.00]

// Thickness of the seat (nozzle)
seat_thickness            = 2.5;  // [1.0 : 0.5 : 5.0]

// Number of planks
seat_plank_count          = 4;    // [1 : 10]

// Thickness of the plank (cm)
seat_plank_thickness      = 3;    // [0.0 : 0.1: 10.0]

/* [Back rest] */

// Type of back rest
backrest_type             = "Planks"; // ["None", "Flat", "Planks"]

// Heigh of the back rest (m)
backrest_height           = 0.60; // [0.50 : 0.05 : 1.0]

// Thickness of the back rest (layer)
backrest_thickness        = 6;    // [3 : 15]

// Number of planks
backrest_plank_count     = 5;     // [1 : 10]

// Thickness of the plank (layer)
backrest_plank_thickness = 3;     // [0 : 5]

/* [Arm rest] */

// Type of armrest
armrest_type              = "None"; // ["None", "Massive"]

// Number of armrests
armrest_count             = 2;    // [1 : 6]

// Skip the most left armrest
armrest_skip_most_left    = false;

// Skip the most right armrest
armrest_skip_most_right   = false;

// Distribution pattern
armrest_distr_pattern     = "1";  // ["1":"Even", "12":"Short-Long"]

// Mirror distribution pattern
armrest_distr_pattern_mirror = false;

// Armrest side inset (m)
armrest_side_inset        = 0.0;  // [0.00 : 0.05 : 0.50]

// Length of armrest (m)
armrest_length            = 0.50; // [0.20 : 0.05 : 2.00]

// Height of armrest (m)
armrest_height            = 0.20; // [0.05 : 0.05 : 0.30]

// Width of armrest (nozzle)
armrest_width             = 2;    // [1.0 : 0.5 : 4.0]

/* [Support] */

// Number of legs
support_type              = "Legs"; // ["None", "Legs", "Massive"]

// Height of support (m)
support_height            = 0.40; // [0.10 : 0.05 : 1.00]

// Support front inset (m)
support_front_inset       = 0.07; // [0.00 : 0.01 : 0.10]

// Support side inset (m)  
support_side_inset        = 0.10; // [0.00 : 0.05 : 1.00]

// Number of legs
leg_count                 = 2;    // [1 : 6]

// Leg bridge height (m)
leg_bridge_height         = 0.2;   // [0.0 : 0.05 : 0.8]

// Leg thickness (nozzle)
leg_thickness             = 4;   // [2.0 : 0.5 : 10.0]

/* [Scale] */
scale_nominator           = 1;
scale_denominator         = 87;

/* [3D Printer] */

// Width of the 3D printer nozzle (mm)
nozzle_width              = 0.4; // [0.1 : 0.05 : 1.0]

// Layer height of the 3D printer (mm)
layer_height              = 0.15; // [0.06 : 0.01 : 0.2]

// First layer height of the 3D printer (mm)
first_layer_height        = 0.2; // [0.06 : 0.01 : 0.4]

/*********************************************************/

if      (part == "Bench")    Bench();
else if (part == "Examples") Examples();

module Bench(
    bench_width               = scaled( m( bench_width)),
    bench_corner_left         = angle(     bench_corner_left),
    bench_corner_right        = angle(     bench_corner_right),
    seat_type                 =            seat_type,
    seat_depth                = scaled( m( seat_depth)),
    seat_thickness            = nozzle(    seat_thickness),
    seat_plank_count          =            seat_plank_count,
    seat_plank_thickness      = scaled(cm( seat_plank_thickness)),
    backrest_type             =            backrest_type,
    backrest_height           = scaled( m( backrest_height)),
    backrest_thickness        = layer(     backrest_thickness),
    backrest_plank_count      =            backrest_plank_count,
    backrest_plank_thickness  = layer(     backrest_plank_thickness),
    armrest_type              =            armrest_type,
    armrest_count             =            armrest_count,
    armrest_skip_most_left    =            armrest_skip_most_left,
    armrest_skip_most_right   =            armrest_skip_most_right,
    armrest_distr_pattern     =            armrest_distr_pattern,
    armrest_distr_pattern_mirror =         armrest_distr_pattern_mirror,
    armrest_side_inset        = scaled( m( armrest_side_inset)),
    armrest_length            = scaled( m( armrest_length)),
    armrest_height            = scaled( m( armrest_height)),
    armrest_width             = nozzle(    armrest_width),
    support_type              =            support_type,
    support_height            = scaled( m( support_height)),
    support_front_inset       = scaled( m( support_front_inset)),
    support_side_inset        = scaled( m( support_side_inset)),
    leg_count                 =            leg_count,
    leg_bridge_height         = scaled( m( leg_bridge_height)),
    leg_thickness             = nozzle(    leg_thickness),
) {
    Support() {
        SeatAndBackRest();
        ArmRests();
    }
    
    module Support() {
        if (support_type == "None") {
            children();
        } else {
            if      (support_type == "Legs"   ) Legs();
            else if (support_type == "Massive") Massive();
            else    assert(false, str(
                "'support_type' must be \"Legs\" or \"Massive\", but is ",
                support_type));
            translate([0, 0, support_height]) children();
        }
        
        leg_depth      = seat_depth - support_front_inset;
        
        module Legs() {
            most_left_leg  = (bench_width - leg_thickness) / 2
                           - support_side_inset
                           - tan(max(0, bench_corner_left / 2)) * leg_depth;
            most_right_leg = support_side_inset
                           - (bench_width - leg_thickness) / 2
                           + tan(max(0, bench_corner_right / 2)) * leg_depth;
            
            if (leg_count == 1) {
                Leg();
            } else {
                for (leg_index = [0 : leg_count - 1]) {
                    translate([
                        0,
                        between(most_left_leg, most_right_leg,
                            leg_index / (leg_count - 1)
                        )
                    ]) Leg();
                }
            }
            
            module Leg() {
                rotate(90, VEC_X) {
                    linear_extrude(leg_thickness, center = true) {
                        polygon([
                            [leg_depth * 0.0, support_height],
                            [leg_depth * 0.0, 0],
                            [leg_depth * 0.2, 0],
                            [leg_depth * 0.4, min(leg_bridge_height, support_height)],
                            [leg_depth * 0.6, min(leg_bridge_height, support_height)],
                            [leg_depth * 0.8, 0],
                            [leg_depth * 1.0, 0],
                            [leg_depth * 1.0, support_height]
                        ]);
                    }
                }
            }
        }
        
        module Massive() {
            linear_extrude(support_height) {
                polygon([
                    [
                        0,
                        bench_width / 2 - support_side_inset
                    ], [
                        leg_depth,
                        bench_width / 2 - support_side_inset
                        - tan(bench_corner_left / 2) * leg_depth
                    ], [
                        leg_depth,
                        - bench_width / 2 + support_side_inset
                        + tan(bench_corner_right / 2) * leg_depth
                    ], [
                        0,
                        - bench_width / 2 + support_side_inset
                    ]
                ]);
            }
            translate([0, -(bench_width - support_side_inset) / 2]) {
                
                *cube([
                    leg_depth,
                    (bench_width - support_side_inset),
                    support_height
                ]);
            }
        }
    }
    
    module SeatAndBackRest() {
        intersection() {
            linear_extrude(
                backrest_height,
                convexity = 2
            ) polygon([
                [0, -bench_width / 2],
                [seat_depth, -bench_width / 2 + tan(bench_corner_right / 2) * seat_depth],
                [seat_depth,  bench_width / 2 - tan(bench_corner_left  / 2) * seat_depth],
                [0, bench_width/ 2],
            ]);
            rotate(90, VEC_X) {
                linear_extrude(
                    bench_width + 2 * seat_depth,
                    center = true,
                    convexity = 10
                ) {
                    Seat2D();
                    BackRest2D();
                }
            }
        }
        
        module Seat2D() {
            if      (seat_type == "Flat")   Flat();
            else if (seat_type == "Planks") Planks();
            else assert(false, str(
                "'seat_type' should be \"Flat\" or \"Planks\" but is ",
                seat_type));
            
            module Flat() {
                square([seat_depth, seat_thickness]);
            }
            
            module Planks() {
                polygon(concat(
                    [
                        [0, 0],
                        [seat_depth, 0]
                    ],[
                        each for(plank_index = [0 : seat_plank_count - 1]) (
                            let(
                                x_from = plank_seam(plank_index + 0),
                                x_to   = plank_seam(plank_index + 1)
                            ) [
                                [
                                    between(x_from, x_to, 0.00),
                                    seat_thickness + 0,
                                ], [
                                    between(x_from, x_to, 0.25),
                                    seat_thickness + seat_plank_thickness
                                ], [
                                    between(x_from, x_to, 0.50),
                                    seat_thickness + seat_plank_thickness
                                ], [
                                    between(x_from, x_to, 0.75),
                                    seat_thickness + 0
                                ],
                            ]
                        )
                    ], (
                        (backrest_bottom_thickness != 0) ? [
                            [
                                0,
                                seat_thickness
                            ]
                        ] : [/* No points */]
                    )
                ));
                
                function plank_seam(i) = (
                    between(
                        seat_depth,
                        (backrest_bottom_thickness == 0) ? (
                            -seat_depth / (seat_plank_count * 4 - 1)
                        ) : (
                            backrest_bottom_thickness
                        ),
                        i / seat_plank_count
                    )
                );
            }
        }
        module BackRest2D() {
            if      (backrest_type == "Flat")    Flat();
            else if (backrest_type == "Planks") Planks();
            else assert(backrest_type == "None", "Unknown 'backrest_type'");
            
            module Flat() {
                square([backrest_thickness, backrest_height]);
            }
            
            module Planks() {
                polygon(concat(
                    [
                        [0, 0],
                        [0, backrest_height]
                    ], [
                        each for (plank_index = [0 : backrest_plank_count - 1]) let(
                            thickness = backrest_thickness
                                      + plank_index * backrest_plank_thickness
                        ) [[
                            thickness,
                            between(
                                backrest_height, seat_thickness,
                                plank_index / backrest_plank_count
                            )
                        ], [
                            thickness,
                            between(
                                backrest_height, seat_thickness,
                                (plank_index + 1) / backrest_plank_count
                            )
                        ]]
                    ]
                ));
            }
        }
    }
    
    module ArmRests() {
        if      (armrest_type == "Floating") Floating();
        else if (armrest_type == "Open")     Open();
        else if (armrest_type == "Massive")  Massive();
        else if (armrest_type == "Panel")    Panel();
        else assert(armrest_type == "None", "Unknown 'armrest_type'");
        
        length_from_back = min(armrest_length + backrest_thickness, seat_depth);
        
        module Floating() {
        }
        
        module Open() {
        }
        
        module Massive() {
            Distribute() {
                height = armrest_height + seat_thickness;
                translate([0, -armrest_width / 2]) {
                    cube([length_from_back, armrest_width, height]);
                }
            }
        }
        
        module Panel() {
        }
        
        module Distribute() {
            most_left_position  = (bench_width - armrest_width) / 2
                                - armrest_side_inset
                                - tan(max(0, bench_corner_left / 2)) * length_from_back;
            most_right_position = armrest_side_inset
                                - (bench_width - armrest_width) / 2
                                + tan(max(0, bench_corner_right / 2)) * length_from_back;
            
            if (armrest_count == 1 && !armrest_skip_most_left && !armrest_skip_most_right) {
                children();
            } else {
                index_right_offset = armrest_skip_most_right ? 1 : 0;
                index_left_offset  = armrest_skip_most_left  ? 1 : 0;
                count              = distr_pattern_get(
                                        armrest_count - 1
                                        + index_right_offset
                                        + index_left_offset);
                
                for (index = [0:armrest_count - 1]) {
                    translate([
                        0,
                        between(
                            most_right_position,
                            most_left_position,
                            distr_pattern_get(index + index_right_offset) / count
                        )
                    ]) children();
                    
                }
            }
            
            function distr_pattern_get(index) = (
                pattern_get(
                    reverse_if(
                        num_string_to_num_array(armrest_distr_pattern),
                        condition = armrest_distr_pattern_mirror
                    ),
                    index
                )
            );
        }
    }
    
    backrest_bottom_thickness = (
        (backrest_type == "None") ? (
            0
        ) : (backrest_type == "Planks") ? (
            backrest_thickness + (seat_plank_count - 1) * seat_plank_thickness 
        ) : (backrest_type == "Flat") ? (
            backrest_thickness
        ) : (
            assert(false) undef
        )
    );
};

module Examples() {
    Grid(columns = 5) {
        Bench(seat_type = "Flat",   backrest_type = "None", support_type = "Massive");
        Bench(seat_type = "Flat",   backrest_type = "Flat", support_type = "Massive");
        Bench(seat_type = "Flat",   backrest_type = "Flat", support_type = "Legs");
        Bench(seat_type = "Planks", backrest_type = "None", support_type = "Massive");
        Bench(seat_type = "Planks", backrest_type = "Planks", support_type = "Massive");
        Bench(seat_type = "Planks", backrest_type = "Planks", support_type = "Massive",
              bench_width=scaled(m(.8)));
        Bench(seat_type = "Planks", backrest_type = "Planks", support_type = "Legs");
        Bench(seat_type = "Planks", backrest_type = "Planks", support_type = "None");
        Bench(seat_type = "Planks", backrest_type = "Flat", support_type = "Massive");
        Bench(seat_type = "Flat",   backrest_type = "Planks", support_type = "Legs");
        Bench(bench_corner_left =  45, bench_corner_right =  45);
        Bench(bench_corner_left = -90, bench_corner_right = -30);
        Bench(bench_corner_left = -45, bench_corner_right = 45);
        Bench(armrest_type = "Massive", armrest_count = 1,
              armrest_skip_most_left=false, armrest_skip_most_right=true);
        Bench(armrest_type = "Massive", armrest_count = 1,
              armrest_skip_most_left=true, armrest_skip_most_right=true);
        Bench(armrest_type = "Massive", armrest_count = 2);
        Bench(armrest_type = "Massive", armrest_count = 2, bench_width=scaled(m(.8)));
        Bench(armrest_type = "Massive", armrest_count = 2,
              armrest_skip_most_left=false, armrest_skip_most_right=true);
        Bench(armrest_type = "Massive", armrest_count = 2,
              armrest_skip_most_left=true, armrest_skip_most_right=true);
        Bench(armrest_type = "Massive", armrest_count = 2,
              armrest_skip_most_left=false, armrest_skip_most_right=true,
              armrest_distr_pattern = "12");
        Bench(armrest_type = "Massive", armrest_count = 2,
              armrest_skip_most_left=false, armrest_skip_most_right=true,
              armrest_distr_pattern = "12", armrest_distr_pattern_mirror = true);
        Bench(armrest_type = "Massive", armrest_count = 3,
              armrest_distr_pattern = "12",
              armrest_distr_pattern_mirror = true);
        Bench(armrest_type = "Massive", armrest_count = 3,
              armrest_skip_most_left=false, armrest_skip_most_right=true,
              armrest_distr_pattern = "12", armrest_distr_pattern_mirror = true);
    }
    
    module Grid(columns) {
        rows  = ceil($children / columns);
        spacing  = [
            1.5 * scaled(m(bench_width)),
            max(2 * scaled(m(seat_depth)), 1.5 * scaled(m(bench_width)))
        ];
        for(column = [0 : columns - 1], row = [0:rows - 1]) {
            index = row * columns + column;
            if(index < $children) {
                translate([
                    spacing[0] * (column - (columns - 1) / 2),
                    -spacing[1] * (row    - (rows    - 1) / 2),
                ]) children(index);
            }
        }
    }
}

// Constants
VEC_X = [1, 0, 0];

// Units

function mm(x) = x;
function cm(x) = x * mm(10);
function  m(x) = x * mm(1000);

function angle(x) = x;

function layer(x, include_first_layer = false) = (
    include_first_layer ? (
        first_layer_height * max(1, x) +
        layer_height       * max(0, x - 1)
    ) : (
        layer_height       * x
    )
);

function nozzle(x) = x * mm(nozzle_width);

function scaled(x) = x * scale_nominator / scale_denominator;

// Helper functions

function between(a, b, f = 0.5) = (a * (1-f) + b * f);
assert(between(3, 7     ) == 5);
assert(between(3, 7, .25) == 4);

function num_string_to_num_array(string) = [
    for (c = string) ord(c) - ord("0")
];
assert(num_string_to_num_array("1234") == [1, 2, 3, 4]);

function sum(array, from_index=0, till_index=undef) = (
    (from_index < (is_num(till_index)?till_index:(len(array)))) ? (
        array[from_index] + sum(array, from_index + 1, till_index = till_index)
    ) : (
        0
    )
);
assert(sum([2, 3, 4, 5]                                ) == 14);
assert(sum([2, 3, 4, 5], from_index = 0, till_index = 4) == 14);
assert(sum([2, 3, 4, 5], from_index = 1                ) == 12);
assert(sum([2, 3, 4, 5],                 till_index = 3) ==  9);
assert(sum([2, 3, 4, 5], from_index = 1, till_index = 3) ==  7);

function reverse(array, condition = true) = (
    (condition) ? [
        for(i = [0 : len(array) - 1]) array[len(array) - i - 1]
    ] : (
        array
    )
);
assert(reverse([1, 2, 3]) == [3, 2, 1]);
        
function reverse_if(array, condition) = (
    (condition) ? reverse(array) : array
);
assert(reverse_if([1, 2, 3], condition=true)  == [3, 2, 1]);
assert(reverse_if([1, 2, 3], condition=false) == [1, 2, 3]);

function pattern_get(pattern, index) = (
    let(
        period  = sum(pattern)
    ) (
        period * floor(index / len(pattern))
        + sum(
            pattern, 
            till_index = index % len(pattern)
        )
    )
);
assert([for (i = [0 : 5]) pattern_get([1      ], i)], [0, 1, 2, 3, 4, 5]);
assert([for (i = [0 : 5]) pattern_get([1, 2   ], i)], [0, 1, 3, 4, 6, 7]);
assert([for (i = [0 : 5]) pattern_get([1, 3   ], i)], [0, 1, 4, 5, 8, 9]);
assert([for (i = [0 : 5]) pattern_get([1, 2, 3], i)], [0, 1, 3, 6, 7, 9]);