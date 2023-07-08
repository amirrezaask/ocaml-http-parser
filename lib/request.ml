open Base;;

type t = {
    meth: string option;
    url: string option;
    headers: (string * string) list option;
    body: string option;
} [@@deriving show]

let (let>) res f =
    match res with
    | Ok v -> f v
    | Error err -> Error err
;;
let (let*) op f =
    match op with
    | Some v -> f v
    | None -> Error "none"
;;

let get_method req s =
    let* (meth, tl) =  String.lsplit2 ~on:' ' s in
    Ok ({ req with meth = Some meth }, tl)
;;

let get_url req s =
    let* (url, tl) =  String.lsplit2 ~on:'\n' s in
    Ok ({ req with url = Some url }, tl)
;;

let single_header header =
    let* (key, value) = String.lsplit2 ~on:':' header in
    Ok (key, Stdlib.String.trim value)
;;

let rec get_headers headers req s =
    match String.lsplit2 ~on:'\n' s with
    | Some("", tl) -> Ok ({ req with headers = Some headers }, tl)
    | Some(header, tl) ->
        begin
            match single_header header with
            | Ok hd  -> get_headers (hd :: headers) req tl
            | Error msg -> Error msg
        end
    | None ->
        begin
            match String.lsplit2 ~on:':' s with
            | Some hd -> Ok ({ req with headers =  Some (hd :: headers) }, "")
            | _ -> Error "error"
        end

;;
let get_body req s = Ok({ req with body = Some s}, "") ;;

let from_string s =
    let req = { meth = None; url = None; headers = None; body = None } in
    let> (req, s) = get_method req s in
    let> (req, s) = get_url req s in
    let> (req, s) = get_headers [] req s in
    let> (req, _) = get_body req s in
    Ok req


let meth req = req.meth;;
let url req = req.url;;
let headers req = req.headers;;
let body req = req.body;;
