// copyright 2004-2017 degs <junk@giantblob.com> all rights reserved

import stream;

namespace Lexical is
    use System.Object;
    use System.String;
    use System.StringBuffer;
    use System.Exception;

    use Source;

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
            values[write_pos] = t;
            write_pos = write_pos + 1;
        si

        TOKEN_PAIR read() is
            TOKEN_PAIR result = values[read_pos];
            read_pos = read_pos + 1;
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
        TOKEN _token;
        LOCATION _location;
        String _string;

        void init( TOKEN token, LOCATION location, String string ) is
            super.init();
            _token = token;
            _location = location;
            _string = string;
        si

        get TOKEN token is
            return _token;
        si        

        get LOCATION location is
            return _location;
        si

        get String string is
            return _string;
        si

        public String toString() is
            return "" + _location + ": " + TOKEN_NAMES[_token] + ": " + _string;
        si
    si

    class TOKENIZER is
        Logging.LOGGER logger;

        TOKEN_PAIR _token_pair;
        static TOKEN_MAP symbol_tokens;
        TOKEN_BUFFER buffer;

        IO.Reader input;
        bool end_of_file;
        char _prev_char;

        LOCATION_CURSOR cursor;

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
                symbol_tokens["ref"] = TOKEN.REF;
                symbol_tokens["ptr"] = TOKEN.PTR;
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
                symbol_tokens["null"] = TOKEN.NULL;
                symbol_tokens["true"] = TOKEN.TRUE;
                symbol_tokens["false"] = TOKEN.FALSE;
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

        void init( String file_name, IO.Reader i ) is
            super.init();

            buffer = new TOKEN_BUFFER();

            end_of_file = false;
            input = i;

            init_symbol_tokens();

            cursor = new LOCATION_CURSOR(file_name);

            _token_pair = new TOKEN_PAIR(TOKEN.UNKNOWN, location, null);
        si

        get bool is_end_of_file is
            return end_of_file;
        si

        get LOCATION location is
            var result = cursor.location;

            return result;
        si

        void advance_cursor(char c) is
            cursor.next_column();

            if c == '\n' then
                cursor.next_line();
            fi
        si

        char next_char() is
            char c;
            if _prev_char != cast char(0) then
                c = _prev_char;                

                advance_cursor(c);

                _prev_char = cast char(0);

                // IO.Std.err.print(""+c);
                return c;     
            fi
            
            int c0 = input.read();

            if c0 == -1 then
                end_of_file = true;
                return ' ';
            fi

            c = cast char(c0);

            cursor.save();

            advance_cursor(c);

            return c;
        si

        void prev_char( char c ) is
            cursor.restore();

            _prev_char = c;
        si

        get String current_string is
            return _token_pair.string;
        si

        get String token_name[TOKEN t] is
            return _token_name[cast int(t)];
        si

        char read_escape() is
            char c = next_char();

            int result = 0;
            if c == 't' then
                return cast char(9);
            elif c == 'n' then
                return '\n';
            elif c == 'r' then
                return cast char(13);
            elif c == '\\' then
                return '\\';
            elif c >= '0' && c <= '7' then
                while c >= '0' && c <= '7' do
                    result = 8 * result + cast int(c);
                    c = next_char();
                od
                prev_char(c);
                return cast char(result);
            else
                return c;
            fi
        si

        get TOKEN_PAIR current is
            return _token_pair;
        si

        bool next() is
            _token_pair = read_token();

            return current.token != TOKEN.END_OF_INPUT;
        si

        char skip_white_space() is
            char c;
            do
                c = next_char();
                
                if ! (!end_of_file && (c == ' ' || c == cast char(9) || c == '\n')) then break; fi
            od
    
            return c;
        si

        TOKEN_PAIR read_operator_method_token() is
            var start = location;
            var o = read_token_2(false);
            var string = "";

            case o.token 
            is TOKEN.PLUS:
                string = "operator-";

            is TOKEN.STAR:
                string = "operator*";

            is TOKEN.SLASH:
                string = "operator/";

            is TOKEN.PERCENT:
                string = "operator%";

            is TOKEN.SHIFT_LEFT:
                string = "operator<<";

            is TOKEN.SHIFT_RIGHT:
                string = "operator>>";

            is TOKEN.AND:
                string = "operator&";

            is TOKEN.OR:
                string = "operator|";

            is TOKEN.XOR:
                string = "operator^";

            is TOKEN.EQ_OBJ:
                string = "operator=~";

            is TOKEN.GT:
                string = "operator>";

            is TOKEN.RANGE:
                string = "operator..";

            default:
                // syntax error:
                return o;
            esac

            return new TOKEN_PAIR(
                TOKEN.IDENTIFIER,
                start..location,
                string
            );
        si

        TOKEN_PAIR read_token() is
            if buffer.avail then
                return buffer.read();        
            fi

            return read_token_2(false);
        si
    
        TOKEN_PAIR read_token_2(bool for_comment) is
            TOKEN r;            

            var c = skip_white_space();
            if end_of_file then
                return new TOKEN_PAIR(TOKEN.END_OF_INPUT,location,null);
            fi

            cursor.start();

            StringBuffer buffer = null;

            if c >= '0' && c <= '9' then
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
                else
                    while (c >= '0' && c <= '9') || c == 'x' || c == 'w' || c == 'W' || c == 'l' || c == 'L' || c == 'c' || c == 'C' do
                        buffer.append(c);
                        c = next_char();
                    od
                fi

                prev_char(c);

                return new TOKEN_PAIR(
                    TOKEN.INT_LITERAL,
                    location,
                    buffer
                );

            elif (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' then
                buffer = new StringBuffer();
                while (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' do
                    buffer.append(c);
                    c = next_char();
                od

                prev_char(c);
                r = symbol_tokens[buffer];

                if r == TOKEN.OPERATOR then
                    return read_operator_method_token();
                fi

                return new TOKEN_PAIR(
                    r,
                    location,
                    buffer
                );
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
                        logger.error(location, "end of file in string literal");
                        break;
                    fi
                od

                return
                    new TOKEN_PAIR(
                        TOKEN.STRING_LITERAL,
                        location,
                        buffer
                    );

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
                        logger.error(location, "end of file in character literal");
                        break;
                    fi
                od

                if buffer.Length < 1 then
                    logger.error(location, "zero length character literal" );
                elif buffer.Length > 1 then
                    logger.error(location, "character literal is too long");
                fi

                return 
                    new TOKEN_PAIR(
                        TOKEN.CHAR_LITERAL,
                        location,
                        buffer
                    );

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
                        logger.error(location, "end of file in char ptr literal");
                        break;
                    fi
                od
        
                return
                    new TOKEN_PAIR( 
                        TOKEN.CSTRING_LITERAL,
                        location,
                        buffer
                    );
                    
            is '=':
                c = next_char();
                if c == '=' then
                    return new TOKEN_PAIR(TOKEN.EQ, location, null);
                elif c == '~' then
                    return new TOKEN_PAIR(TOKEN.EQ_OBJ, location, null);
                elif c == '>' then
                    return new TOKEN_PAIR(TOKEN.ARROW_FAT, location, null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.ASSIGN, location, null);
                fi

            is '>':
                c = next_char();
                if c == '=' then
                    return new TOKEN_PAIR(TOKEN.GE,location,null);
                elif c == '>' then
                    return new TOKEN_PAIR(TOKEN.SHIFT_RIGHT, location, null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.GT, location, null);
                fi

            is '<':
                c = next_char();
                if c == '=' then
                    return new TOKEN_PAIR(TOKEN.LE, location, null);
                elif c == '<' then
                    return new TOKEN_PAIR(TOKEN.SHIFT_LEFT, location, null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.LT, location, null);
                fi

            is '!':
                c = next_char();
                if c == '=' then
                    return new TOKEN_PAIR(TOKEN.NE, location, null);
                elif c == '~' then
                    return new TOKEN_PAIR(TOKEN.NE_OBJ, location, null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.NOT, location, null);
                fi

            is '&':
                c = next_char();
                if c == '&' then
                    return new TOKEN_PAIR(TOKEN.AND_THEN, location,null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.AND, location, null);
                fi
                
            is '|':
                c = next_char();
                if c == '|' then
                    return new TOKEN_PAIR(TOKEN.OR_ELSE, location, null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.OR, location, null);
                fi

            is '~': return new TOKEN_PAIR(TOKEN.NOT, location, null);
            is '^': return new TOKEN_PAIR(TOKEN.XOR, location, null);
/*
            is '{': return new TOKEN_PAIR(TOKEN.BRACE_OPEN, location, null);

            is '}': return new TOKEN_PAIR(TOKEN.BRACE_CLOSE, location, null);
*/
            is '(': return new TOKEN_PAIR(TOKEN.PAREN_OPEN, location, null);

            is ')': return new TOKEN_PAIR(TOKEN.PAREN_CLOSE, location, null);

            is '[':
                c = skip_white_space();
                if end_of_file then
                    return new TOKEN_PAIR(TOKEN.SQUARE_OPEN, location, null);   
                elif c == ']' then
                    return new TOKEN_PAIR(TOKEN.ARRAY_DEF, location, null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.SQUARE_OPEN, location, null);
                fi

            is ']': return new TOKEN_PAIR(TOKEN.SQUARE_CLOSE, location, null);

            is '+': return new TOKEN_PAIR(TOKEN.PLUS, location, null);
            is '-':
                c = next_char();
                if c == '>' then
                    return new TOKEN_PAIR(TOKEN.ARROW_THIN, location, null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.MINUS, location, null);
                fi

            is '*': return new TOKEN_PAIR(TOKEN.STAR, location, null);
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
                    return new TOKEN_PAIR(TOKEN.SLASH, location, null);
                fi
            is '%': return new TOKEN_PAIR(TOKEN.PERCENT, location, null);

            is '.': 
                c = next_char();
                if c == '.' then
                    return new TOKEN_PAIR(TOKEN.RANGE, location, null);
                else
                    prev_char(c);
                    return new TOKEN_PAIR(TOKEN.DOT, location, null);
                fi

            is ',': return new TOKEN_PAIR(TOKEN.COMMA, location, null);
            is ':': return new TOKEN_PAIR(TOKEN.COLON, location, null);
            is ';': return new TOKEN_PAIR(TOKEN.SEMICOLON, location, null);

            is '@':
                return new TOKEN_PAIR(TOKEN.PRAGMA, location, null);

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

                cursor.jump(buffer.parseInt(), 1);

                return read_token_2(false);
            esac
            
            return new TOKEN_PAIR(TOKEN.UNKNOWN, location, "" + c);
        si        
    si
si
