// To render the DXF file from the command line:
// openscad -x front_brace.dxf -D'units="metric"' front_brace.scad

include <global_constants.scad>
include <braces.scad>

module front_brace(){
  body_x=5842;
  body_y_i=635;
  body_y_e=1016;
  body_cutout_x_e=1017.3462;
  body_cutout_x_i=1393.2663;
  edge_x=sheet_z;
  edge_z=53;

  brace(body_x,body_y, body_y_e, body_y_i, body_cutout_x_e, body_cutout_x_i, edge_x, edge_z);
}

if (units=="metric") front_brace();
if (units=="medieval") scale([metrictomedieval,metrictomedieval,metrictomedieval]) front_brace();
