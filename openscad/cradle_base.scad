include <global_constants.scad>;

cradle_base_full_width=5969;//23.5"
cradle_base_full_depth=2728.849;//10.7435"
cradle_base_corner_width=127;//0.5"
cradle_base_front_corner_depth=538.3784;//2.1196"
cradle_base_back_corner_depth=158.4706;//0.6239"

cradle_base_cutout_width=4953;//19.5"
cradle_base_cutout_depth=2032;//8"
cradle_base_wheelbase_depth=2159;//8.5"
cradle_base_wheelbase_height=127;//<todo>

cradle_base_small_depth_rectangle_depth=cradle_base_full_depth-cradle_base_front_corner_depth-cradle_base_back_corner_depth;

render(convexity=10){
  difference(){
    //two rectangular blocks define the cradle base
    translate([0,cradle_base_front_corner_depth,0,]){
      union(){
        cube([cradle_base_full_width,cradle_base_small_depth_rectangle_depth,sheet_z]);
        translate([cradle_base_corner_width,-cradle_base_front_corner_depth,0]){
          cube([cradle_base_full_width-2*cradle_base_corner_width,cradle_base_full_depth, sheet_z]);
        }
      }
    }
    //two rectangular cutouts define the hole and the place where the bearings sit in the cradle base
    translate([(cradle_base_full_width-cradle_base_cutout_width)/2,(cradle_base_full_depth-cradle_base_wheelbase_depth)/2,0]){
      union(){
        translate([0,(cradle_base_wheelbase_depth-cradle_base_cutout_depth)/2,0]) cube([cradle_base_cutout_width,cradle_base_cutout_depth,sheet_z]);
        translate([0,0,sheet_z-cradle_base_wheelbase_height]) cube([cradle_base_cutout_width,cradle_base_wheelbase_depth,cradle_base_wheelbase_height]);
      }
    }
  }
}