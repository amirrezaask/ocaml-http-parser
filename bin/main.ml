open Base;;

let () =
  match Http_request.from_string "GET http://localhost:1323/api/v2/asset/167\nAuthorization: Bearer {{jwtToken}}\nContent-Type: application/json\n\n{\"name\": \"amirreza\"}" with
  | Ok req -> (
    Stdlib.Printf.printf "%s\n" req.meth;
    Stdlib.Printf.printf "%s\n" req.url;
    List.iter req.headers ~f:(fun (key, value) -> Stdlib.Printf.printf "H:'%s=%s'\n" key value);
    Stdlib.Printf.printf "%s\n" req.body;
  )
  | Error msg -> Stdlib.Printf.printf "%s" msg
;;
