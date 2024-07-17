open Lwt.Infix
open LTerm_event
(* open LTerm_read_line *)

let search_input = ref ""

let handle_search_input input =
  Lwt_io.printf "Search input: %s\n" input

let handle_key_event ui key =
  match key with
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char '/') ->
      (* (* Focus on search bar *) *)
      (* let read_line = new read_line in *)
      (* read_line >>= fun input -> *)
      (* search_input := input; *)
      LTerm_ui.draw ui;
      Lwt.return_unit
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char '\n') ->
      (* Trigger search action *)
      handle_search_input !search_input >>= fun () ->
      LTerm_ui.draw ui;
      Lwt.return_unit
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'q') ->
      LTerm_ui.quit ui
  | _ -> Lwt.return_unit


