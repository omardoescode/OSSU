fun sorted3_tupled (x,y,z) = z >= y andalso y >= x

val t1 = sorted3_tupled (7,9,11)

(* new_way *)

val sorted3 = fn x => fn y => fn z => z >= y andalso y >= x

val t2 = ((sorted3 7) 9) 11
val t3 = sorted3 7 9 11

fun sorted3_nicer x y z = z >= y andalso y >= x

val t4 = sorted3_nicer 7 9 11
val t5 = ((sorted3_nicer 7) 9) 11


fun fold f acc xs = 
    case xs of [] => acc
    | x :: xs' => fold f (f(acc, xs)) xs'

fun sum xs = fold (fn(x,y) => x + y) 0 xs