// To render the DXF file from the command line:
// openscad -x large_support.dxf -D'units="metric"' large_support.scad

include <global_constants.scad>;

x1=180;//0.7107"
x2=406.4;//1.6""
x3=693.2676;//2.7294"
x4=1270;//5"
x5=2349.5;//9.25"
x6=2857.50;//11.25"
x7=3365.5;//13.25"
x8=3667.4552;//14.4388"

y1=190.5;//.75"
y2=381;//1.5"
y3=571.5;//2.25"
y4=1587.5;//6.25"
y5=2392.68;//9.42"
y6=3619.5;//14.25"
y7=4073.8298;//16.0387"
y8=4254.5;//16.75"


render (convexity = 10){
    difference(){
    linear_extrude(height=sheet_z) polygon([[0,0],[0,y7],[x1,y7],[x1,y8],[x3,y8],[x3,y5],[x4,y2],[x8,y2],[x8,0],[0,0]]);
    routing_circle(x1-cnc_circle_r,y7);
    bolt_circle(x2,y6);
    bolt_circle(x2,y4);
    bolt_circle(x2,y3);
    bolt_circle(x5,y1);
    bolt_circle(x6,y1);
    bolt_circle(x7,y1);

  }
}
