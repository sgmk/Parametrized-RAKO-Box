// Parametric Rako Box (Eurobox) - Simplified Edition
// Accurately models the Utz frame construction with a continuous draft angle
// Units in mm
//
// Standard Rako / Eurobox Base Dimensions (L x W):
// - 200 x 150 mm
// - 300 x 200 mm
// - 400 x 300 mm
// - 600 x 400 mm
// - 800 x 600 mm
// 
// Standard Heights (H):
// - 65, 117, 145, 170, 220, 278, 325, 425 mm

// --- User Parameters ---

/* [Render Options] */
// Which part to render
part = "box"; // ["box", "lid", "lid_upper", "lid_lower", "both", "assemble"]
// Height at which to split the lid for 3D printing (creates lid_upper and lid_lower)
lid_split_z = 2.0;

/* [Global Dimensions] */
// Use standard Rako dimensions or custom values below
use_standard_dimensions = true;

// Standard Base Size (L x W)
standard_base = "400x300"; // ["200x150", "300x200", "400x300", "600x400", "800x600"]
// Standard Height
standard_height = 170; // [65, 117, 145, 170, 220, 278, 325, 425]
// Master thickness for all structural rims, flanges, ribs, and main walls
rim_width = 4.0;
// Thickness of the main drafted skin walls
wall_thickness = 4.0;
// Add snap-on C-hinges to the back edge
add_hinges = true;
// Enable the lid closure slots in the top rim
enable_closing_holes = true;

/* [Custom Dimensions] */
// (These are only used if 'use_standard_dimensions' is unchecked)
custom_length = 300;
// Custom Width
custom_width = 200;
// Custom Height
custom_height = 117;

/* [Features] */
// Number of small triangular supports evenly spaced under the top rim per side
support_triangles = 4; // [0:10]
// Add corner triangular supports under the top rim
support_corners = true;
// 3D Printing Overhang Angle for the supports (from vertical Z-axis). Higher is a shallower slope, easier to print.
support_angle = 50.0; // [30:70]
// Add built-in breakaway support rails under the bottom stacking foot rim
add_bottom_supports = false;
// Vertical Z-gap between the built-in supports and the printed overhang (usually 1 layer height)
support_z_gap = 0.2;

/* [Text Options] */
// Text embossed on the front long side
text_front = "400x300x170";
// Text embossed on the back long side
text_back = "SGMK";
// Font style for the text
text_font = "Arial:style=Bold";
// Font size
text_size = 25.0;
// How far the embossed text protrudes outwards from the wall
text_thickness = 2.0;

/* [Appearance] */
// The color of the rendered box in OpenSCAD
box_color = "HotPink"; // ["DimGray": Dark Grey, "Silver": Light Grey, "FireBrick": Red, "HotPink": Hot Pink, "SteelBlue": Blue, "DarkGreen": Green, "Goldenrod": Yellow, "Black": Black, "White": White]
// The color of the rendered lid in OpenSCAD
lid_color = "SteelBlue"; // ["DimGray": Dark Grey, "Silver": Light Grey, "FireBrick": Red, "HotPink": Hot Pink, "SteelBlue": Blue, "DarkGreen": Green, "Goldenrod": Yellow, "Black": Black, "White": White]
// ==============================================================================
// --- Hidden / Advanced Parameters ---
// Everything below this line is hidden from the Customizer to keep it simple!
module __Customizer_Limit__(){}
// ==============================================================================

// Derived Dimensions from the toggle
length =
  use_standard_dimensions ?
    (
      standard_base == "200x150" ? 200
      : standard_base == "300x200" ? 300
      : standard_base == "400x300" ? 400
      : standard_base == "600x400" ? 600 : 800
    )
  : custom_length;

width =
  use_standard_dimensions ?
    (
      standard_base == "200x150" ? 150
      : standard_base == "300x200" ? 200
      : standard_base == "400x300" ? 300
      : standard_base == "600x400" ? 400 : 600
    )
  : custom_width;

height = use_standard_dimensions ? standard_height : custom_height;

// Global draft taper: how much the entire box leans inwards towards the bottom per side (creates the stacking angle)
draft_amt = 4.0;
// Base corner radius of the absolute outer bounding box
corner_r = 18.0;

// Tier 1 (Absolute Outer Bounds): How far in the widest parts sit
inset_t1 = 0.0; // Upper Lip
// Tier 2 (The Frame): How far in the structural framework sits
inset_t2 = 1.0; // Lower lip, Bottom flange, Vertical Ribs
// Tier 3 (The Skin): How far in the main thin walls sit
inset_t3 = 12.0; // Main Wall, Top Rim Groove

// Height of the stacking foot at the very bottom (fits inside the box below it)
h_foot = 10.0;
// Height of the structural bottom flange
h_flange_bot = rim_width;
// Height of the triangular corner gussets (mini ribs) at the bottom corners
h_gusset = 20.0;

// Height of the structural lower flange of the top rim
h_flange_top = rim_width;
// Height of the recessed groove in the top rim
h_groove = 20.0;
// Height of the absolute upper lip at the top rim
h_lip = rim_width;

// Thickness of the absolute bottom floor of the box
t_bottom = rim_width;

// Thickness of the main flat lid plane
lid_plate_thickness = rim_width;
// Thickness of the rims and ridges on the lid
lid_rim_thickness = 4.0;
// Height of the stacking rims on top of the lid
lid_rim_h_top = 9.0;
// Height of the inner alignment skirt dropping into the box
lid_rim_h_bot = 11.0;
// The size of the gap in the middle of the lid rims
lid_gap_size = 40.0;
// Length of the side lifting handles
lid_handle_len = 50.0;
// Distance from the front edge to the center of the side handles
lid_handle_pos = 50.0;
// Height of the side lifting handles (typically less than the rim)
lid_handle_h = 6.0;

// Thickness of the C-hinge plastic
hinge_thickness = 8.0;
// How far the back edge of the lid is cut inwards to make room for hinges
hinge_cutout_depth = 8.0;
// Position of the hinge inwards from the absolute outer edge of the box
hinge_y_offset = 3.0;
// Vertical position of the hinge center (0 = flush with top of box rim)
hinge_z_offset = -3.0;
// Inner diameter of the C-clip (matches the pin it snaps onto)
hinge_inner_diameter = 8.0;

// Radius of the supportive fillet curve underneath the bottom rim
fillet_bot_r = 2.0;
// Radius of the supportive fillet curves underneath the top rim's flanges
fillet_top_r = 10.0;
// Radius of the smoothing fillet curves on the upper top-side of the horizontal rims
fillet_upper_r = 2.0;

// Width/Size of the corner triangle masks (controls how wide the bottom corner gussets spread)
corner_w = 40.0;
// Thickness of the vertical structural ribs
rib_w = rim_width;
// Distance of the vertical ribs from the corners (Length / Ratio). Higher number pushes ribs closer to corner.
rib_inset_ratio = 6.0;

// The width of the rectangular closure slots
hole_width = 22.0;
// How far the slot cuts inwards (Y depth) into the upper rim plastic
hole_depth = 8.0;
// How far the slots are positioned away from the corners
hole_dist_from_corner = 50.0;
// How far the slots are inset from the absolute outer edge of the upper lip
hole_inset_from_edge = 4.0;

eps = 0.05;

// --- Derived Dimensions (Do not edit) ---
t_rim = inset_t3 + wall_thickness; // Main cavity inset based on wall thickness

// For the box to stack, the bottom foot must be smaller than the top cavity.
// The top cavity is inset by `t_rim`. The bottom outer wall is inset by `inset_t3 + draft_amt`.
// If the walls are too thick, we must step the foot further inwards so it still fits!
foot_clearance = 1.0;
foot_inset = inset_t3 + max(0, t_rim - (inset_t3 + draft_amt) + foot_clearance);

// --- Helper Modules ---
module corner_rib_masks() {
  union() {
    // Front-Left
    translate([0, 0, 0]) rotate([0, 0, 45]) translate([0, -rib_w / 2, 0]) cube([corner_w, rib_w, height]);
    // Front-Right
    translate([length, 0, 0]) rotate([0, 0, 135]) translate([0, -rib_w / 2, 0]) cube([corner_w, rib_w, height]);
    // Back-Left
    translate([0, width, 0]) rotate([0, 0, -45]) translate([0, -rib_w / 2, 0]) cube([corner_w, rib_w, height]);
    // Back-Right
    translate([length, width, 0]) rotate([0, 0, -135]) translate([0, -rib_w / 2, 0]) cube([corner_w, rib_w, height]);
  }
}

module rounded_rect(l, w, r) {
  if (r > 0) {
    hull() {
      translate([r, r]) circle(r=r, $fn=32);
      translate([l - r, r]) circle(r=r, $fn=32);
      translate([l - r, w - r]) circle(r=r, $fn=32);
      translate([r, w - r]) circle(r=r, $fn=32);
    }
  } else {
    square([l, w]);
  }
}

// The core module that generates a drafted shell for any tier
module drafted_shell(inset, z_start, z_end) {
  // Top base
  l_top = length - 2 * inset;
  w_top = width - 2 * inset;
  r_top = max(corner_r - inset, 1.0);

  // Bottom base (at z=0)
  l_base = length - 2 * draft_amt - 2 * inset;
  w_base = width - 2 * draft_amt - 2 * inset;
  r_base = max(corner_r - draft_amt - inset, 1.0);

  // Interpolate at z_start
  f_start = z_start / height;
  l_s = l_base + f_start * (l_top - l_base);
  w_s = w_base + f_start * (w_top - w_base);
  r_s = max(r_base + f_start * (r_top - r_base), 1.0);

  // Interpolate at z_end
  f_end = z_end / height;
  l_e = l_base + f_end * (l_top - l_base);
  w_e = w_base + f_end * (w_top - w_base);
  r_e = max(r_base + f_end * (r_top - r_base), 1.0);

  hull() {
    translate([(length - l_s) / 2, (width - w_s) / 2, z_start])
      linear_extrude(eps) rounded_rect(l_s, w_s, r_s);
    translate([(length - l_e) / 2, (width - w_e) / 2, z_end - eps])
      linear_extrude(eps) rounded_rect(l_e, w_e, r_e);
  }
}

// Module for the triangular corner gussets (tapers from one inset to another)
module tapered_shell(inset_bot, inset_top, z_start, z_end) {
  hull() {
    // Base slice at z_start
    f_start = z_start / height;
    l_base_s = (length - 2 * draft_amt - 2 * inset_bot) + f_start * (2 * draft_amt);
    w_base_s = (width - 2 * draft_amt - 2 * inset_bot) + f_start * (2 * draft_amt);
    r_base_s = max(corner_r - draft_amt - inset_bot + f_start * draft_amt, 1.0);
    translate([(length - l_base_s) / 2, (width - w_base_s) / 2, z_start])
      linear_extrude(eps) rounded_rect(l_base_s, w_base_s, r_base_s);

    // Top slice at z_end
    f_end = z_end / height;
    l_top_e = (length - 2 * draft_amt - 2 * inset_top) + f_end * (2 * draft_amt);
    w_top_e = (width - 2 * draft_amt - 2 * inset_top) + f_end * (2 * draft_amt);
    r_top_e = max(corner_r - draft_amt - inset_top + f_end * draft_amt, 1.0);
    translate([(length - l_top_e) / 2, (width - w_top_e) / 2, z_end - eps])
      linear_extrude(eps) rounded_rect(l_top_e, w_top_e, r_top_e);
  }
}

// Module for a concave curved fillet UNDER a horizontal overhang
// inset_wall is the inset of the vertical wall below the overhang
// fillet_r is the radius of the fillet
// z_end is the height of the horizontal overhang
module fillet_shell_down(inset_wall, fillet_r, z_end) {
  n_steps = 10;
  z_start = z_end - fillet_r;
  inset_top = inset_wall - fillet_r;

  for (i = [0:n_steps - 1]) {
    z1 = z_start + (i / n_steps) * fillet_r;
    z2 = z_start + ( (i + 1) / n_steps) * fillet_r;

    inset1 = inset_top + fillet_r * sqrt(1 - pow((z1 - z_start) / fillet_r, 2));
    inset2 = inset_top + fillet_r * sqrt(1 - pow((z2 - z_start) / fillet_r, 2));

    tapered_shell(inset1, inset2, z1, z2);
  }
}

// Module for a concave curved fillet ON TOP of a horizontal overhang
// inset_wall is the inset of the vertical wall above the overhang
// fillet_r is the radius of the fillet
// z_start is the height of the horizontal overhang
module fillet_shell_up(inset_wall, fillet_r, z_start) {
  n_steps = 10;
  z_end = z_start + fillet_r;
  inset_flange = inset_wall - fillet_r;

  for (i = [0:n_steps - 1]) {
    z1 = z_start + (i / n_steps) * fillet_r;
    z2 = z_start + ( (i + 1) / n_steps) * fillet_r;

    inset1 = inset_flange + fillet_r * sqrt(1 - pow((z1 - z_end) / fillet_r, 2));
    inset2 = inset_flange + fillet_r * sqrt(1 - pow((z2 - z_end) / fillet_r, 2));

    tapered_shell(inset1, inset2, z1, z2);
  }
}

// --------------------------------------------------------
// --- Module: Lid Handle Shape ---
// --------------------------------------------------------
module lid_handle() {
  hull() {
    // Base on the main plate
    translate([0, -lid_handle_len / 2, 0])
      cube([lid_handle_h, lid_handle_len, eps]);
    // Raised top edge (flush with the outer edge)
    translate([0, -(lid_handle_len / 2 - lid_handle_h), lid_handle_h])
      cube([eps, lid_handle_len - 2 * lid_handle_h, eps]);
  }
}

// --------------------------------------------------------
// --- Module: Lid Hinge (Snap-on C-hook) ---
// --------------------------------------------------------
module lid_hinge() {
  h_width = hole_width - 1.0;

  r_in = hinge_inner_diameter / 2;
  r_out = r_in + hinge_thickness / 2;

  y_cyl = -hinge_y_offset;
  y_edge = -hinge_cutout_depth;

  // Z-heights
  z_cyl = hinge_z_offset;
  z_edge = lid_plate_thickness / 2; // Center on the lid plate itself

  difference() {
    union() {
      // Swept C-clip with perfectly rounded jaws
      angle_top = 20; // Long top jaw
      angle_bot = -50; // Short bottom jaw for easy snap-in
      t = (r_out - r_in) / 2;
      R = r_in + t;

      translate([0, y_cyl, z_cyl])
        rotate([0, 90, 0])
          translate([0, 0, -h_width / 2])
            linear_extrude(h_width) {
              union() {
                for (a = [angle_top:5:360 + angle_bot - 5]) {
                  hull() {
                    translate([-R * sin(a), R * cos(a)]) circle(r=t, $fn=16);
                    translate([-R * sin(a + 5), R * cos(a + 5)]) circle(r=t, $fn=16);
                  }
                }
              }
            }

      // Connecting Shaft (Diagonal downwards)
      hull() {
        // Anchor at the lid edge
        translate([0, y_edge + eps / 2, z_edge])
          cube([h_width, eps, hinge_thickness], center=true);
        // Anchor at the cylinder center
        translate([0, y_cyl, z_cyl])
          cube([h_width, eps, r_out * 2], center=true);
      }
    }

    // Inner Hole (Pin clearance) - cleans out any stem hull that entered the center
    translate([0, y_cyl, z_cyl])
      rotate([0, 90, 0])
        cylinder(r=r_in, h=h_width + 2 * eps, center=true, $fn=32);
  }
}

// --- Main Module ---
module rako_box() {

  // Derived Z heights
  z_foot_top = h_foot;
  z_bot_flange_top = z_foot_top + h_flange_bot;

  // Constant rib distance from corners guarantees exactly 2 ribs on every face
  rib_dist = length / rib_inset_ratio;

  h_rim_top = h_lip + h_groove + h_flange_top;
  z_top_flange_bot = height - h_rim_top;
  z_groove_bot = z_top_flange_bot + h_flange_top;
  z_lip_bot = z_groove_bot + h_groove;

  difference() {
    // --- ADDITIONS (The Solid Frame) ---
    union() {
      // 1. Bottom Stacking Foot
      drafted_shell(foot_inset, 0, z_foot_top);

      // 1.5 Fillet below Bottom Flange
      if (fillet_bot_r > 0) {
        fillet_shell_down(foot_inset, fillet_bot_r, z_foot_top);
      }

      // 2. Bottom Flange (Tier 2)
      drafted_shell(inset_t2, z_foot_top, z_bot_flange_top);
      // 2.5 Fillet on top of Bottom Flange
      if (fillet_upper_r > 0) {
        fillet_shell_up(inset_t3, fillet_upper_r, z_bot_flange_top);
      }

      // 3. Main Skin Walls (Tier 3 - Drafted)
      drafted_shell(inset_t3, z_bot_flange_top, z_top_flange_bot);

      // 4. Corner Gussets (Triangular mini ribs)
      intersection() {
        tapered_shell(inset_t2, inset_t3, z_bot_flange_top, z_bot_flange_top + h_gusset);
        // 4 Radial corner rib masks
        corner_rib_masks();
      }

      // 5. Vertical Ribs (Tier 2)
      intersection() {
        difference() {
          drafted_shell(inset_t2, z_bot_flange_top, z_top_flange_bot);
          drafted_shell(inset_t3, z_bot_flange_top - eps, z_top_flange_bot + eps);
        }
        union() {
          // Rib masks along Length (Front & Back)
          translate([rib_dist - rib_w / 2, -eps, 0])
            cube([rib_w, width + 2 * eps, height]);
          translate([length - rib_dist - rib_w / 2, -eps, 0])
            cube([rib_w, width + 2 * eps, height]);

          // Rib masks along Width (Left & Right)
          translate([-eps, rib_dist - rib_w / 2, 0])
            cube([length + 2 * eps, rib_w, height]);
          translate([-eps, width - rib_dist - rib_w / 2, 0])
            cube([length + 2 * eps, rib_w, height]);
        }
      }

      // 5.5 Small Triangular Supports under Top Rim
      if (support_triangles > 0 || support_corners) {
        h_supp1 = max((inset_t3 - inset_t2) / tan(support_angle), 0.1);
        support_triangles_w = max(0, round(support_triangles * (width / length)));

        intersection() {
          tapered_shell(inset_t3, inset_t2, z_top_flange_bot - h_supp1, z_top_flange_bot);
          union() {
            if (support_triangles > 0) {
              // Masks along Length (Front & Back)
              for (i = [1:support_triangles]) {
                translate([i * (length / (support_triangles + 1)) - rib_w / 2, -eps, 0])
                  cube([rib_w, width + 2 * eps, height]);
              }
              // Masks along Width (Left & Right)
              if (support_triangles_w > 0) {
                for (i = [1:support_triangles_w]) {
                  translate([-eps, i * (width / (support_triangles_w + 1)) - rib_w / 2, 0])
                    cube([length + 2 * eps, rib_w, height]);
                }
              }
            }
            if (support_corners) {
              corner_rib_masks();
            }
          }
        }
      }

      // 6. Top Rim - Lower Flange (Tier 2)
      if (fillet_top_r > 0) fillet_shell_down(inset_t3, fillet_top_r, z_top_flange_bot);
      drafted_shell(inset_t2, z_top_flange_bot, z_groove_bot);

      // 6.5 Fillet on top of Top Rim Lower Flange
      if (fillet_upper_r > 0) fillet_shell_up(inset_t3, fillet_upper_r, z_groove_bot);

      // 7. Top Rim - Recessed Groove (Tier 3)
      drafted_shell(inset_t3, z_groove_bot, z_lip_bot);

      // 8. Top Rim - Upper Lip (Tier 1)
      if (fillet_top_r > 0) fillet_shell_down(inset_t3, fillet_top_r, z_lip_bot);
      drafted_shell(inset_t1, z_lip_bot, height);

      // 8.5 Small Triangular Supports under Upper Lip
      if (support_triangles > 0 || support_corners) {
        h_supp2 = max((inset_t3 - inset_t1) / tan(support_angle), 0.1);
        support_triangles_w = max(0, round(support_triangles * (width / length)));

        intersection() {
          tapered_shell(inset_t3, inset_t1, z_lip_bot - h_supp2, z_lip_bot);
          union() {
            if (support_triangles > 0) {
              // Masks along Length (Front & Back)
              for (i = [1:support_triangles]) {
                translate([i * (length / (support_triangles + 1)) - rib_w / 2, -eps, 0])
                  cube([rib_w, width + 2 * eps, height]);
              }
              // Masks along Width (Left & Right)
              if (support_triangles_w > 0) {
                for (i = [1:support_triangles_w]) {
                  translate([-eps, i * (width / (support_triangles_w + 1)) - rib_w / 2, 0])
                    cube([length + 2 * eps, rib_w, height]);
                }
              }
            }
            if (support_corners) {
              corner_rib_masks();
            }
          }
        }
      }

      // 9. Embossed Text (Main Skin Wall)
      if (text_front != "" || text_back != "") {
        text_z = (z_bot_flange_top + z_top_flange_bot) / 2;
        f_text = text_z / height;
        y_front = inset_t3 + (1 - f_text) * draft_amt;
        draft_angle = atan(draft_amt / height);

        if (text_front != "") {
          translate([length / 2, y_front, text_z])
            rotate([90 + draft_angle, 0, 0])
              linear_extrude(text_thickness)
                text(text_front, size=text_size, font=text_font, halign="center", valign="center");
        }

        if (text_back != "") {
          translate([length / 2, width - y_front, text_z])
            rotate([0, 0, 180])
              rotate([90 + draft_angle, 0, 0])
                linear_extrude(text_thickness)
                  text(text_back, size=text_size, font=text_font, halign="center", valign="center");
        }
      }
    }

    // --- SUBTRACTIONS (The Hollow Cavity) ---
    // 1. Main drafted cavity (smooth taper from bottom all the way to top)
    drafted_shell(t_rim, t_bottom, height + eps);

    // 2. Closing Mechanism Holes (Top Rim)
    if (enable_closing_holes) {
      // Cut from the top down into the upper lip, and through the fillet below it
      hole_z = height - h_lip - fillet_top_r - eps;
      hole_h = h_lip + fillet_top_r + 2 * eps;

      // Push holes outward toward corners
      h_dist = hole_dist_from_corner;

      // Long side holes only (Front & Back)
      // Front holes
      translate([h_dist - hole_width / 2, hole_inset_from_edge, hole_z])
        cube([hole_width, hole_depth, hole_h]);
      translate([length - h_dist - hole_width / 2, hole_inset_from_edge, hole_z])
        cube([hole_width, hole_depth, hole_h]);

      // Back holes
      translate([h_dist - hole_width / 2, width - hole_inset_from_edge - hole_depth, hole_z])
        cube([hole_width, hole_depth, hole_h]);
      translate([length - h_dist - hole_width / 2, width - hole_inset_from_edge - hole_depth, hole_z])
        cube([hole_width, hole_depth, hole_h]);
    }
  }
}

// --- Lid Module ---
module rako_lid() {
  union() {
    difference() {
      union() {
        // 1. Main Lid Plate
        lid_w = add_hinges ? width - hinge_cutout_depth : width;
        linear_extrude(lid_plate_thickness) {
          rounded_rect(length, lid_w, corner_r);
        }

        // 1b. Side Lifting Handles (Solid tops)
        translate([0, lid_handle_pos, lid_plate_thickness])
          lid_handle();
        translate([length, lid_handle_pos, lid_plate_thickness])
          mirror([1, 0, 0]) lid_handle();

        // 2. Inner Alignment Rim (drops down into the box to prevent sliding)
        // Inner cavity of the box at the top is length - 2*t_rim.
        // We make the alignment rim 1mm smaller for clearance.
        align_l = length - 2 * t_rim - 2.0;
        align_w = width - 2 * t_rim - 2.0;
        align_r = max(corner_r - t_rim - 1.0, 1.0);

        translate([0, 0, -lid_rim_h_bot])
          difference() {
            linear_extrude(lid_rim_h_bot) {
              translate([(length - align_l) / 2, (width - align_w) / 2])
                rounded_rect(align_l, align_w, align_r);
            }
            // Hollow it out
            translate([0, 0, -eps])
              linear_extrude(lid_rim_h_bot + 2 * eps) {
                inner_l = align_l - 2 * lid_rim_thickness;
                inner_w = align_w - 2 * lid_rim_thickness;
                inner_r = max(align_r - lid_rim_thickness, 1.0);
                translate([(length - inner_l) / 2, (width - inner_w) / 2])
                  rounded_rect(inner_l, inner_w, inner_r);
              }
          }

        // 3. Stacking Plateau (on top of the lid, to accept the foot of another box)
        // The bottom of the box is smaller due to global draft_amt.
        foot_outer_l = length - 2 * draft_amt - 2 * foot_inset;
        foot_outer_w = width - 2 * draft_amt - 2 * foot_inset;
        foot_outer_r = max(corner_r - draft_amt - foot_inset, 1.0);

        // Make the pocket 1mm larger for clearance
        pocket_l = foot_outer_l + 2.0;
        pocket_w = foot_outer_w + 2.0;
        pocket_r = foot_outer_r + 1.0;

        // Outer ridge is lid_rim_thickness wider than the pocket
        ridge_l = pocket_l + 2 * lid_rim_thickness;
        ridge_w = pocket_w + 2 * lid_rim_thickness;
        ridge_r = pocket_r + lid_rim_thickness;

        // 3. Segmented Stacking Rims (4 continuous sides with middle gaps)
        translate([0, 0, lid_plate_thickness])
          difference() {
            // The base full continuous ridge
            difference() {
              linear_extrude(lid_rim_h_top) {
                translate([(length - ridge_l) / 2, (width - ridge_w) / 2])
                  rounded_rect(ridge_l, ridge_w, ridge_r);
              }
              translate([0, 0, -eps])
                linear_extrude(lid_rim_h_top + 2 * eps) {
                  translate([(length - pocket_l) / 2, (width - pocket_w) / 2])
                    rounded_rect(pocket_l, pocket_w, pocket_r);
                }
            }

            // Subtract the 45-degree gaps in the exact middle of all 4 sides
            translate([length / 2, width / 2, 0]) {
              // Cut front and back (along X)
              union() {
                hull() {
                  translate([-lid_gap_size / 2, -(width + 2 * eps) / 2, 0])
                    cube([lid_gap_size, width + 2 * eps, eps]);
                  translate([-(lid_gap_size / 2 + lid_rim_h_top), -(width + 2 * eps) / 2, lid_rim_h_top])
                    cube([lid_gap_size + 2 * lid_rim_h_top, width + 2 * eps, eps]);
                }
                translate([-lid_gap_size / 2, -(width + 2 * eps) / 2, -eps])
                  cube([lid_gap_size, width + 2 * eps, eps]);
              }

              // Cut left and right (along Y)
              union() {
                hull() {
                  translate([-(length + 2 * eps) / 2, -lid_gap_size / 2, 0])
                    cube([length + 2 * eps, lid_gap_size, eps]);
                  translate([-(length + 2 * eps) / 2, -(lid_gap_size / 2 + lid_rim_h_top), lid_rim_h_top])
                    cube([length + 2 * eps, lid_gap_size + 2 * lid_rim_h_top, eps]);
                }
                translate([-(length + 2 * eps) / 2, -lid_gap_size / 2, -eps])
                  cube([length + 2 * eps, lid_gap_size, eps]);
              }
            }
          }
      }

      // 4. Clip Holes (align with closing mechanism slots in the box)
      if (enable_closing_holes) {
        h_dist = hole_dist_from_corner;
        latch_depth = hole_depth;
        latch_width = hole_width;

        // Cut completely through the lid
        latch_h = lid_plate_thickness * 3;
        latch_z = -lid_plate_thickness;

        // The box hole cuts inwards from hole_inset_from_edge
        latch_y = hole_inset_from_edge;

        // Front holes
        translate([h_dist - latch_width / 2, latch_y, latch_z])
          cube([latch_width, latch_depth, latch_h]);
        translate([length - h_dist - latch_width / 2, latch_y, latch_z])
          cube([latch_width, latch_depth, latch_h]);

        // Back holes
        // If hinges are added, we don't cut the clip holes.
        // The main plate is already generated narrower to clear the hinge pins.
        if (!add_hinges) {
          translate([h_dist - latch_width / 2, width - latch_y - latch_depth, latch_z])
            cube([latch_width, latch_depth, latch_h]);
          translate([length - h_dist - latch_width / 2, width - latch_y - latch_depth, latch_z])
            cube([latch_width, latch_depth, latch_h]);
        }
      }

      // 5. Hollow out the lifting handles from below
      translate([0, lid_handle_pos, 0])
        lid_handle();
      translate([length, lid_handle_pos, 0])
        mirror([1, 0, 0]) lid_handle();
    }
    // End of difference

    // 6. Optional Snap-On Hinges on the back edge
    // Added after difference so they don't get cut by the clip holes
    if (add_hinges) {
      translate([hole_dist_from_corner, width, 0])
        lid_hinge();
      translate([length - hole_dist_from_corner, width, 0])
        lid_hinge();
    }
  }
}

// --- Render ---
if (part == "box") {
  color(box_color) rako_box();
} else if (part == "lid") {
  color(lid_color) rako_lid();
} else if (part == "lid_upper") {
  // Drop the upper part down to Z=0 so it prints flat on the bed
  translate([0, 0, -lid_split_z])
    color(lid_color)
      intersection() {
        rako_lid();
        // Bounding box from lid_split_z upwards
        translate([-50, -50, lid_split_z])
          cube([length + 100, width + 100, lid_plate_thickness + lid_rim_h_top + lid_handle_h + 50]);
      }
} else if (part == "lid_lower") {
  color(lid_color)
    intersection() {
      rako_lid();
      // Bounding box from lid_split_z downwards
      translate([-50, -50, -lid_rim_h_bot - 50])
        cube([length + 100, width + 100, lid_rim_h_bot + 50 + lid_split_z]);
    }
} else if (part == "both") {
  color(box_color) rako_box();
  translate([0, width + 50, 0]) color(lid_color) rako_lid();
} else if (part == "assemble") {
  color(box_color) rako_box();
  // Render the lid on top, slightly transparent so the snap-fit can be inspected
  translate([0, 0, height]) color(lid_color, 0.85) rako_lid();
}
