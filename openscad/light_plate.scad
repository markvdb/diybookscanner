// To render the DXF file from the command line:
// openscad -x light_plate.dxf -D'units="metric"' light_plate.scad

include <global_constants.scad>;

x1=381;//1.5"
light_plate_width=4572;//18"

x3=635;//2.5"
x4=858.8502;//3.3813"


y1=127;//.5"
light_plate_depth=1524;//6"

y3=952.5;//3.75"
y4=1143;//4.5"

z1=63.5;//.25"

module light_plate_no_hole(){
  difference(){
    linear_extrude(height=sheet_z)
      polygon([
        [0,0],
        [0,light_plate_depth],[sheet_z,light_plate_depth],[sheet_z,light_plate_depth+y1],[sheet_z+y1,light_plate_depth+y1],[x1,light_plate_depth],
        [light_plate_width-x1,light_plate_depth],[light_plate_width-sheet_z-y1,light_plate_depth+y1],[light_plate_width-sheet_z,light_plate_depth+y1],[light_plate_width-sheet_z,light_plate_depth],[light_plate_width,light_plate_depth],
        [light_plate_width,0],[light_plate_width-sheet_z,0],[light_plate_width-sheet_z,-y1],[light_plate_width-sheet_z-y1,-y1],[light_plate_width-x1,0],
        [x1,0],[sheet_z+y1,-y1],[sheet_z,-y1],[sheet_z,0],[0,0]]);
    routing_circle(sheet_z-cnc_circle_r,0);
    routing_circle(sheet_z-cnc_circle_r,light_plate_depth);
    routing_circle(light_plate_width-sheet_z+cnc_circle_r,light_plate_depth);
    routing_circle(light_plate_width-sheet_z+cnc_circle_r,0);
  }
}

module led_hole(){
  translate([light_plate_width/2,light_plate_depth/2,sheet_z]) union(){
    translate([0,0,-sheet_z/2]) cube([x3,y3,sheet_z], center=true);
    translate([0,0,-z1/2]) cube([x4,y4,z1], center=true);
  }
}

module light_plate(){
  render(convexity=10){
	  difference(){
	    light_plate_no_hole();
	    led_hole();
	  }
	}
}

light_plate();
