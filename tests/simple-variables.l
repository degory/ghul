var x;
var y;
let a;
let b;

var x: int;
var y: word[] ref ptr; // FIXME: semi colon not recognized here

var y: ARRAY[int ref];
var m: MAP[TOKEN,char ptr];

var x, y;

var function1: (int, int) -> int;

var function2: () -> word;

var return_tuple: (word, word) -> (word, word);

var return_function_return_tuplie: 
    (String, LIST[String]) ->
        (String[], MAP[TOKEN, int]) ->
            (int, THING[int], word[]);

var some_tuple: (int, int);

var should_error: ();

var should_error[];

var should_error: MAP[];


var x: int, y: bool;

var q = none, p = none, r = none; var n = none;

var l: bool = none;

var m = none, p, q:int, z: int = none;

var add = thing.x + thing.y;
var mul = bloop.a * gloop.b;
var div = c / d;



