fun map(f, xs) = 
  case xs of [] => []
     | x::xs' => f(x)::map(f, xs')


val x1 = map(fn x => x + 1, [3,2,1,3]);
val x2 = map(hd, [[1,3], [32,21]])

fun filter(f, xs) = 
  case xs of [] => []
  | x::xs' => if f x then x::filter(f, xs') else filter(f, xs')

fun is_even v =
  (v mod 2 = 0)

fun all_even xs = filter(is_even, xs)

fun all_even_snd xs = filter(fn (_, v) => is_even(v), xs)