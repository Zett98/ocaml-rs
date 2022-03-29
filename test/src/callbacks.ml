open Util

external apply1: ('a -> 'a) -> 'a -> 'a = "apply1"
external apply3: ('a -> 'a) -> 'a -> 'a = "apply3"

let () = test "apply1 float" (fun () -> apply1 (( +. ) 1.0) 2.5 = 3.5)
let () = test "apply3 float" (fun () -> apply3 (( +. ) 1.0) (-1.0) = 2.0)
let () = test "apply3 string" (fun () -> apply3 (( ^ )  "A") "A" = "AAAA")
let () = test "apply3 apply1" (fun () -> apply3 (apply1 (( +. ) 1.0)) 1000.0 = 1003.0)

let () = test ~leak_check:false "apply1 failure" (fun () ->
  try apply1 (fun _ -> failwith "Testing") true
  with
    | Failure x -> let () = gc () in x = "Testing"
    | _ -> false
  )

let () = test ~leak_check:false "apply3 invalid_arg" (fun () ->
  (*TODO: figure out why this is failing leak check*)
  (*Util.check_leaks (fun () ->*)
    try apply3 (fun _ -> invalid_arg "Testing") true
    with
      | Invalid_argument x -> let () = Util.gc () in x = "Testing"
      | _ -> false)

external apply_range: (int list -> 'a) -> int -> int -> 'a = "apply_range"

let () = test "apply range 1" (fun () ->
  apply_range (List.map (fun a  -> let () = Util.gc () in a + 1)) 0 10 = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10])

let () = run "callbacks"
