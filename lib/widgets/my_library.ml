open LTerm_draw
open LTerm_geom

let draw_library ctx size = 
  let padding = size.rows / 32 in
  let rect = { row1 = (size.rows / 3 + padding); col1 = padding; row2 = (size.cols / 2); col2 = (size.cols / 3 + (7 * padding)) } in
  let label = Zed_string.of_utf8 "My Library" in
  let style = { LTerm_style.none with bold = Some true; underline = Some false } in
  draw_frame_labelled ctx rect ~style ~alignment:H_align_center label LTerm_draw.Heavy;
  ()


