// unit = 0.1 mm
// 1 inch = 25.4 mm = 254 units

// Dimensions

// Sheet dimensions
sheet_x=24400;
sheet_y=12200;
sheet_z=180;

// Circular cnc routing holes
cnc_circle_r=31.750;
module routing_circle(x,y){
  translate([x,y]) linear_extrude(height=sheet_z) circle(cnc_circle_r);
}

//Conversion
medievaltometric=254;
metrictomedieval=.0039370078;

// Use the metric system by default
// units="medieval";
units="metric";


