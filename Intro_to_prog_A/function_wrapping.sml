fun n_times (f, n, x) =
    if n = 0
    then x
    else f (n_times(f, n - 1, x))

(* fun nth_tail(n, xs) = n_times((fn y => tl y), n, xs) *)
fun nth_tail(n, xs) = n_times(tl, n, xs)

(* Unnesscary function Wrapping *)
fun rev xs = List.rev xs

fun rev = List.rev
