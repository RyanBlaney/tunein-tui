open Lwt.Infix
open LTerm_event
open Tunein_tui_widgets
open Tunein_tui_types.Types
open Tunein_tui_widgets.Selector_window

let current_state = ref LibraryActive
let search_input = ref ""
let cursor_active = ref false
let selector_state = ref { stations = []; selected_index = 0 }

let handle_key_event ui current_state cursor_active search_input (selector_window_state : selector_window_state ref) key =
  match !current_state with
  | SearchBarActive -> 
    Search_bar.handle_navigation ui current_state cursor_active search_input selector_window_state
  | SelectorWindowActive -> 
    Selector_window.handle_navigation ui current_state selector_window_state key
  | SelectorListActive -> 
    Selector_window.handle_navigation ui current_state selector_window_state key
  | LibraryActive -> 
    My_library.handle_navigation ui current_state key
  | LogoActive ->
    Logo.handle_navigation ui current_state key


let handle_key_event ui key =
  match key with
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char '/') ->
    cursor_active := true;
    LTerm_ui.draw ui;
    current_state := SearchBarActive;
    handle_key_event ui current_state cursor_active search_input selector_state key;
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'q') ->
      LTerm_ui.quit ui >>= fun () ->
      Lwt.return_unit
  | _ -> 
    handle_key_event ui current_state cursor_active search_input selector_state key;



