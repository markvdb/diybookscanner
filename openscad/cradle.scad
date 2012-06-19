// To render the DXF file from the command line:
// openscad -x cradle.dxf -D'units="metric"' cradle.scad

include <global_constants.scad>

cradle_hole_x=177.8;
cradle_hole_y=508;

edge_to_holes_x=714.1464;
bottom_cube_cutout_y=119.2022;

module cradle_hole(){
  x=cradle_hole_x;
  y=cradle_hole_y;
  routing_circle(0,cnc_circle_r);
  routing_circle(x,cnc_circle_r);
  routing_circle(x,y-cnc_circle_r);
  routing_circle(0,y-cnc_circle_r);
  cube([177.8,508,sheet_z]);
}

module cradle_holes(){
  xdistance=1261.2878;
  ydistance=617.8804;
  translate([edge_to_holes_x,bottom_cube_cutout_y,0]) {
    cradle_hole();
    translate([xdistance+cradle_hole_x,0]) cradle_hole();
    translate([xdistance+cradle_hole_x,ydistance+cradle_hole_y]) cradle_hole();
    translate([0,ydistance+cradle_hole_y]) cradle_hole();
  }
}

module cradle_half(){
  x_e=3048;
  x_i=2794;
  y_e=2286;
  y_i=2032;
  bottom_cube_cutout_z=101.6;

  render(convexity = 10){
    difference(){
      linear_extrude(height=sheet_z) polygon([[0,0],[x_e,0],[x_e,y_i],[x_e-(x_e-x_i)/2,y_e],[(x_e-x_i)/2,y_e],[0,y_i],[0,0]]);
      cube([x_e,bottom_cube_cutout_y,bottom_cube_cutout_z]);
    }
  }
}

module cradle() {
  render (convexity = 10){
    difference(){
      cradle_half();
      cradle_holes();
    }
  }
}

if (units=="metric") cradle();
if (units=="medieval") scale([metrictomedieval,metrictomedieval,metrictomedieval]) cradle();