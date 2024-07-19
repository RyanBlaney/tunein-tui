open LTerm_draw
open LTerm_geom
open LTerm_event
open LTerm_style
open Tunein_tui_types.Types

let frame_style current_state = 
  match current_state with
  | LibraryActive ->
    { none with bold = Some true; underline = Some false; foreground = Some lblue }
  | _ ->
    { none with bold = Some true; underline = Some false; foreground = Some default }

let draw_library ctx size current_state = 
  let padding = size.rows / 32 in
  let rect = { 
    row1 = (size.rows / 3 + padding); 
    col1 = padding; 
    row2 = (size.cols / 2); 
    col2 = (size.cols / 3 + (7 * padding)) } in
  let label = Zed_string.of_utf8 "My Library" in
  let style = frame_style current_state in
  draw_frame_labelled ctx rect ~style ~alignment:H_align_center label LTerm_draw.Heavy;
  ()

  
let handle_select_category _ui _current_state = 
  Lwt.return_unit

let handle_navigation ui current_state = function
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'l') ->
    current_state := SelectorWindowActive;
    LTerm_ui.draw ui;
    Lwt.return_unit
  | Key { code = LTerm_key.Enter; _ } ->
    handle_select_category ui current_state
  | _ -> Lwt.return_unit




