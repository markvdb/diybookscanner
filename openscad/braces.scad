include <global_constants.scad>;

module brace(body_x,body_y,body_y_e, body_y_i,body_cutout_x_e, body_cutout_x_i,edge_x,edge_z){
  linear_extrude(height=sheet_z)
    polygon([[0,0],[body_x,0],[body_x,body_y_e],[body_x-body_cutout_x_e,body_y_e],[body_x-body_cutout_x_i,body_y_i],[body_cutout_x_i,body_y_i],[1016,body_y_e],[0,body_y_e],[0,0]]);

  translate([-edge_x,0,0]) cube([edge_x,body_y_e,edge_z]);
  translate([body_x,0,0]) cube([edge_x,body_y_e,edge_z]);

}
