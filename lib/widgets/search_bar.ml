open LTerm_draw
open LTerm_geom

let draw_search_bar ctx size input = 
  let padding = size.rows / 32 in
  let rect = { 
    row1 = (size.rows / 3 + padding); 
    col1 = (size.cols / 3 + padding * 8); 
    row2 = (size.rows / 3 + padding * 4); 
    col2 = size.cols - padding } in
  let label = Zed_string.of_utf8 "Search" in
  let style = { LTerm_style.none with bold = Some true; underline = Some false } in
  draw_frame_labelled ctx rect ~style ~alignment:H_align_center label LTerm_draw.Heavy;
  
  (* Clear the content area, avoiding the border *)
  for row = rect.row1 + 1 to rect.row2 - 2  do
    draw_string ctx row (rect.col1 + 1) ~style:LTerm_style.none (Zed_string.of_utf8 (String.make (rect.col2 - rect.col1 - 2) ' '))
  done;
  
  (* Draw the input text *)
  let text_rect = { 
    row1 = rect.row1 + 1; 
    col1 = rect.col1 + 1; 
    row2 = rect.row2 - 1; 
    col2 = rect.col2 - 1 
  } in
  let label = Zed_string.of_utf8 input in
  draw_string ctx text_rect.row1 text_rect.col1 ~style:LTerm_style.none label;
  ()


