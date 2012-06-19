// To render the DXF file from the command line:                                                                
// openscad -x pulley_female.dxf -D'units="metric"' pulley_female.scad

include <global_constants.scad>
include <pulley_variables.scad>

module pulley_female_half(){
  // Pulley female half dimensions
  pulley_female_r_e=153.5684; //0.6046"
  pulley_female_r_i=101.5492; //0.3998"

  // Pulley female half
  render(convexity = 10){
    rotate_extrude($fn=200) polygon(points=[[pulley_hole_r,0], [pulley_hole_r,pulley_base_z],[pulley_female_r_i,pulley_base_z],[pulley_female_r_i,180],[pulley_female_r_e,180],[pulley_female_r_e,pulley_base_z],[pulley_max_r,pulley_base_z],[pulley_max_r,0],[pulley_hole_r,0]]);
  }
}

if (units=="metric") pulley_female_half();
if (units=="medieval") scale([metrictomedieval,metrictomedieval,metrictomedieval]) pulley_female_half();
