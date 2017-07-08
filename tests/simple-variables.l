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

let index_tuple = (a, b)[c];

let member_tuple = (a, b).b;

let typed = (a: int, b:int);

var tuple_named_elements: (a: int, b:int);

var tuple_anon_elements: (int, int);

var function_named_args: (a: int, b: int) -> int;

var func_return_tuple_named_elements: (int, int) -> (a: int, b: int);

var func_return_tuple_named_elements: (x: int, y: int) -> (a: int, b: int); // = (x: int, y: int) => (a: int = none, b: int = none);

var tuple_named_values: (a: int, b: int) = (a = c = c = none, b = none);




