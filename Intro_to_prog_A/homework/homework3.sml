(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

(* fun only_capitals ss = 
    case ss of [] => []
    | s::ss' => if Char.isUpper(String.sub(s, 0)) then s::only_capitals ss' else only_capitals ss' *)

val only_capitals = List.filter (fn s => Char.isUpper(String.sub(s, 0)))

(* fun longest_string1 words = 
    let 
        fun aux(words, acc) =
            case words of [] => acc |
            word::words' => if String.size(word) > String.size(acc) then aux(words', word) else aux(words', acc)
    in 
        aux(words, "")
    end *)

val longest_string1 = List.foldl (fn (word, acc) => if String.size(word) > String.size(acc) then word else acc) "" 


val longest_string2 = List.foldl (fn (word, acc) => if String.size(word) >= String.size(acc) then word else acc) ""

fun longest_string_helper func = List.foldl (fn (word, acc) => if func(String.size(word), String.size(acc)) then word else acc) ""
val longest_string3 = longest_string_helper (fn (x, y) => x > y)
val longest_string4 = longest_string_helper (fn (x, y) => x >= y)

val longest_capitalized = List.foldl (fn (word, acc) => if String.size(word) > String.size(acc) andalso Char.isUpper(String.sub(word, 0)) then word else acc) ""

fun rev_string s = String.implode (List.rev (String.explode s))

fun first_answer func ss = 
		case ss of [] => raise NoAnswer
			| s::ss' => 
			case func s of NONE => first_answer func ss'
				| SOME x => x
fun all_answers func ss = 
	let
	  fun helper ([], acc) = SOME acc
	  | helper(x::xs', acc) = 
	  	case (func x) of NONE => NONE
		| SOME lst => helper(xs', acc @ lst)
	in
		helper(ss, [])
	end

(* fun all_answers func ss =
  let
    fun helper([], acc) = SOME acc
      | (x::xs, acc) =
          case func x of
            NONE => NONE
          | SOME lst => helper(xs, acc @ lst)
  in
    helper(ss, [])
  end *)

val count_wildcards = g (fn () => 1) (fn x => 0)

val count_wild_and_variable_lengths = g (fn () => 1) (fn str => String.size(str))

fun count_some_var (str, p) = g (fn () => 0) (fn x => if String.compare(str, x) = EQUAL then 1 else 0) p

fun gather_vars p =
	case p of Wildcard => []
	| Variable x => [x]
	| TupleP ps => List.foldl (fn (p', acc) => acc @ gather_vars p') [] ps
	| ConstructorP (_, p) => gather_vars p 
	| _ => []

fun only_distinct ss = 
	case ss of [] => true |
	s::ss' => List.all (fn x => String.compare(s, x) <> EQUAL) ss' andalso only_distinct ss'

fun check_pat p = (only_distinct (gather_vars p))

fun match (v, p) = 
	case (v, p) of 
		(_, Wildcard) => SOME []
		| (v, Variable s) => SOME [(s, v)]
		| (Unit, UnitP) => SOME []
		| (Tuple vs, TupleP ps) => all_answers match (ListPair.zip(vs, ps))
		| (Const m, ConstP n) => if m = n then SOME [] else NONE
		| (Constructor (s1, v), ConstructorP (s2, p)) => if s1 = s2 then match (v, p) else NONE
		| _ => NONE

fun first_match v ps =
	SOME (first_answer (fn p => match(v, p)) ps) handle NoAnswer => NONE
(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

val test1a = only_capitals ["A","B","C"] = ["A","B","C"]
val test1b = only_capitals ["a", "A"] = ["A"]

val test2a = longest_string1 ["A","bc","Cc"] = "bc"
val test2b = longest_string1 [] = ""
val test2c = longest_string1 ["Omar", "Mohammad"] = "Mohammad"

val test3a = longest_string2 ["A","bc","C"] = "bc"
val test3b = longest_string2 ["A","bc","Cc"] = "Cc"
val test3c = longest_string2 ["Aa","bc","Cc"] = "Cc"
val test3d = longest_string2 [] = ""
val test3e = longest_string2 ["Omar", "Mohammad"] = "Mohammad"

val test4a = longest_string3 ["A","bc","Cc"] = "bc"
val test4b = longest_string3 [] = ""
val test4c = longest_string3 ["Omar", "Mohammad"] = "Mohammad"

val test5a = longest_string4 ["A","bc","C"] = "bc"
val test5b = longest_string4 ["A","bc","Cc"] = "Cc"
val test5c = longest_string4 ["Aa","bc","Cc"] = "Cc"
val test5d = longest_string4 [] = ""
val test5e = longest_string4 ["Omar", "Mohammad"] = "Mohammad"

val test6a = longest_capitalized ["A","bc","C"] = "A"
val test6b = longest_capitalized ["a","bc","c"] = ""

val test7a = rev_string "abc" = "cba"
val test7b = rev_string "Omar" = "ramO"
val test7c = rev_string "" = ""

val test8a = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4
val test8b = first_answer (fn x => if x > 2 then SOME x else NONE) [1,2,3,4,5] = 3
val test8c = (first_answer (fn x => if x > 2 then SOME x else NONE) [1,2]) = 3 handle NoAnswer => true

val test9a = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test9b = all_answers (fn x => if x = 1 then SOME [x] else NONE) [1,1,1,1,1] = SOME [1,1,1,1,1]

val test10a = count_wildcards Wildcard = 1
val test10b = count_wildcards (TupleP [Wildcard, Wildcard, Wildcard, UnitP]) = 3
val test10c = count_wildcards (TupleP [Wildcard, ConstructorP ("Omar", Wildcard)]) = 2

val test11a = count_wild_and_variable_lengths (Variable("a")) = 1
val test11b = count_wild_and_variable_lengths (Variable("AB")) = 2
val test11c = count_wild_and_variable_lengths (TupleP [Wildcard, Variable("AB")])= 3

val test12a = count_some_var ("x", Variable("x")) = 1
val test12b = count_some_var ("x", Variable "x") = 1
val test12c = count_some_var ("x", Wildcard) = 0
val test12d = count_some_var ("x", TupleP [Variable "x", Wildcard, Variable "x"]) = 2
val test12e = count_some_var ("y", TupleP [Variable "x", Wildcard, Variable "z"]) = 0
val test12f = count_some_var ("a", TupleP [Variable "a", Variable "a", Variable "a"]) = 3
val test12g = count_some_var ("var", TupleP [Wildcard, UnitP, ConstructorP ("cons", Variable "var")]) = 1


val test13a = check_pat (Variable("x")) = true
val test13b = check_pat (Variable "x") = true
val test13c = check_pat (TupleP [Variable "x", Variable "y", Variable "z"]) = true
val test13d = check_pat (TupleP [Variable "x", Variable "x", Variable "y"]) = false
val test13f = check_pat (TupleP [Wildcard, Variable "y", Wildcard, Variable "z"]) = true
val test13j = check_pat (TupleP [Variable "a", Variable "b", ConstructorP ("cons", Variable "a")]) = false

val test14a = match (Const(1), UnitP) = NONE
val test14b = match (Const 5, Variable "x") = SOME [("x", Const 5)]
val test14c = match (Const 5, Wildcard) = SOME []
val test14d = match (Constructor ("A", Const 10), ConstructorP ("A", Variable "y")) = SOME [("y", Const 10)]
val test14e = match (Constructor ("B", Const 10), ConstructorP ("A", Variable "y")) = NONE
val test14f = match (Tuple [Const 5, Const 6, Const 7], TupleP [Variable "x", Variable "y", Variable "z"]) = SOME [("x", Const 5), ("y", Const 6), ("z", Const 7)]
val test14g = match (Tuple [Const 10, Const 20, Const 30], TupleP [Variable "x", Wildcard, Variable "z"]) = SOME [("x", Const 10), ("z", Const 30)]
val test14h = match (Const 42, ConstP 42) = SOME []
val test14i = match (Const 42, ConstP 0) = NONE
val test12a = first_match Unit [UnitP] = SOME []
val test12b = first_match (Const 8) [UnitP, ConstP 8] = SOME []
val test12c = first_match (Const 8) [UnitP, Variable "x"] = SOME [("x", Const 8)]
