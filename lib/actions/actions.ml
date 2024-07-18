open Lwt.Infix
open LTerm_event

let search_input = ref ""
let cursor_active = ref false

let handle_search_input input =
  Lwt_io.printf "Search input: %s\n" input

let handle_key_event ui key =
  match key with
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char '/') ->
    cursor_active := true;
    LTerm_ui.draw ui;
    let rec capture_input () =
      LTerm_ui.wait ui >>= function
      | Key { code = LTerm_key.Enter; _ } ->
          cursor_active := false;
          handle_search_input !search_input >>= fun () ->
          search_input := "";
          LTerm_ui.draw ui;
          Lwt.return_unit
      | Key { code = LTerm_key.Backspace; _ } ->
          if String.length !search_input > 0 then begin
            search_input := String.sub !search_input 0 (String.length !search_input - 1);
            LTerm_ui.draw ui;
            capture_input ()
          end else begin
            cursor_active := false;
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
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char '\n') ->
      handle_search_input !search_input >>= fun () ->
      LTerm_ui.draw ui;
      Lwt.return_unit
  | Key { code = LTerm_key.Backspace; _ } ->
      if String.length !search_input > 0 then begin
        search_input := String.sub !search_input 0 (String.length !search_input - 1);
        LTerm_ui.draw ui;
        Lwt.return_unit
      end else begin
        LTerm_ui.draw ui;
        Lwt.return_unit
      end
  | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'q') ->
      LTerm_ui.quit ui >>= fun () ->
      Lwt.return_unit
  | _ -> Lwt.return_unit


