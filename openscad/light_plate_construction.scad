include <global_constants.scad>;
include <light_plate_support.scad>;
include <light_plate.scad>;

module light_plate_construction(){
  light_plate();
  translate ([0,(light_plate_depth-light_plate_support_width)/2,-light_plate_support_height+sheet_z]) rotate(a=[90,0,90]) light_plate_support();
  translate([light_plate_width-sheet_z,(light_plate_depth-light_plate_support_width)/2,-light_plate_support_height+sheet_z]) rotate(a=[90,0,90]) light_plate_support();

}

light_plate_construction();
