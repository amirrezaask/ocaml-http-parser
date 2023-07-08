let simple_test () = 
    let req = Request.from_string "GET http://localhost:1323/api/v2/asset/167\nAuthorization: Bearer {{jwtToken}}\nContent-Type: application/json\n\n{\"name\": \"amirreza\"}" in
    match req with
    | Ok { meth = meth; url = url; body = body; headers = headers } ->
    begin
        let open Alcotest in
        check (option string) "method" (Some "GET") meth;
        check (option string) "url" (Some "http://localhost:1323/api/v2/asset/167") url;
        check (option string) "body" (Some "{\"name\": \"amirreza\"}") body;
        check (option (list (pair string string))) "headers" 
            (Some [("Content-Type", "application/json"); 
                ("Authorization", "Bearer {{jwtToken}}"); ]) headers;
    end
    | Error err -> Alcotest.fail (Printf.sprintf "failed: %s" err)
;;



let () =
    let open Alcotest in
    run "http request parsing" [
        ("", [ test_case "simple" `Quick simple_test ]);
    ]
