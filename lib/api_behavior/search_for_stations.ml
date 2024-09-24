
open Lwt.Infix
open Cohttp_lwt_unix

let urlencode s =
  let buffer = Buffer.create (String.length s * 3) in
  String.iter (function
    | 'A'..'Z' | 'a'..'z' | '0'..'9' | '-' | '_' | '.' | '~' as c ->
        Buffer.add_char buffer c
    | c ->
        Buffer.add_string buffer (Printf.sprintf "%%%02X" (Char.code c))
  ) s;
  Buffer.contents buffer

let fetch_url url =
  Client.get (Uri.of_string url) >>= fun (resp, body) ->
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  (* Printf.printf "Response body: %s\n%!" body; *)
  (resp, body)

let parse_xml xml_string =
  let input = Xmlm.make_input (`String (0, xml_string)) in
  let rec parse_nodes acc =
    try
      match Xmlm.input input with
      | `El_start ((ns, name), attrs) ->
        let formatted_attrs = List.map (fun ((_, n), v) -> (n, v)) attrs in
        parse_nodes (`El_start ((ns, name), formatted_attrs) :: acc)
      | `El_end -> parse_nodes (`El_end :: acc) 
      | `Data data -> parse_nodes (`Data data :: acc) 
      | `Dtd _ -> parse_nodes acc 
    with
    | End_of_file -> List.rev acc
    | Xmlm.Error ((_line, _col), _err) ->
      (* Printf.eprintf "XML error at line %d, column %d: %s\n%!" line col (Xmlm.error_message err); *)
      List.rev acc 
  in
  parse_nodes []


let extract_name_and_url attrs =
  let name = List.assoc_opt "text" attrs in
  let url = List.assoc_opt "URL" attrs in
  match name, url with
  | Some name, Some url -> Some (name, url)
  | _ -> None

let find_stations nodes =
  let stations = ref [] in

  let rec aux = function
    | [] -> List.rev !stations
    | `El_start ((_, "outline"), attrs) :: tl when List.exists (fun (n, v) -> n = "type" && v = "audio") attrs &&
                                                    List.exists (fun (n, v) -> n = "item" && v = "station") attrs ->
        (match extract_name_and_url attrs with
         | Some station ->
             stations := station :: !stations;
             aux tl
         | None -> aux tl)
    | _ :: tl -> aux tl
  in
  aux nodes

let play_url url =
  let player = "vlc" in
  let check_command = Printf.sprintf "which %s > /dev/null 2>&1" player in
  Lwt_process.exec (Lwt_process.shell check_command) >>= function
  | Unix.WEXITED 0 ->
      let cmd = Printf.sprintf "%s --qt-start-minimized \"%s\" > /dev/null 2>&1 &" player url in
      (* Lwt_io.printf "Playing URL: %s\n%!" url >>= fun () -> *)
      (* Start VLC without waiting for it to finish and without capturing the process *)
      ignore (Lwt_process.open_process_none (Lwt_process.shell cmd));
      Lwt.return_unit
  | _ ->
      Lwt_io.printf "This program requires VLC media player to be installed and executable.\n" >>= fun () ->
      Lwt.return_unit

let search_for_stations pattern =
  let api_target = Printf.sprintf "http://opml.radiotime.com/Search.ashx?query=%s" (urlencode pattern) in
  fetch_url api_target >>= fun (_, body) ->
  let nodes = parse_xml body in
  let stations = find_stations nodes in
  Lwt.return stations


