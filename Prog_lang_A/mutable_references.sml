val x = ref 42
val y = ref 42
val z = x
val _ = x := 43
val w = (!y) + (!z)
(* x + 1 does not type-check *)