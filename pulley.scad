// unit = 0.1 mm
// 1 inch = 25.4 mm = 254 units

// Dimensions

// Sheet dimensions
sheet_z=180;

// Pulley dimensions
pulley_max_r=255.2446; //1.0049"
pulley_hole_r=41.8338; //0.1647"
pulley_base_z=50.46;//sheet -.51" or 12.954mm

// Pulley male half dimensions
pulley_male_r=102.5398; //0.4037"

// Pulley female half dimensions
pulley_female_r_e=153.5684; //0.6046"
pulley_female__r_i=101.5492; //0.3998"

// Objects

//Difference renders incorrectly otherwise
render(convexity = 10){

difference()
{
  union(){
    // Pulley half base cylinder
    translate([0,0,pulley_base_z/2])
    {
      cylinder(pulley_base_z, r = pulley_max_r, center = true);
    }

    // Pulley male half central cylinder
    translate([0,0,sheet_z/2])
    {
      cylinder(sheet_z, r = pulley_male_r, center = true);
    }
  }//end union
  
  // Pulley half hole
  translate([0,0,sheet_z/2])
  {
    cylinder(sheet_z, r = pulley_hole_r, center = true);
  }

}//end difference

}