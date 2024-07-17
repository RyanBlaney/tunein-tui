open Lwt.Infix
open LTerm_event
open Tunein_tui_widgets.Logo
open Tunein_tui_widgets.My_library
open Tunein_tui_widgets.Search_bar
open Tunein_tui_widgets.Selector_window

let draw ui matrix =
  let size = LTerm_ui.size ui in
  let ctx = LTerm_draw.context matrix size in
  draw_logo ctx size;
  draw_library ctx size;
  draw_search_bar ctx size;
  draw_selector_window ctx size;
  ()

let main () =
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm_ui.create term (fun ui matrix ->
    draw ui matrix
  ) >>= fun ui ->
  let rec loop () =
    LTerm_ui.wait ui >>= function
    | Key { code = LTerm_key.Char c; _ } when Uchar.equal c (Uchar.of_char 'q') ->
        LTerm_ui.quit ui
    | _ ->
        loop ()
  in
  loop ()

let () = Lwt_main.run (main ())

