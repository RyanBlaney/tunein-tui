open LTerm_draw
open LTerm_geom

let draw_selector_window ctx size = 
  let padding = size.rows / 32 in
  let rect = { 
    row1 = (size.rows / 3 + padding); 
    col1 = (size.cols / 3 + (9 * padding)); 
    row2 = (size.rows / 3 + padding * 4); 
    col2 = size.cols - padding } in
  let label = Zed_string.of_utf8 "Info" in
  let style = { LTerm_style.none with bold = Some true; underline = Some false } in
  draw_frame_labelled ctx rect ~style ~alignment:H_align_center label LTerm_draw.Heavy;
  ()


