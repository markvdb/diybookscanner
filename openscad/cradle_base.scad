//Work in progress!!

include <global_constants.scad>;

cradle_base_full_width=5969;//23.5"
cradle_base_full_depth=2728.849;//10.7435"
cradle_base_corner_width=127;//0.5"
cradle_base_front_corner_depth=538.3784;//2.1196"
cradle_base_back_corner_depth=158.4706;//0.6239"

cradle_base_cutout_width=4953;//19.5"
cradle_base_cutout_depth=2032;//8"
cradle_base_wheelbase_depth=2159;//8.5"
cradle_base_wheelbase_height=0;//<todo>

cradle_base_small_depth_rectangle_depth=cradle_base_full_depth-cradle_base_front_corner_depth-cradle_base_back_corner_depth;

cube([cradle_base_full_width,cradle_base_small_depth_rectangle_depth,sheet_z]);
