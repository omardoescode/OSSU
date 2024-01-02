val x = 42

fun f(y, z, w) = 
    if y (* y must be bool *)
    then z + x (* z must be int *)
    else 0 (* both branches have same type *)

(* val f: bool * int * 'a -> int *)

fun f x = 
    let val (y, z) = x
        in (abs y) + z
    end
(*  int * int -> int  *)

fun sum xs = case xs of [] => 0 | x::xs' => x + sum xs'

(* int list -> int *)

(* 
sum : T1 -> Ts
xs: T1

x: T3
xs: T3 list [pattern match a Ta]

T1 = T3 list
T2 = int [because 0 might be returned]
T3 = int [because x:T3 and we add x to something]
T1 = int list
T3 = int
 *)

fun length xs = 
    case xs of [] => 0 | x::xs' => 1 + (length xs)

(* 
length: T1 -> T2
xs: T1

x: T3
xs: T3 list

T1 = T3 list
T2 = int (from the zero and the one)

length: T3 list -> int
length: a' list -> int
 *)

fun absurd(x, y, z) = 
    if true then (x, y, z) else (y, x, z)

(* 
absurd: (T1, T2, T3) -> (T1, T2, T3)
(T1, T2, T3) = (T2, T1, T6) (due to the if statment requiring same results)

T1 = T2
absurd: (T1, T1, T3) -> (T1, T1, T3)
absurd: ('a, 'a, 'b) -> ('a, 'a, 'b)

 *)

 fun compose (f, g) = fn x => f (g x)

(* 
T1 -> T2

f: T3 -> T4
g: T5 -> T6
x: T7

T7 = T5 (Since x is a valid input to g)
T6 = T3 (since g(x) is a valid input to f)

compose: (T3 -> T4) * (T5 -> T3) -> (T5 -> T4)
compose: ('a -> 'b) * ('c -> 'a) -> ('c -> 'b)

*)