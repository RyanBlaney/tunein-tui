open LTerm_draw
open LTerm_geom
open LTerm_event
open LTerm_style
open Tunein_tui_types.Types
open Tunein_tui_api_behavior.Search_for_stations

type selector_window_state = {
  mutable stations: (string * string) list; 
  mutable selected_index: int;
}

let frame_style current_state = 
  match current_state with
  | SelectorWindowActive ->
    { none with bold = Some true; underline = Some false; foreground = Some lblue }
  | _ ->
    { none with bold = Some true; underline = Some false; foreground = Some default }

let draw_selector_window ctx size current_state (state : selector_window_state ref) = 
  let padding = size.rows / 32 in
  let rect = { 
    row1 = (size.rows / 3 + padding * 4); 
    col1 = (size.cols / 3 + padding * 8); 
    row2 = (size.cols / 2); 
    col2 = size.cols - padding } in
  let label = Zed_string.of_utf8 "Info" in
  let style = frame_style current_state in
  draw_frame_labelled ctx rect ~style ~alignment:H_align_center label LTerm_draw.Heavy;

  (* Clear the content area, avoiding the border *) 
  for row = rect.row1 + 1 to rect.row2 - 2 do
    draw_string ctx row (rect.col1 + 1) ~style:LTerm_style.none (Zed_string.of_utf8 (String.make (rect.col2 - rect.col1 - 2) ' '))
  done;

  List.iteri (fun i (name, _url) ->
    let row = rect.row1 + 1 + i in
    if row < rect.row2 then begin
      let style = if i = !state.selected_index then { none with foreground = Some magenta; bold = Some true }
        else { LTerm_style.none with foreground = Some default; bold = Some false } in
      
      draw_string ctx row (rect.col1 + 1) ~style (Zed_string.of_utf8 name)
    end
  ) !state.stations
  

let handle_select_song state = 
  match List.nth_opt state.stations state.selected_index with
  | Some (_name, url) -> play_url url
  | None -> Lwt.return_unit

let handle_navigation (ui : LTerm_ui.t) (current_state : app_state ref) (state : selector_window_state ref) = function
  | Key { code = _; _ } as key -> (
      match !current_state with
      | SelectorWindowActive -> (
          match key with
          | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'h') ->
              current_state := LibraryActive;
              LTerm_ui.draw ui;
              Lwt.return_unit
          | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'k') ->
              current_state := SearchBarActive;
              LTerm_ui.draw ui;
              Lwt.return_unit
          | Key { code = LTerm_key.Enter; _ } ->
              current_state := SelectorListActive;
              LTerm_ui.draw ui;
              Lwt.return_unit
          | _ -> Lwt.return_unit
        )
      | SelectorListActive -> (
          match key with
            | Key { code = LTerm_key.Enter; _ } ->
                handle_select_song !state
            | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'j') ->
                if !state.selected_index < List.length !state.stations - 1 then
                  !state.selected_index <- !state.selected_index + 1;
                LTerm_ui.draw ui;
                Lwt.return_unit
            | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'k') ->
                if !state.selected_index > 0 then
                  !state.selected_index <- !state.selected_index - 1;
                  LTerm_ui.draw ui;
                Lwt.return_unit
            | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'h') ->
                if !state.selected_index > 5 then
                  !state.selected_index <- !state.selected_index - 5;
                LTerm_ui.draw ui;
                Lwt.return_unit
            | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'l') ->
                if !state.selected_index < List.length !state.stations - 6 then
                  !state.selected_index <- !state.selected_index + 5;
                LTerm_ui.draw ui;
                Lwt.return_unit
            | Key { code = LTerm_key.Escape; _ } ->
                current_state := SelectorWindowActive;
                LTerm_ui.draw ui;
                Lwt.return_unit
            | _ -> Lwt.return_unit
        )
      | _ -> Lwt.return_unit
    )
  | _ -> Lwt.return_unit


