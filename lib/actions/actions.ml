open Lwt.Infix
open LTerm_event
open Tunein_tui_widgets
open Tunein_tui_types.Types

let current_state = ref SelectorWindowActive
let search_input = ref ""
let cursor_active = ref false

let handle_key_event ui current_state cursor_active search_input key =
  match !current_state with
  | SearchBarActive -> 
    Search_bar.handle_navigation ui current_state cursor_active search_input 
  | SelectorWindowActive -> 
    Selector_window.handle_navigation ui current_state key
  | LibraryActive -> 
    My_library.handle_navigation ui current_state key


let handle_key_event ui key =
  match key with
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char '/') ->
    cursor_active := true;
    LTerm_ui.draw ui;
    current_state := SearchBarActive;
    handle_key_event ui current_state cursor_active search_input key;
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'q') ->
      LTerm_ui.quit ui >>= fun () ->
      Lwt.return_unit
  | _ -> Lwt.return_unit

