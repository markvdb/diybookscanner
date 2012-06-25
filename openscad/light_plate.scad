// To render the DXF file from the command line:
// openscad -x light_plate.dxf -D'units="metric"' light_plate.scad

include <global_constants.scad>;

x1=381;//1.5"
x2=4572;//18"

x3=635;//2.5"
x4=858.8502;//3.3813"


y1=127;//.5"
y2=1524;//6"

y3=952.5;//3.75"
y4=1143;//4.5"

z1=63.5;//.25"

module light_plate(){
  difference(){
    linear_extrude(height=sheet_z)
      polygon([
        [0,0],
        [0,y2],[sheet_z,y2],[sheet_z,y2+y1],[sheet_z+y1,y2+y1],[x1,y2],
        [x2-x1,y2],[x2-sheet_z-y1,y2+y1],[x2-sheet_z,y2+y1],[x2-sheet_z,y2],[x2,y2],
        [x2,0],[x2-sheet_z,0],[x2-sheet_z,-y1],[x2-sheet_z-y1,-y1],[x2-x1,0],
        [x1,0],[sheet_z+y1,-y1],[sheet_z,-y1],[sheet_z,0],[0,0]]);
    routing_circle(sheet_z-cnc_circle_r,0);
    routing_circle(sheet_z-cnc_circle_r,y2);
    routing_circle(x2-sheet_z+cnc_circle_r,y2);
    routing_circle(x2-sheet_z+cnc_circle_r,0);
  }
}

module led_hole(){
  translate([x2/2,y2/2,sheet_z]) union(){
    translate([0,0,-sheet_z/2]) cube([x3,y3,sheet_z], center=true);
    translate([0,0,-z1/2]) cube([x4,y4,z1], center=true);
  }
}

render(convexity=10){
  difference(){
    light_plate();
    led_hole();
  }
}