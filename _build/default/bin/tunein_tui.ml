open Lwt.Infix
open LTerm_geom
open Tunein_tui_widgets.Logo
open Tunein_tui_widgets.My_library
open Tunein_tui_widgets.Search_bar
open Tunein_tui_widgets.Selector_window
open Tunein_tui_actions.Actions

let size = ref { rows = 0; cols = 0 }
let cursor_position = ref { row = 0; col = 0 }

let update_cursor_position () =
  cursor_position := {
    row = (!size.rows / 3 + !size.rows / 32 + 1);
    col = (!size.cols / 3 + !size.rows / 32 * 8 + 1 + String.length !search_input)
  }

let draw ui matrix =
  size := LTerm_ui.size ui;
  let ctx = LTerm_draw.context matrix !size in
  draw_logo ctx !size !current_state;
  draw_library ctx !size !current_state;
  draw_search_bar ctx !size !search_input !current_state;
  draw_selector_window ctx !size !current_state selector_state;
  update_cursor_position ();
  LTerm_ui.set_cursor_position ui !cursor_position;
  LTerm_ui.set_cursor_visible ui !cursor_active;
  ()

let main () =
  Lazy.force LTerm.stdout >>= fun term ->
  LTerm_ui.create term (fun ui matrix ->
    draw ui matrix;
  ) >>= fun ui ->
  let rec loop () =
    LTerm_ui.wait ui >>= fun event ->
    handle_key_event ui event >>= fun () ->
    loop ()
  in
  loop ()

let () = Lwt_main.run (main ())


