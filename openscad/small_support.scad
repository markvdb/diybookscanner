// To render the DXF file from the command line:
// openscad -x small_support.dxf -D'units="metric"' small_support.scad

module small_support(){
	include <global_constants.scad>;

	x1=379.8824;
	x2=698.5;
	x3=4061.46;
	x4=4254.5;
	y1=190.3730;
	y2=698.5;
	y3=1460.5;
	bolt_circle_middle_x=189.94;

	render (convexity = 10){
	    difference(){
	    linear_extrude(height=sheet_z) polygon([[0,0],[x3,0],[x3,y1],[x4,y1],[x4,y2],[x2,y2],[x1,y3],[0,y3],[0,0]]);
	    routing_circle(x3,y1-cnc_circle_r);
	    bolt_circle(bolt_circle_middle_x,304.8);
	    bolt_circle(bolt_circle_middle_x,812.8);
	    bolt_circle(bolt_circle_middle_x,1320.8);
	  }
	}
}
