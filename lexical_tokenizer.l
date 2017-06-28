// copyright 2004-2017 degs <junk@giantblob.com> all rights reserved

import stream;

namespace Lexical is
    use System.Object;
    use System.String;
    use System.StringBuffer;
    use System.Exception;

    class TOKEN_BUFFER is
        const int MAX = 32;  // maximum lookahead before we assume we're not in a generic type

        int read_pos;
        int write_pos;

        TOKEN_PAIR[] values, temp;

        void init() is
            values = new TOKEN_PAIR[MAX*2];   // additional space to accomodate turning single '>>'
            temp = new TOKEN_PAIR[MAX*2];     // tokens into two token sequence close-generic close-generic
            read_pos = 0;
            write_pos = 0;
        si

        void reset() is
            // IO.Std.err.println( "clear buffer..." );
            read_pos = 0;
            write_pos = 0;
        si

        get bool avail is
            return read_pos < write_pos;
        si
       
        get bool is_full is
            return write_pos >= MAX;
        si

        void write( TOKEN_PAIR t ) is
            // IO.Std.err.println( "buffer token: " + cast int(t.token) + ", string: " + t.string );
            values[write_pos] = t;
            write_pos = write_pos + 1;
        si

        TOKEN_PAIR read() is
            TOKEN_PAIR result = values[read_pos];
            read_pos = read_pos + 1;
            // IO.Std.err.println( "read buffered token: " + cast int(result.token) + ", string: " + result.string );
            return result;
        si
    si

    class TOKENIZER_EXCEPTION isa Exception is
        void init( String s ) is
            super.init(s);
        si
    si

    class TOKEN_MAP is
        Generic.Map<String,TOKEN> map;

        void init() is
            super.init();
            map = new Generic.Map<String,TOKEN>(223);
        si

        set TOKEN[String s] = t is
            map[s] = t;
        si

        get TOKEN[String s] is
            var t = map[s];
            if t != cast TOKEN(0) then
                return t;
            else
                return TOKEN.IDENTIFIER;
            fi
        si
    si

    class TOKEN_PAIR is
        public String _string;
        public TOKEN _token;

        void init( TOKEN token, String string ) is
            super.init();
            _token = token;
            _string = string;
        si

        get String string is
            return _string;
        si

        get TOKEN token is
            return _token;
        si
    si

    class TOKENIZER is
        TOKEN token;
        static TOKEN_MAP symbol_tokens;
        TOKEN_BUFFER buffer;
        String _token_string;
        IO.Reader input;
        bool end_of_file;
        char _prev_char;

        String _current_file;
        int _current_line;

        String[] _token_name;

        static void init_symbol_tokens() is
            if symbol_tokens == null then
                symbol_tokens = new TOKEN_MAP();
                symbol_tokens["import"] = TOKEN.IMPORT;
                symbol_tokens["namespace"] = TOKEN.NAMESPACE;
                symbol_tokens["class"] = TOKEN.CLASS;
                symbol_tokens["struct"] = TOKEN.STRUCT;
                symbol_tokens["enum"] = TOKEN.ENUM;
                symbol_tokens["public"] = TOKEN.PUBLIC;
                symbol_tokens["protected"] = TOKEN.PROTECTED;
                symbol_tokens["private"] = TOKEN.PRIVATE;
                symbol_tokens["const"] = TOKEN.CONST;
                symbol_tokens["static"] = TOKEN.STATIC;
                symbol_tokens["if"] = TOKEN.IF;
                symbol_tokens["else"] = TOKEN.ELSE;
                symbol_tokens["while"] = TOKEN.WHILE;
                symbol_tokens["do"] = TOKEN.DO;
                symbol_tokens["for"] = TOKEN.FOR;
                symbol_tokens["foreach"] = TOKEN.FOREACH;
                symbol_tokens["case"] = TOKEN.CASE;
                symbol_tokens["default"] = TOKEN.DEFAULT;
                symbol_tokens["break"] = TOKEN.BREAK;
                symbol_tokens["continue"] = TOKEN.CONTINUE;
                symbol_tokens["ref"] = TOKEN.REFERENCE;
                symbol_tokens["ptr"] = TOKEN.POINTER;
                symbol_tokens["int"] = TOKEN.INT;
                symbol_tokens["long"] = TOKEN.LONG;
                symbol_tokens["word"] = TOKEN.WORD;
                symbol_tokens["char"] = TOKEN.CHAR;
                symbol_tokens["bool"] = TOKEN.BOOL;
                symbol_tokens["void"] = TOKEN.VOID;
                symbol_tokens["new"] = TOKEN.NEW;
                symbol_tokens["throw"] = TOKEN.THROW;
                symbol_tokens["return"] = TOKEN.RETURN;
                symbol_tokens["cast"] = TOKEN.CAST;
                symbol_tokens["var"] = TOKEN.VAR;
                symbol_tokens["try"] = TOKEN.TRY;
                symbol_tokens["let"] = TOKEN.LET;
                symbol_tokens["catch"] = TOKEN.CATCH;
                symbol_tokens["finally"] = TOKEN.FINALLY;
                symbol_tokens["this"] = TOKEN.THIS;
                symbol_tokens["super"] = TOKEN.SUPER;
                symbol_tokens["null"] = TOKEN.CONST_NULL;
                symbol_tokens["true"] = TOKEN.CONST_TRUE;
                symbol_tokens["false"] = TOKEN.CONST_FALSE;
                symbol_tokens["use"] = TOKEN.USE;
                symbol_tokens["native"] = TOKEN.NATIVE;
                symbol_tokens["pragma"] = TOKEN.PRAGMA;
                symbol_tokens["get"] = TOKEN.GET;
                symbol_tokens["set"] = TOKEN.SET;
                symbol_tokens["interface"] = TOKEN.INTERFACE;
                symbol_tokens["proc"] = TOKEN.PROC;
                symbol_tokens["isa"] = TOKEN.ISA;
                symbol_tokens["operator"] = TOKEN.OPERATOR;

                symbol_tokens["is"] = TOKEN.IS;
                symbol_tokens["si"] = TOKEN.SI;
                symbol_tokens["then"] = TOKEN.THEN;
                symbol_tokens["elif"] = TOKEN.ELIF;
                symbol_tokens["fi"] = TOKEN.FI;
                symbol_tokens["esac"] = TOKEN.ESAC;

                symbol_tokens["od"] = TOKEN.OD;
                symbol_tokens["yrt"] = TOKEN.YRT;
           fi
        si

        void init( String current_file, IO.Reader i ) is
            super.init();

            buffer = new TOKEN_BUFFER();

            end_of_file = false;
            input = i;
            _current_file = current_file;
            _current_line = 1;

            init_symbol_tokens();
        si

        void error( String msg ) is
            IO.Std.err.println( _current_file + ": " + _current_line + ": error: " + msg );
        si

        bool is_end_of_file() is
            return end_of_file;
        si

        char next_char() is
            char c;
            if _prev_char != cast char(0) then
                c = _prev_char;
                _prev_char = cast char(0);
                // IO.Std.err.print(""+c);
                // IO.Std.out.println( "next char: returning buffered: '" + c + "'" );
                return c;     
            fi

            int c0 = input.read();

            if c0 == -1 then
                // IO.Std.out.println( "next char: returning eof from: " + new System.Backtrace() );
                end_of_file = true;
                return ' ';
            fi

            c = cast char(c0);
            if c == '\n' then
                _current_line = _current_line + 1;
            fi

            return c;
        si

        void prev_char( char c ) is
            _prev_char = c;
        si

        get String current_string is
            return _token_string;
        si

        get String token_name[TOKEN t] is
            return _token_name[cast int(t)];
        si

        get int current_line is
            return _current_line;
        si

        get String current_file is
            return _current_file;
        si

        char read_escape() is
            char c = next_char();

            int result = 0;
            if c == 't' then
                // IO.Std.out.println( "escape tab" );
                return cast char(9);
            elif c == 'n' then
                // IO.Std.out.println( "escape newline" );
                return '\n';
            elif c == 'r' then
                return cast char(13);
            elif c == '\\' then
                // IO.Std.out.println( "escape backslash" );
                return '\\';
            elif c >= '0' && c <= '7' then
                // IO.Std.out.println( "escape octal" );
                while c >= '0' && c <= '7' do
                    result = 8 * result + cast int(c);
                    c = next_char();
                od
                prev_char(c);
                return cast char(result);
            else
                // IO.Std.out.println( "escape literal: '" + c + "'" );
                return c;
            fi
        si

        get TOKEN current_token is
            // IO.Std.err.println( "got: " + YyNameClass.yyName[cast int(token)] );
            return token;
        si

        bool next_token() is
            token = read_token();

            return token != TOKEN.END_OF_INPUT;
        si

        char skip_white_space() is
            char c;
            do
                c = next_char();
                // IO.Std.out.println( "white space: '" + c + "'?" );
                if ! (!end_of_file && (c == ' ' || c == cast char(9) || c == '\n')) then break; fi
            od
    
            return c;
        si

        TOKEN read_operator_method_token() is
            TOKEN r = read_token_2(false);
            case r 
            is TOKEN.ADD:
                _token_string = "operator+";

            is TOKEN.SUB:
                _token_string = "operator-";

            is TOKEN.MUL:
                _token_string = "operator*";

            is TOKEN.DIV:
                _token_string = "operator/";

            is TOKEN.MOD:
                _token_string = "operator%";

            is TOKEN.SHIFT_LEFT:
                _token_string = "operator<<";

            is TOKEN.SHIFT_RIGHT:
                _token_string = "operator>>";

            is TOKEN.AND:
                 _token_string = "operator&";

            is TOKEN.OR:
                _token_string = "operator|";

            is TOKEN.XOR:
                _token_string = "operator^";

            is TOKEN.OBJ_EQ:
                _token_string = "operator=~";

            is TOKEN.GT:
                _token_string = "operator>";

            is TOKEN.RANGE:
                _token_string = "operator..";

            default:
                // syntax error:
                return r;
            esac

            return TOKEN.IDENTIFIER;
        si

        TOKEN read_token() is
            TOKEN r;

            if buffer.avail then
                // IO.Std.err.println( "token in buffer..." );
                TOKEN_PAIR p = buffer.read();        
                _token_string = p.string;

                // IO.Std.err.println( "returning buffered: " + cast int(p.token) );
                return p.token;
            fi

            return read_token_2(false);
        si
    
        TOKEN read_token_2(bool for_comment) is
            TOKEN r;

            var c = skip_white_space();
            if end_of_file then
                return TOKEN.END_OF_INPUT;
            fi

            var open_line = _current_line;

            StringBuffer buffer = null;
            _token_string = null; // new StringBuffer("");

            // IO.Std.out.println( "number/letter: '" + c + "'?" );
            if c >= '0' && c <= '9' then
                // IO.Std.out.println( "number: '" + c + "'" );
                buffer = new StringBuffer();
                buffer.append( c );
                c = next_char();

                if c == 'x' || c == 'X' then
                    buffer.append( c );
                    c = next_char();
                    while (c >= '0' && c <= '9') || 
                        (c >= 'A' && c <= 'F') || 
                        (c >= 'a' && c <= 'f') ||
                         c == 'x' || c == 'w' || c == 'W' || c == 'l' || c == 'L'  do
                        buffer.append(c);
                        c = next_char();
                    od
                    // IO.Std.err.println( "read hex const: '" + buffer + "'" );
                else
                    while (c >= '0' && c <= '9') || c == 'x' || c == 'w' || c == 'W' || c == 'l' || c == 'L' || c == 'c' || c == 'C' do
                        buffer.append(c);
                        c = next_char();
                    od
                fi

                _token_string = buffer.Freeze;
                prev_char(c);
                // IO.Std.err.println( "read const int: '" + _token_string + "'" );
                return TOKEN.CONST_INT;
            elif (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' then
                // IO.Std.out.println( "letter: '" + c + "'" );
                buffer = new StringBuffer();
                while (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' do
                    buffer.append(c);
                    c = next_char();
                od
                _token_string = buffer.Freeze;
                prev_char(c);
                r = symbol_tokens[_token_string];

                if r == TOKEN.OPERATOR then
                    return read_operator_method_token();
                fi

                return r;
            fi

            case c
            is cast char(34): // double quote
                buffer = new StringBuffer();
                c = next_char(); 
                while c != cast char(34) do
                    if c == cast char(92) then // backslash
                        c = read_escape();
                        buffer.append(c);
                        c = next_char();
                    else
                        buffer.append(c);
                        c = next_char();
                    fi

                    if end_of_file then
                        error( "end of file in string literal at line " + open_line );
                        break;
                    fi
                od
                _token_string = buffer.Freeze;
                return TOKEN.CONST_STRING;

            is cast char(39): // single quote
                buffer = new StringBuffer();
                c = next_char();
                while c != cast char(39) do
                    if c == cast char(92) then // backslash
                        c = read_escape();
                        buffer.append(c);
                        c = next_char();
                    else
                        buffer.append(c);
                        c = next_char();
                    fi
                    if end_of_file then
                        error( "end of file in character literal at line " + open_line );
                        break;
                    fi
                od
                if buffer.Length < 1 then
                    error( "zero length character literal" );
                fi

                _token_string = buffer.Freeze;
                // IO.Std.err.println( "const char: '" + _token_string + "'" );
                return TOKEN.CONST_CHAR;

            is '`':
                buffer = new StringBuffer();
                c = next_char();
                while c != '`' do
                    if c == cast char(92) then // backslash
                        c = read_escape();
                        buffer.append(c);
                        c = next_char();
                    else
                        buffer.append(c);
                        c = next_char();
                    fi

                    if end_of_file then
                        error( "end of file in char ptr literal at line " + open_line );
                        break;
                    fi
                od
        
                _token_string = buffer.Freeze;
                return TOKEN.CONST_CSTRING;
                    
            is '=':
                c = next_char();
                if c == '=' then
                    return TOKEN.EQ;
                elif c == '~' then
                    return TOKEN.OBJ_EQ;
                else
                    prev_char(c);
                    return TOKEN.ASSIGN;
                fi

            is '>':
                c = next_char();
                if c == '=' then
                    return TOKEN.GE;
                elif c == '>' then
                    return TOKEN.SHIFT_RIGHT;
                else
                    prev_char(c);
                    return TOKEN.GT;
                fi

            is '<':
                c = next_char();
                if c == '=' then
                    return TOKEN.LE;
                elif c == '<' then
                    return TOKEN.SHIFT_LEFT;
                else
                    prev_char(c);
                    return TOKEN.LT;
                fi

            is '!':
                c = next_char();
                if c == '=' then
                    return TOKEN.NE;
                elif c == '~' then
                    return TOKEN.OBJ_NE;
                else
                    prev_char(c);
                    return TOKEN.BOOL_NOT;
                fi

            is '&':
                c = next_char();
                if c == '&' then
                    return TOKEN.BOOL_AND;
                else
                    prev_char(c);
                    return TOKEN.AND;
                fi
                
            is '|':
                c = next_char();
                if c == '|' then
                    return TOKEN.BOOL_OR;
                else
                    prev_char(c);
                    return TOKEN.OR;
                fi

            is '~': return TOKEN.NOT;
            is '^': return TOKEN.XOR;

            is '{':
                // generic_state = MAYBE_IN_TYPE;
                return TOKEN.START_BLOCK;

            is '}': return TOKEN.END_BLOCK;

            is '(': return TOKEN.OPEN_PAREN;

            is ')': return TOKEN.CLOSE_PAREN;

            is '[':
                c = skip_white_space();
                if end_of_file then
                    return TOKEN.OPEN_SQUARE;
                elif c == ']' then
                    return TOKEN.ARRAY_DEF;
                else
                    prev_char(c);
                    return TOKEN.OPEN_SQUARE;
                fi

            is ']': return TOKEN.CLOSE_SQUARE;

            is '+': return TOKEN.ADD;
            is '-': return TOKEN.SUB;
            is '*': return TOKEN.MUL;
            is '/':
                c = next_char();
                if c == '/' then
                    buffer = new StringBuffer("//");
                    do
                        c = next_char();
                        if c != '\n' then
                            buffer.append( c );
                        fi
                        if !( !end_of_file && c != '\n' ) then break; fi;
                    od

                    if buffer.startsWith("///") then
                        buffer.append( "\n" );
                        /*
                        if for_comment then
                            // IO.Std.err.println( "from: " + new System.Backtrace() );
                            // IO.Std.err.println( "appending comment: " + buffer );
                            ParseTree.appendLastComment(buffer);
                        else
                            ParseTree.LastComment = buffer;
                        fi
                        */
                        return read_token_2(true);
                    else
                        return read_token_2(false);
                    fi
                elif c == '*' then
                    buffer = new StringBuffer("/*");
                    do
                        c = next_char();

                        if c == '*' then
                            c = next_char();
                            if c == '/' then
                                break;
                            fi
                            buffer.append( '*' );
                        fi
                        buffer.append( c );
                        if end_of_file then break; fi
                    od

                    if buffer.startsWith( "/**" ) then
                        buffer.append( "*/" );
                        /*
                        if for_comment then
                            IO.Std.err.println( "from: " + new System.Backtrace() );
                            IO.Std.err.println( "appending comment: " + buffer );
                            ParseTree.appendLastComment(buffer);
                        else
                            ParseTree.LastComment = buffer;
                        fi
                        */
                        return read_token_2(true);            
                    else
                        return read_token_2(false);
                    fi
                else
                    prev_char(c);
                    return TOKEN.DIV;
                fi
            is '%': return TOKEN.MOD;       

            is '.': 
                c = next_char();
                if c == '.' then
                    return TOKEN.RANGE;
                else
                    prev_char(c);
                    return TOKEN.DOT;
                fi

            is ',': return TOKEN.COMMA;
            is ':': return TOKEN.COLON;
            is ';': return TOKEN.SEMICOLON;

            is '@':
                return TOKEN.PRAGMA;

            is '#':
                buffer = new StringBuffer();
                do
                    c = next_char();
                    if c < '0' || c > '9' then 
                        prev_char(c);
                        break;
                    fi
                    buffer.append(c);
                od

                _current_line = buffer.parseInt();

                return read_token_2(false);
            esac
            
            // IO.Std.out.println( "unknown: '" + c + "'" );
            return TOKEN.UNKNOWN;
        si        
    si
si
