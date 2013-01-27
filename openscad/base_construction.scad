include <global_constants.scad>;
include <small_support.scad>;
include <large_support.scad>;
include <back_brace.scad>;
include <front_brace.scad>;

module supports(){
  rotate([0,0,90]){
    union(){
      rotate([90,0,0]) large_support();
      translate([large_support_depth,sheet_z,0]){
        rotate([90,-90,0]) small_support();
        }
    }
  }
}

supports();
translate([front_brace_width,0,0]) mirror(0,0,0) supports();

translate([sheet_z,large_support_depth+base_brace_edge_depth,0]) rotate([90,0,0]) back_brace();
translate([front_brace_width-sheet_z,-base_brace_edge_depth,0]) rotate([90,0,180]) front_brace();
