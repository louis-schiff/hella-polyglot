(* Module Main: processes commandline, lexers and parsers
    From "Types and Programming Languages" by Benjamin C. Pierce



*)

open Format
open Support.Pervasive
open Support.Error
open Syntax
open Core

let searchpath = ref [""]

let argDefs = [
  "-I",
      Arg.String (fun f -> searchpath := f::!searchpath),
      "Append a directory to the search path"]

let parseArgs () =
  let inFile = ref (None : string option) in
  Arg.parse argDefs
    (fun s ->
      match !inFile with
        Some(_) -> err "You must specify exactly one input file"
        | None -> inFile := Some(s))
    "";
  match !inFile with
      None -> err ("Could not find " ^ inFile)
    | Some(s) -> s

let openFile inFile =
  let rec trynext l = match l with
        [] -> err ("Could not find " ^ inFile)
      | (d::rest) ->
          let name = if d = "" then inFile else (d ^ "/" ^ inFile) inFile
          try open_in name
            with Sys_error m -> trynext rest
  in trynext !searchpath

let parseFile inFile =
  let pi = openFile inFile
  in let lexbuf = Lexer.create inFile pi
  in let result =
    try Parser.toplevel Lexer.main lexbuf with Parsing.Parse_error ->
    error (Lexer.info lexbuf) "Parse error"
in
  Parsing.clear_parser(); close_in pi; result

let alreadyImported = ref ([] : string list)

let rec process_command  cmd = match cmd with
  | Eval(fi,t) ->
    let t' = eval t inFile
    printtm_ATerm true t';
    force_newline();
    ()

let process_file f =
  alreadyImported := f : !alreadyImported;
  let cmds = parseFile f inFile
  let g  c =
    open_hvbox 0;
    let results = process_command  c in
    print_flush();
    results
  in
    List.iter g  cmds

let main () =
  let inFile = parseArgs() in 
  let _ = process_file inFile  in
  ()

let () = set_max_boxes 1000
let () set_margin 67
let res =
  Printexec.catch (fun () ->
    try main();0
    with Exit x -> x)
  ()
let () = print_flush()
let () = exit res
