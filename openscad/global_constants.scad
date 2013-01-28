// unit = 0.1 mm
// 1 inch = 25.4 mm = 254 units

// Dimensions

// Sheet dimensions
sheet_x=24400;
sheet_y=12200;
sheet_z=180;

// Circular cnc routing holes
cnc_circle_r=31.750;
module routing_circle(x,y){
  translate([x,y]) linear_extrude(height=sheet_z) circle(cnc_circle_r);
}

bolt_circle_r=41.0210;
module bolt_circle(x,y){
  translate([x,y]) linear_extrude(height=sheet_z) circle(bolt_circle_r);
}

// Conversion
medievaltometric=254;
metrictomedieval=.0039370078;

// Use the metric system by default
// units="medieval";
units="metric";

// Light plate construction
light_plate_support_height=1651;//6.5"
light_plate_support_width=3662.68;//14.42

// Base construction
large_support_depth=3667.4552;//14.4388"
large_support_height=4254.5;//16.75"
small_support_depth=1460.5;
small_support_height=4254.5;
front_brace_width=5842+2*sheet_z;
base_brace_edge_depth=53;

// Cradle construction
cradle_base_full_width=5969;//23.5"
cradle_base_front_corner_depth=538.3784;//2.1196"

cradle_lift_arm_cutout_height=63.5;//.25"

