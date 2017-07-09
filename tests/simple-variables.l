var x;
var y;
let a;
let b;


var x: int;
var y: word[] ref ptr; 

var y: ARRAY[int ref];
var m: MAP[TOKEN,char ptr];

var x, y;

var return_simple: (int, int) -> int;

var function1: (int, int) -> int;

var function2: () -> int;

var return_tuple: (int, int) -> (int, int);

var return_tuple: (word, word) -> (word, word);


var return_function_return_tuple: 
    (String, LIST[String]) ->
        (String[], MAP[TOKEN, int]) ->
            (int, THING[int], word[]);

var some_tuple: (int, int);

// var should_error: ();

// var should_error[];

// var should_error: MAP[,];

var x: int, y: bool;

var q = none, p = none, r = none; var n = none;

var l: bool = none;

var m = none, p, q:int, z: int = none;

var blah: int = thing.field + other.thing.field;

var tuple = (a, b, c);

let fresult = function(x, y, y);

let paren = (a + b) * (c + d);

let foftuple = function((a, b, c));

let foff = function(function(a + b), function(c + d), (e => e * e)(f));

let index_tuple = (a, b)[c];

var func_return_tuple_named_elements: (x: int, y: int) -> (a: int, b: int) = (x: int, y: int) => (a: int = none, b: int = none);

var tuple_named_values: (a: int, b: int) = (a = none, b = none);

let member_tuple = (a, b).b;

let typed = (a: int, b:int);

var tuple_named_elements: (a: int, b:int);

var tuple_anon_elements: (int, int);

var function_named_args: (a: int, b: int) -> int;

var func_return_tuple_named_elements: (int, int) -> (a: int, b: int);

let no_args_implicit_type_function = () => x;

let no_args_explicit_type_function = () -> int => x;

let single_implicit_type_arg_implicit_type_function = x => x * x;

let single_implicit_type_arg_explicit_type_function = x -> int => x * x;

let single_explicit_type_arg_explicit_typed_function = (x: int) -> int => x + x;

let multi_implicit_type_args_implicit_type_function = (a, b, c) => a + b + c;

let multi_explicit_type_args_explicit_type_function = (a: int, b: int, c: int) -> int => a + b + c;


let construct_and_call_no_args_implicit_type_function = (() => none)();

let construct_and_call_no_args_explicit_type_function = (() -> int => none)();

let construct_and_call_single_implicit_type_arg_implicit_typed_function = ((x: int) => x + x)(y);

let construct_and_call_single_argument_explicit_typed_function = (x -> int => x * x)(y);

let construct_and_call_multi_argument_implicit_typed_function = ((x, y, z) => x + y + z)(a, b, c);

let construct_and_call_multi_argument_explicit_typed_function = ((x: int, y: int, z: int) -> int => x + y + z)(y);

let construct_and_call_multi_argument_explicit_typed_function_return_tuple = ((x: int, y: int, z: int) -> (int, int) => (x + y, y + z))(a, b, c);


let a = none;

let b = none;

let c = none;

let t = none;




