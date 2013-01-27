// To render the DXF file from the command line:
// openscad -x front_brace.dxf -D'units="metric"' front_brace.scad

include <braces.scad>

module back_brace(){
  body_x=5842;
  body_y_i=357.2002;
  body_y_e=571.5;
  body_cutout_x_e=909.0406;
  body_cutout_x_i=1317.0662;
  edge_x=sheet_z*2;
  edge_z=53;

  brace(body_x,body_y, body_y_e, body_y_i, body_cutout_x_e, body_cutout_x_i, edge_x, edge_z);
}

//if (units=="metric") back_brace();
//if (units=="medieval") scale([metrictomedieval,metrictomedieval,metrictomedieval]) back_brace();
