// To render the DXF file from the command line:
// openscad -x light_plate_support.dxf -D'units="metric"' light_plate_support.scad

include <global_constants.scad>;

module light_plate_support(light_plate_support_width){
  light_plate_support_width=3662.68;//14.42
  x1=180;//0.71"
  x2=317.5;//1.25""
  x3=434.34;//1.71"
  x4=1069.34;//4.21"
  x5=(light_plate_support_width/2);
  
  y1=127;//.5"
  y2=1206.5;//4.75"
  y3=1333.5;//5.25"
  y4=1468.12;//5.78"
  light_plate_support_height=1651;//6.5"

  module light_plate_support_half(){

    render (convexity = 10){
      difference(){
        linear_extrude(height=sheet_z) polygon([[0,y1],[0,y3],[x2,light_plate_support_height],[x4,light_plate_support_height],[x4,y4],[x5,y4],[x5,y2],[x3,y2],[x3,0],[x1,0],[x1,y1],[0,y1]]);
        routing_circle(x1,y1-cnc_circle_r);
        routing_circle(x4,y4+cnc_circle_r);
        }
      }
    }
  union(){
    light_plate_support_half();
    //translate([x5*2,0,sheet_z]) rotate([0,180,0]) light_plate_support_half();
    translate([x5*2,0,sheet_z]){ 
      rotate([0,180,0]) light_plate_support_half();
    }
  }
}

//light_plate_support();
