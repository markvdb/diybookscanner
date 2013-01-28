include <global_constants.scad>;
include <cradle_base.scad>;
include <cradle_lift_arm.scad>;

translate([sheet_z-cradle_lift_arm_cutout_height,0,0]) cradle_base();
translate([0,cradle_base_front_corner_depth,0]) mirror() rotate([0,-90,0]) cradle_lift_arm();

translate([cradle_base_full_width+2*(sheet_z-cradle_lift_arm_cutout_height),cradle_base_front_corner_depth,0]) rotate([0,-90,0]) cradle_lift_arm();