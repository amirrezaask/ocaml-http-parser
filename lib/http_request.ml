open Base;;

type t = {
    meth: string;
    url: string;
    headers: (string * string) list;
    body: string;
};;

let get_method s =
    match String.lsplit2 ~on:' ' s with
        | Some (meth,tl) -> Ok (meth, tl)
        | _ -> Error "method cannot be parsed"
;;

let get_url s =
    match String.lsplit2 ~on:'\n' s with
        | Some (meth,tl) -> Ok (meth, tl)
        | _ -> Error "url cannot be parsed"
;;

let single_header header =
    match (String.lsplit2 ~on:':' header) with
    | Some(key, value) -> Ok (key, value)
    | _ -> Error "single header cannot be parsed"
;;

let rec get_headers headers s =
    match String.lsplit2 ~on:'\n' s with
       | Some("", tl) -> Ok (headers, tl)
       | Some(header, tl) -> (match single_header header with
           | Ok hd  -> get_headers (hd :: headers) tl
           | Error msg -> Error msg)
       | None -> (match String.lsplit2 ~on:':' s with
          | Some hd -> Ok (hd :: headers, "")
          | _ -> Error "error")
;;

let get_body s = Ok(s, "");;

let from_string s =
    match get_method s with
    | Ok (meth, s) -> (match get_url s with
        | Ok (url, s) -> (match get_headers [] s with
            | Ok (headers, s) -> (match get_body s with
                | Ok (body, _) -> Ok { meth = meth; url = url; headers = headers; body = body }
                | Error msg -> Error msg)
            | Error msg -> Error msg)
        | Error msg -> Error msg)
    | Error msg -> Error msg

