open LTerm_geom
open LTerm_style
open LTerm_event
open Tunein_tui_types.Types

(* let logo = "                                  _____   _   _ *)
(*                                  |_   _| | \\ | | *)
(*  _____   _    _   _   _   _____    | |   |  \\| | *)
(* |_   _| | |  | | | \\ | | |  ___|   | |   | . ` | *)
(*   | |   | |  | | |  \\| | | |___   _| |_  | |\\  | *)
(*   | |   | |  | | | . ` | |  ___| |_____| |_| \\_| *)
(*   | |   | |__| | | |\\  | | |___ *)
(*   |_|    \\____/  |_| \\_| |_____|" *)
(**)

let logo = "
                                   ┏━━━━━━━━━━━━━━━━━┓
                                   ┃  _____   _   _  ┃                
                                   ┃ |_   _| | \\ | | ┃
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫   | |   |  \\| | ┃
┃  _____   _    _   _   _   _____  ┃   | |   | . ` | ┃
┃ |_   _| | |  | | | \\ | | |  ___| ┃  _| |_  | |\\  | ┃
┃   | |   | |  | | |  \\| | | |___  ┃ |_____| |_| \\_| ┃
┃   | |   | |  | | | . ` | |  ___| ┃                 ┃
┃   | |   | |__| | | |\\  | | |___  ┣━━━━━━━━━━━━━━━━━┛
┃   |_|    \\____/  |_| \\_| |_____| ┃
┃                                  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"


let frame_style current_state = 
  match current_state with
  | LogoActive ->
    { none with bold = Some true; underline = Some false; foreground = Some lblue }
  | _ ->
    { none with bold = Some true; underline = Some false; foreground = Some default }


let draw_logo ctx size current_state =
  let padding = size.rows / 32 in
  let lines = String.split_on_char '\n' logo in
  let style = frame_style current_state in
  List.iteri (fun i line ->
    LTerm_draw.draw_string ctx i padding (Zed_string.of_utf8 line) ~style
  ) lines


let handle_select_logo _ui _current_state = 
  Lwt.return_unit

let handle_navigation ui current_state = function
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'l') ->
    current_state := SearchBarActive;
    LTerm_ui.draw ui;
    Lwt.return_unit
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'j') ->
    current_state := LibraryActive;
    LTerm_ui.draw ui;
    Lwt.return_unit
  | Key { code = LTerm_key.Enter; _ } ->
    handle_select_logo ui current_state
  | _ -> Lwt.return_unit
