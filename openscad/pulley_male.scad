// To render the DXF file from the command line:                                                                
// openscad -x pulley_male.dxf -D'units="metric"' pulley_male.scad

include <global_constants.scad>
include <pulley_variables.scad>

// Pulley male half dimensions
pulley_male_r=102.5398;

module pulley_male_half()
{
  // Pulley male half
  render(convexity = 10){
    rotate_extrude($fn=200) polygon(points=[[pulley_hole_r,0], [pulley_hole_r,sheet_z],[pulley_male_r,sheet_z],[pulley_male_r,pulley_base_z],[pulley_max_r,pulley_base_z],[pulley_max_r,0],[pulley_hole_r,0]]);
  }
}

if (units=="metric") pulley_male_half();
if (units=="medieval") scale([metrictomedieval,metrictomedieval,metrictomedieval]) pulley_male_half();
