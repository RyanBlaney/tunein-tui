open LTerm_draw
open LTerm_geom
open LTerm_event
open Tunein_tui_types.Types

let draw_selector_window ctx size = 
  let padding = size.rows / 32 in
  let rect = { 
    row1 = (size.rows / 3 + padding * 4); 
    col1 = (size.cols / 3 + padding * 8); 
    row2 = (size.cols / 2); 
    col2 = size.cols - padding } in
  let label = Zed_string.of_utf8 "Info" in
  let style = { LTerm_style.none with bold = Some true; underline = Some false } in
  draw_frame_labelled ctx rect ~style ~alignment:H_align_center label LTerm_draw.Heavy;
  ()

let handle_select_song _ui _current_state = 
  Lwt.return_unit

let handle_navigation ui current_state = function 
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'h') ->
    current_state := LibraryActive;
    Lwt.return_unit
  | Key { code = LTerm_key.Enter; _ } ->
    handle_select_song ui current_state
  | _ -> Lwt.return_unit


