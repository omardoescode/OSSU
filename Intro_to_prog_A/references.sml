val x = ref 42 (* x is bound to 42 *)
val y = ref 42 (* y is bound to 42 *)
val z = x (* Now z is bound to x updating when x is upadated *)
val _ = x := 43 (* update the value of x *)
val w = (!y) + (!z)
(* x + 1 does not type-check, you cannot add an int and a ref *)
