// To render the DXF file from the command line:
// openscad -x cradle_lift_arm.dxf -D'units="metric"' cradle_lift_arm.scad

include <global_constants.scad>;

module cradle_lift_arm() {
  // outside dimensions
  x1=180.34;//.71"
  x2=356.5652;//1.4038
  x3=825.5;//3.25"
  x4=2476.5;//9.75"
  x5=2656.1288;//10.4572"
  x6=2730.5;//10.75"
  x7=444.5;//1.75"
  y1=317.5;//1.25"
  y2=762;//3"
  y3=833.7804;//3.2826"
  y4=1016;//4"
  y5=1192.8348;//4.6962"
  y6=1270;//5"
  y7=1714.5;//6.75"
  y8=2032;//8"


  render(convexity=10){
    difference(){
      linear_extrude(height=sheet_z) polygon([[0,0],[x1,0],[x2,0],[x2,y1],[x3,y2],[x4,y2],[x5,y3],[x6,y4],[x5,y5],[x4,y6],[x3,y6],[x2,y7],[x2,y8],[x1,y8],[0,y8],[0,0]]);
      bolt_circle(x4,y4);
      bolt_circle(x7,y4);
      translate([0,0,sheet_z-cradle_lift_arm_cutout_height]) cube([x1,y8,cradle_lift_arm_cutout_height]);
    }
  }
}