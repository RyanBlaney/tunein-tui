open LTerm_draw
open LTerm_geom
open LTerm_event
open Tunein_tui_types.Types


let draw_library ctx size = 
  let padding = size.rows / 32 in
  let rect = { 
    row1 = (size.rows / 3 + padding); 
    col1 = padding; 
    row2 = (size.cols / 2); 
    col2 = (size.cols / 3 + (7 * padding)) } in
  let label = Zed_string.of_utf8 "My Library" in
  let style = { LTerm_style.none with bold = Some true; underline = Some false } in
  draw_frame_labelled ctx rect ~style ~alignment:H_align_center label LTerm_draw.Heavy;
  ()

  
let handle_select_category _ui _current_state = 
  Lwt.return_unit

let handle_navigation ui current_state = function
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'l') ->
    current_state := SelectorWindowActive;
    Lwt.return_unit
  | Key { code = LTerm_key.Enter; _ } ->
    handle_select_category ui current_state
  | _ -> Lwt.return_unit




