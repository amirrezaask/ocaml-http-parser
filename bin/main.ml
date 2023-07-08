open Base;;
open Stdio;;

let () =
  match Request.from_string "GET http://localhost:1323/api/v2/asset/167\nAuthorization: Bearer {{jwtToken}}\nContent-Type: application/json\n\n{\"name\": \"amirreza\"}" with
  | Ok req -> printf "%s" (Request.show req)
  | Error msg -> Stdlib.Printf.printf "%s" msg
;;
