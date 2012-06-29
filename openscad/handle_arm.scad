// To render the DXF file from the command line:
// openscad -x handle_arm.dxf -D'units="metric"' handle_arm.scad

include <global_constants.scad>

x1=254;//1" (1.4mm difference from original design)
x2=3736.9242;//14.7123"
x3=3990.5940;//15.7110"
x_max=6268.7708;//24.6802"
x_long_cutout_long_side=13.5*254;
x_long_cutout_short_side=10.25*254;
x_short_cutout_long_side=8.25*254;
x_short_cutout_short_side=5*254;

y1=1.5*254;//1.5"
y_max=1016;//4"

module base(){
// base rectangle + protruding connector rectangles
  union(){
    cube([x_max,y_max,sheet_z], center=true);
    translate([-x_max/2-sheet_z/2,0,0]) cube([sheet_z,y1,sheet_z], center=true);
    translate([x_max/2+sheet_z/2,0,0]) cube([sheet_z,y1,sheet_z], center=true);
  }
}

module long_cutout(){
linear_extrude(height=sheet_z)
  polygon([
    [0,0],
    [(x_long_cutout_long_side-x_long_cutout_short_side)/2,-y_max/2],
    [(x_long_cutout_long_side-x_long_cutout_short_side)/2+x_long_cutout_short_side,-y_max/2],
    [x_long_cutout_long_side,0],
    [0,0]
  ]);
}

module short_cutout(){
linear_extrude(height=sheet_z)
  polygon([
    [0,0],
    [(x_short_cutout_long_side-x_short_cutout_short_side)/2,y_max/2],
    [(x_short_cutout_long_side-x_short_cutout_short_side)/2+x_short_cutout_short_side,y_max/2],
    [x_short_cutout_long_side,0],
    [0,0]
  ]);
}

module handle_arm(){
  render(convexity=10){
    difference(){
      translate([x_max/2,y_max/2,sheet_z/2]) base();
      translate([x1,y_max,0]) long_cutout();
      translate([x3,0,0]) short_cutout();
      translate([x2+sheet_z/2,y_max*3/16/2,sheet_z/2]) cube([sheet_z,y_max*3/16,sheet_z], center=true);
      translate([x2+sheet_z/2,y_max-y_max/4/2,sheet_z/2]) cube([sheet_z,y_max/4,sheet_z], center=true);
    }
  }
}

handle_arm();

