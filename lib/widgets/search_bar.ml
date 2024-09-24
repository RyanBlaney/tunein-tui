open Lwt.Infix
open LTerm_draw
open LTerm_geom
open LTerm_event
open LTerm_style
open Tunein_tui_types.Types
open Selector_window

open Tunein_tui_api_behavior.Search_for_stations

let frame_style current_state = 
  match current_state with
  | SearchBarActive ->
    { none with bold = Some true; underline = Some false; foreground = Some lblue }
  | _ ->
    { none with bold = Some true; underline = Some false; foreground = Some default }

let draw_search_bar ctx size input current_state = 
  let padding = size.rows / 32 in
  let rect = { 
    row1 = (size.rows / 3 + padding); 
    col1 = (size.cols / 3 + padding * 8); 
    row2 = (size.rows / 3 + padding * 4); 
    col2 = size.cols - padding } in
  let label = Zed_string.of_utf8 "Search" in
  let style = frame_style current_state in
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

  
let print_station_list station_list =
  List.iter (fun (name, url) ->
    Printf.printf "Station: %s\nURL: %s\n" name url
  ) station_list;
  Lwt.return_unit
  
let handle_search_input input selector_state ui =
  search_for_stations input >>= fun station_list ->
    selector_state.stations <- station_list;
    LTerm_ui.draw ui;
    Lwt.return_unit

let handle_navigation ui current_state cursor_active search_input selector_state =
    cursor_active := true;
    LTerm_ui.draw ui;
    let rec capture_input () =
      LTerm_ui.wait ui >>= function
      | Key { code = LTerm_key.Enter; _ } ->
          cursor_active := false;
          current_state := SelectorListActive;
          handle_search_input !search_input !selector_state ui >>= fun () ->
          LTerm_ui.draw ui;
          Lwt.return_unit
      | Key { code = LTerm_key.Escape; _ } ->
          cursor_active := false;
          current_state := LibraryActive;
          LTerm_ui.draw ui;
          Lwt.return_unit
      | Key { code = LTerm_key.Backspace; _ } ->
          if String.length !search_input > 0 then begin
            search_input := String.sub !search_input 0 (String.length !search_input - 1);
            LTerm_ui.draw ui;
            capture_input ()
          end else begin
            cursor_active := false;
            current_state := LibraryActive;
            LTerm_ui.draw ui;
            Lwt.return_unit
          end
      | Key { code = LTerm_key.Char c; _ } ->
          search_input := !search_input ^ String.make 1 (Uchar.to_char c);
          LTerm_ui.draw ui;
          capture_input ()
      | _ ->
          LTerm_ui.draw ui;
          capture_input ()
      in
    capture_input ()
