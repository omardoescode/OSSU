val cbs : (int -> unit) list ref = ref [] (* Initlize a reference of a list of callbacks saved for later -- can only pass int -> unit functions *)
fun onKeyEvent f = cbs := f::(!cbs) (* add this function to the collection *)

fun onEvent i = (* a function to call back all callbacks, the function will be given the same arguements as this function *)
	let fun loop fs=
    case fs of
		[] => ()
		| f::fs' => (f i; loop fs')
	in loop (!cbs) end

val timesPressed = ref 0
val _ = onKeyEvent (fn _  => timesPressed := (!timesPressed) + 1)
(* Every time onEvent <number> is called, timesPressed will increase by 1 *)

fun printIfPressed i = (* a function to add various callbacks *)
	onKeyEvent(fn j => if i = j 
		then print ("You pressed " ^ Int.toString i ^ "\n")
		else ())

val _ = printIfPressed 4
val _ = printIfPressed 11
val _ = printIfPressed 23
val _ = printIfPressed 4