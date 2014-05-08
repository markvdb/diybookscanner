// To render the DXF file from the command line:
// openscad -x back_plate.dxf -D'units="metric"' back_plate.scad

// TODO: clean up parameters, hole for connecting bars, bracket cutouts for glass

include <global_constants.scad>;

main_rectangle_x=12.95*254;
main_rectangle_y=18.4688*254;

corner_rectangle_y=14.25*254;
corner_rectangle_x=4.95*254;
corner_rectangle_rectangular_cutout_x=0.72*254;
corner_rectangle_bottom_rectangular_cutout_y=0.75*254;
corner_rectangle_top_rectangular_cutout_y=6.75*254;

top_corner_height=6.75*254;

//base shape for half of the top plate
module main_trapezium(){
  difference(){
    square([main_rectangle_x,main_rectangle_y]);
    translate([main_rectangle_x,0,0]) rotate(50) translate([-main_rectangle_x,0,0]) square([main_rectangle_x,main_rectangle_y]);
  }
}

module top_corner_cutout(){
  polygon([[0,0],[corner_rectangle_rectangular_cutout_x,0],[corner_rectangle_rectangular_cutout_x,cnc_circle_r*2],[1.95*254,1.9121*254],[corner_rectangle_rectangular_cutout_x,4.0682*254],[3.9162*254,top_corner_height],[0,top_corner_height],[0,0]]);
}

//rectangular overlay on the outside of the trapezium
module corner_rectangle(){
  difference() {
    square([corner_rectangle_x,corner_rectangle_y]);
    square([corner_rectangle_rectangular_cutout_x,corner_rectangle_bottom_rectangular_cutout_y]);
  }
}

module back_plate_half(){
  difference(){
    union(){
      main_trapezium();
      translate([0,main_rectangle_y-corner_rectangle_y,0]) corner_rectangle();
    }
    translate([0,main_rectangle_y-corner_rectangle_top_rectangular_cutout_y,0]) square([corner_rectangle_rectangular_cutout_x,corner_rectangle_top_rectangular_cutout_y]);
    //top corner cutout (fixed size)
    translate([0,main_rectangle_y-top_corner_height,0]) top_corner_cutout();
    //big hole (fixed size)
    translate([main_rectangle_x,3.6315*254,0]) polygon([[0,0],[-8.5*254,6*254],[-6*254,11.5*254],[0,13.5*254]]);
  }
}

//mirrored back plate half
module back_plate_full(){
  union(){
    back_plate_half();
    translate([main_rectangle_x*2,0,0]) mirror([1,0,0]) back_plate_half();
  }
}


linear_extrude(sheet_z) mirror([1,0,0]) back_plate_full();
