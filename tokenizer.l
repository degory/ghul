// copyright 2004-2017 degs <junk@giantblob.com> all rights reserved

import stream;
import vector;
import map;

namespace Parse is
    use System.Object;
    use System.String;
    use System.StringBuffer;
    use System.Exception;

    class TokenBuffer is
	const int MAX = 32;  // maximum lookahead before we assume we're not in a generic type

	int read_pos;
	int write_pos;

	TokenPair[] values, temp;

	void init() is
	    values = new TokenPair[MAX*2];   // additional space to accomodate turning single '>>'
	    temp = new TokenPair[MAX*2];     // tokens into two token sequence close-generic close-generic
	    read_pos = 0;
	    write_pos = 0;
	si

	void reset() is
	    // IO.Std.err.println( "clear buffer..." );
	    read_pos = 0;
	    write_pos = 0;
	si

	get bool Avail is
	    return read_pos < write_pos;
	si

	get bool IsFull is
	    return write_pos >= MAX;
	si

	void write( TokenPair t ) is
	    // IO.Std.err.println( "buffer token: " + cast int(t.token) + ", string: " + t.string );
	    values[write_pos] = t;
	    write_pos = write_pos + 1;
	si

	TokenPair read() is
	    TokenPair result = values[read_pos];
	    read_pos = read_pos + 1;
	    // IO.Std.err.println( "read buffered token: " + cast int(result.token) + ", string: " + result.string );
	    return result;
	si

	void makeGeneric() is
	    assert( read_pos == 0 );

	    // convert '<', '>' and '>>' in the buffer to appropriate open + close generic tokens:
	    int vp = 0, tp = 0;

	    while vp < write_pos do
		Token r = values[vp].token;
		if r == Token.LT then
		    r = Token.OPEN_GENERIC;
		elif r == Token.GT then
		    r = Token.CLOSE_GENERIC;
		elif r == Token.SHIFT_RIGHT then
		    // treat a previously lexed SHIFT_RIGHT ('>>') token as two CLOSE_GENERIC tokens:
		    temp[tp] = new TokenPair( Token.CLOSE_GENERIC, null );
		    tp = tp + 1;
		    r = Token.CLOSE_GENERIC;
		fi
		// copy the previously lexed token+string over:
		temp[tp] = values[vp];
		// but override the token to substitute generic brackets where needed:
		temp[tp].token = r;

		vp = vp + 1;
		tp = tp + 1;
	    od

	    TokenPair[] t = values;
	    values = temp;
	    temp = t;
	    write_pos = tp;
	si
    si

    class TokenizerException isa Exception is
        void init( String s ) is
            super.init(s);
        si
    si

    class TokenHolder is
        public Token token;

        void init( Token token ) is
            super.init();
            this.token = token;
        si
    si

    class TokenMap is
        Generic.Map<String,TokenHolder> map;

        void init() is
            super.init();
            map = new Generic.Map<String,TokenHolder>(223);
        si

        set Token[String s] = t is
            map[s] = new TokenHolder(t);
        si

        get Token[String s] is
            TokenHolder th = map[s];
            if th != null then
                return th.token;
            else
                return Parse.Token.IDENTIFIER;
            fi
        si
    si

    class TokenPair is
        public String string;
        public Token token;

        void init( Token token, String string ) is
            super.init();
            this.token = token;
            this.string = string;
        si

        String getString() is
            return string;
        si

        Token getToken() is
            return token;
        si
    si

    class Tokenizer is
        Token token;
        static TokenMap symbol_tokens_l;
	static TokenMap symbol_tokens_k;
	TokenMap symbol_tokens;
	TokenBuffer buffer;
        String token_string;
        IO.Reader input;
        bool end_of_file;
        char prev_char;

	String current_file;
	int current_line;

        String[] token_name;

	bool want_new_syntax;

	static TokenMap initSymbolTokensCommon() is
	    // IO.Std.err.println( "init tokens for common" );
	    var symbol_tokens = new TokenMap();
	    symbol_tokens["import"] = Token.IMPORT;
	    symbol_tokens["namespace"] = Token.NAMESPACE;
	    symbol_tokens["class"] = Token.CLASS;
	    symbol_tokens["struct"] = Token.STRUCT;
	    symbol_tokens["enum"] = Token.ENUM;
	    symbol_tokens["public"] = Token.PUBLIC;
	    symbol_tokens["protected"] = Token.PROTECTED;
	    symbol_tokens["private"] = Token.PRIVATE;
	    symbol_tokens["const"] = Token.CONST;
	    symbol_tokens["static"] = Token.STATIC;
	    symbol_tokens["if"] = Token.IF;
	    symbol_tokens["else"] = Token.ELSE;
	    symbol_tokens["while"] = Token.WHILE;
	    symbol_tokens["do"] = Token.DO;
	    symbol_tokens["for"] = Token.FOR;
	    symbol_tokens["foreach"] = Token.FOREACH;
	    symbol_tokens["case"] = Token.CASE;
	    symbol_tokens["default"] = Token.DEFAULT;
	    symbol_tokens["break"] = Token.BREAK;
	    symbol_tokens["continue"] = Token.CONTINUE;
	    symbol_tokens["ref"] = Token.REFERENCE;
	    symbol_tokens["ptr"] = Token.POINTER;
	    symbol_tokens["int"] = Token.INT;
	    symbol_tokens["long"] = Token.LONG;
	    symbol_tokens["word"] = Token.WORD;
	    symbol_tokens["char"] = Token.CHAR;
	    symbol_tokens["bool"] = Token.BOOL;
	    symbol_tokens["void"] = Token.VOID;
	    symbol_tokens["new"] = Token.NEW;
	    symbol_tokens["throw"] = Token.THROW;
	    symbol_tokens["return"] = Token.RETURN;
	    symbol_tokens["cast"] = Token.CAST;
	    symbol_tokens["var"] = Token.VARIABLE;
	    symbol_tokens["try"] = Token.TRY;
	    symbol_tokens["catch"] = Token.CATCH;
	    symbol_tokens["finally"] = Token.FINALLY;
	    symbol_tokens["this"] = Token.THIS;
	    symbol_tokens["super"] = Token.SUPER;
	    symbol_tokens["null"] = Token.CONST_NULL;
	    symbol_tokens["true"] = Token.CONST_TRUE;
	    symbol_tokens["false"] = Token.CONST_FALSE;
	    symbol_tokens["use"] = Token.USE;
	    symbol_tokens["native"] = Token.NATIVE;
	    symbol_tokens["pragma"] = Token.PRAGMA;
	    symbol_tokens["get"] = Token.GET;
	    symbol_tokens["set"] = Token.SET;
	    symbol_tokens["interface"] = Token.INTERFACE;
	    symbol_tokens["proc"] = Token.PROC;
	    symbol_tokens["isa"] = Token.ISA;
	    symbol_tokens["operator"] = Token.OPERATOR;

	    return symbol_tokens;
	si

	void initSymbolTokens() is
	    if want_new_syntax then
	    	if symbol_tokens_k == null then 
		    symbol_tokens_k = initSymbolTokensCommon();

		    // IO.Std.err.println( "init tokens for K syntax" );
		    symbol_tokens_k["is"] = Token.IS;
		    // symbol_tokens_k["end"] = Token.END;
		    symbol_tokens_k["si"] = Token.END;
		    symbol_tokens_k["then"] = Token.THEN;
		    symbol_tokens_k["elif"] = Token.ELIF;
		    symbol_tokens_k["fi"] = Token.FI;
		    symbol_tokens_k["esac"] = Token.ESAC;
		    
		    symbol_tokens_k["od"] = Token.OD;
		    symbol_tokens_k["yrt"] = Token.YRT;
		fi

		this.symbol_tokens = symbol_tokens_k;		
	    else
		if symbol_tokens_l == null then
		    symbol_tokens_l = initSymbolTokensCommon();

		    // IO.Std.err.println( "init tokens for L syntax" );
		    symbol_tokens_l["extends"] = Token.EXTENDS;
		    symbol_tokens_l["implements"] = Token.IMPLEMENTS;		    
		    symbol_tokens_l["switch"] = Token.SWITCH;		    
		fi
	    	this.symbol_tokens = symbol_tokens_l;
	    fi

	    // IO.Std.err.println( "tokens initialized" );

	si

        void init( String current_file, IO.Reader i ) is
            super.init();
	    want_new_syntax = true;
	    int t = i.read();
	    if t == cast int('#') then
		// IO.Std.err.println( "reading syntax marker..." );
		int u = i.read();
		if u == cast int('C') || u == cast int('L') then
		    want_new_syntax = false;
		elif u == cast int('K') then
		    // IO.Std.err.println( "new syntax selected" );
		    want_new_syntax = true;
		else
		    throw new Exception( "unexpected syntax type marker '#" + cast char(u) + "'" );
		fi
	    elif t != -1 then
		i.unRead( t );
	    fi
		
	    buffer = new TokenBuffer();

	    // stack.add( MAYBE_IN_TYPE );

            end_of_file = false;
            input = i;
	    this.current_file = current_file;
	    current_line = 1;

	    initSymbolTokens();
	si

	void error( String msg ) is
            IO.Std.err.println( current_file + ": " + current_line + ": error: " + msg );
	si

	get bool WantNewSyntax is
	    return want_new_syntax;
	si

        bool isEndOfFile() is
            return end_of_file;
        si

        void markInArgumentsDeclaration() is
	    // generic_state = IN_ARGUMENTS;
	si

        char nextChar() is
            char c;
            if prev_char != cast char(0) then
                c = prev_char;
                prev_char = cast char(0);
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
		current_line = current_line + 1;
	    fi
	    // IO.Std.err.print(""+c);
            // IO.Std.out.println( "next char: returning '" + c + "'" );
            return c;
        si

        void prevChar( char c ) is
            prev_char = c;
        si

        String getBuffer() is
            return token_string;
        si

	Object getValue() is
	    return getBuffer();
	si

        String getName(Token t) is
            return token_name[cast int(t)];
        si

	int getLine() is
	    return current_line;
	si

	String getFile() is
	    return current_file;
	si

        char readEscape() is
            char c = nextChar();

            // IO.Std.out.println( "readEscape: '" + c + "'..." );
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
                    c = nextChar();
                od
                prevChar(c);
                return cast char(result);
            else
                // IO.Std.out.println( "escape literal: '" + c + "'" );
                return c;
            fi
        si

	int getCurrentToken() is
	    // IO.Std.err.println( "got: " + YyNameClass.yyName[cast int(token)] );
	    return cast int(token);
	si

        bool nextToken() is
	    token = readToken();
	    // IO.Std.err.println( "read: " + YyNameClass.yyName[cast int(token)] + ", '" + token_string + "'" );
            return token != Token.EOF;
        si

	char skipWhiteSpace() is
	    char c;
	    do
                c = nextChar();
                // IO.Std.out.println( "white space: '" + c + "'?" );
                if ! (!end_of_file && (c == ' ' || c == cast char(9) || c == '\n')) then break; fi
            od
	
	    return c;
	si

	Token readOperatorMethodToken() is
	    Token r = readToken2(false);
	    case r 
	    is Token.ADD:
		token_string = "opAdd";

	    is Token.SUB:
		token_string = "opSub";

	    is Token.MUL:
		token_string = "opMul";

	    is Token.DIV:
		token_string = "opDiv";

	    is Token.MOD:
		token_string = "opMod";

	    is Token.SHIFT_LEFT:
		token_string = "opShl";

	    is Token.SHIFT_RIGHT:
		token_string = "opShar";

	    is Token.AND:
		token_string = "opAnd";

	    is Token.OR:
		token_string = "opOr";

	    is Token.XOR:
		token_string = "opXor";

	    is Token.OBJ_EQ:
		token_string = "opEquals";

	    is Token.GT:
		token_string = "opCompare";

	    is Token.RANGE:
		token_string = "opRange";

	    default:
		// syntax error:
		return r;
	    esac

	    return Token.IDENTIFIER;
	si

	Token readToken() is
	    Token r;

	    if buffer.Avail then
		// IO.Std.err.println( "token in buffer..." );
		TokenPair p = buffer.read();		
		token_string = p.string;

		// IO.Std.err.println( "returning buffered: " + cast int(p.token) );
		return p.token;
	    fi

	    r = readToken2(false);

	    if r != Token.LT /* && r != Token.WHILE */ then
		return r;
	    fi

	    // nothing in buffer and current token is '<' - may be looking at a generic type, need to look ahead until we can determine if we're
	    // in a generic type or not. 

	    buffer.reset();

	    buffer.write( new TokenPair( r, token_string ) );
	    var bracket_stack = new Token[16];
	    bracket_stack[0] = r;
	    int generic_level = 0;
	    // int do_level = 1;
	    bool is_generic = true;

	    do
		if buffer.IsFull then
		    IO.Std.err.println( "" + current_file + ": " + current_line + ": warn: ambiguous input: assuming not a generic type" );

		    // will return first buffered token (which will be Token.LT):
		    return readToken();
		fi

		r = readToken2(false);

		// IO.Std.err.println( "token is: " + cast int(r) + ", string: " + token_string );

		buffer.write( new TokenPair(r, token_string) );

		if r == Token.LT then
		    generic_level = generic_level + 1;
		    bracket_stack[generic_level] = r;
		    // IO.Std.err.println( "OK: open angle bracket..." );
		elif r == Token.GT then
		    // IO.Std.err.println( "OK: close angle bracket..." );
		    if bracket_stack[generic_level] != Token.LT then
			is_generic = false;
			break;
		    fi
		    generic_level = generic_level - 1;
		elif r == Token.SHIFT_RIGHT then
		    // IO.Std.err.println( "OK: shift right..." );
		    if generic_level < 1 || bracket_stack[generic_level] != Token.LT || bracket_stack[generic_level-1] != Token.LT then
			is_generic = false;
			break;
		    fi
		    generic_level = generic_level - 2;
		elif r == Token.CLOSE_PAREN then
		    if bracket_stack[generic_level] != Token.OPEN_PAREN then
			is_generic = false;
			break;
		    fi
		    generic_level = generic_level - 1;
		elif r == Token.PROC then
		    r = readToken2(false);
		    buffer.write( new TokenPair(r, token_string) );

		    if r != Token.OPEN_PAREN then
			is_generic = false;
			break;
		    else
			generic_level = generic_level + 1;
			bracket_stack[generic_level] = r;
		    fi
		elif r == Token.DOT || r == Token.COMMA || r == Token.IDENTIFIER ||
			   (r >= Token.ARRAY_DEF && r <= Token.REFERENCE ) || r == Token.VOID then
		    // IO.Std.err.println( "OK: basic type, identifier or dot..." );
		else
		    // IO.Std.err.println( "" + current_file + ": " + current_line + ": doesn't look like a generic - leaving buffered input alone" );
		    is_generic = false;
		    break;
		fi
                if !( generic_level >= 0 ) then break; fi
            od

	    /*
	    if( generic_level < 0 ) {
		// IO.Std.err.println( "" + current_file + ": " + current_line + ": doesn't look like a generic - leaving buffered input alone" );
		is_generic = false;
	    }
	    */

	    if is_generic then
		// IO.Std.err.println( "was generic - convert buffer..." );		
		buffer.makeGeneric();
	    fi
	    // IO.Std.err.println( "read token: " + cast int(r) + " generic state now: " + generic_state + " generic level now: " + generic_level );

	    return readToken();
	si
	
        Token readToken2(bool for_comment) is
	    Token r;

            char c = skipWhiteSpace();
            if end_of_file then
                return Token.EOF;
            fi

	    int open_line = current_line;

            StringBuffer buffer = null;
            token_string = null; // new StringBuffer("");

            // IO.Std.out.println( "number/letter: '" + c + "'?" );
            if c >= '0' && c <= '9' then
                // IO.Std.out.println( "number: '" + c + "'" );
                buffer = new StringBuffer();
		buffer.append( c );
		c = nextChar();
		if c == 'x' || c == 'X' then
		    buffer.append( c );
		    c = nextChar();
		    while (c >= '0' && c <= '9') || 
			  (c >= 'A' && c <= 'F') || 
			  (c >= 'a' && c <= 'f') ||
			  c == 'x' || c == 'w' || c == 'W' || c == 'l' || c == 'L'  do
			buffer.append(c);
			c = nextChar();
		    od
		    // IO.Std.err.println( "read hex const: '" + buffer + "'" );
		else
		    while (c >= '0' && c <= '9') || c == 'x' || c == 'w' || c == 'W' || c == 'l' || c == 'L' || c == 'c' || c == 'C' do
			buffer.append(c);
			c = nextChar();
		    od
		fi

                token_string = buffer.Freeze;
                prevChar(c);
		// IO.Std.err.println( "read const int: '" + token_string + "'" );
                return Token.CONST_INT;
            elif (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' then
                // IO.Std.out.println( "letter: '" + c + "'" );
                buffer = new StringBuffer();
                while (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' do
                    buffer.append(c);
                    c = nextChar();
                od
                token_string = buffer.Freeze;
                prevChar(c);
		r = symbol_tokens[token_string];

		if r == Token.OPERATOR then
		    return readOperatorMethodToken();
		fi

		/*
		if( r == Token.OF ) {
		    // IO.Std.err.println( "seen of - in type..." );
		    in_type = true;
		    return readToken2();
		}
		*/
                return r;
            fi


            case c
            is cast char(34): // double quote
                buffer = new StringBuffer();
                c = nextChar(); 
                while c != cast char(34) do
                    if c == cast char(92) then // backslash
                        c = readEscape();
                        buffer.append(c);
                        c = nextChar();
                    else
                        buffer.append(c);
                        c = nextChar();
                    fi
		    if end_of_file then
			error( "end of file in string literal at line " + open_line );
			break;
		    fi
                od
                token_string = buffer.Freeze;
                return Token.CONST_STRING;

            is cast char(39): // single quote
                buffer = new StringBuffer();
                c = nextChar();
                while c != cast char(39) do
                    if c == cast char(92) then // backslash
                        c = readEscape();
                        buffer.append(c);
                        c = nextChar();
                    else
                        buffer.append(c);
                        c = nextChar();
                    fi
		    if end_of_file then
			error( "end of file in character literal at line " + open_line );
			break;
		    fi
                od
		if buffer.Length < 1 then
		    error( "zero length character literal" );
		fi
                token_string = buffer.Freeze;
		// IO.Std.err.println( "const char: '" + token_string + "'" );
                return Token.CONST_CHAR;

	    is '`':
		buffer = new StringBuffer();
		c = nextChar();
		while c != '`' do
		    if c == cast char(92) then // backslash
			c = readEscape();
			buffer.append(c);
			c = nextChar();
		    else
			buffer.append(c);
			c = nextChar();
		    fi

		    if end_of_file then
			error( "end of file in char ptr literal at line " + open_line );
			break;
		    fi
		od
		token_string = buffer.Freeze;
		return Token.CONST_CSTRING;
                    
            is '=':
		/*
		if( generic_level == 0 ) {
		    generic_state = IN_OTHER;
		    // IO.Std.err.println( "seen assign token: cannot be in a type now" );
		}
		*/

                c = nextChar();
                if c == '=' then
                    return Token.EQ;
                elif c == '~' then
		    return Token.OBJ_EQ;
		else
                    prevChar(c);
                    return Token.ASSIGN;
                fi

            is '>':
		/*
		if( generic_level > 0 ) {
		    generic_level = generic_level - 1;
		    if( generic_level == 0 ) {
			in_type = false;
		    }

		    // IO.Std.err.println( "in type > is close-generic, genric level now: " + generic_level );
		    return Token.CLOSE_GENERIC;
		}
		*/

		// IO.Std.err.println( "> is not part of type" );

                c = nextChar();
                if c == '=' then
                    return Token.GE;
                elif c == '>' then
                    return Token.SHIFT_RIGHT;
                else
                    prevChar(c);
                    return Token.GT;
                fi

            is '<':
		/*
		if( generic_state == IN_ARGUMENTS || generic_state == IN_CAST || generic_state == MAYBE_IN_TYPE ) {
		    generic_level = generic_level + 1;
		    return Token.OPEN_GENERIC;
		}
		*/

		// IO.Std.err.println( "< is not part of type" );

		/*
		if( in_type ) {
		    generic_level = generic_level + 1;
		    // IO.Std.err.println( "in type < is open-generic, genric level now: " + generic_level );
		    return Token.OPEN_GENERIC;
		}
		*/

                c = nextChar();
                if c == '=' then
                    return Token.LE;
                elif c == '<' then
                    return Token.SHIFT_LEFT;
                else
                    prevChar(c);
                    return Token.LT;
                fi

            is '!':
                c = nextChar();
                if c == '=' then
                    return Token.NE;
		elif c == '~' then
		    return Token.OBJ_NE;
                else
                    prevChar(c);
                    return Token.BOOL_NOT;
                fi

            is '&':
                c = nextChar();
                if c == '&' then
                    return Token.BOOL_AND;
                else
                    prevChar(c);
                    return Token.AND;
                fi
                
            is '|':
                c = nextChar();
                if c == '|' then
                    return Token.BOOL_OR;
                else
                    prevChar(c);
                    return Token.OR;
                fi

            is '~': return Token.NOT;
	    is '^': return Token.XOR;

            is '{':
		// generic_state = MAYBE_IN_TYPE;
		return Token.START_BLOCK;

            is '}': return Token.END_BLOCK;

            is '(':
		/*
		if( generic_state == IN_ARGUMENTS ) {
		    generic_state = MAYBE_IN_TYPE;
		} else if( generic_level == 0 ) {
		    if( generic_state != IN_FOR ) {
			// IO.Std.err.println( "seen left paren: cannot be in type" );
			generic_state = IN_OTHER;
		    }
		    paren_level = paren_level + 1;
		}
		*/
		return Token.OPEN_PAREN;

            is ')':
		/*
		paren_level = paren_level - 1;
		if( generic_state == IN_ARGUMENTS && paren_level == 0 ) {
		    generic_state = IN_OTHER;
		}
		*/
		return Token.CLOSE_PAREN;

            is '[':
		c = skipWhiteSpace();
		if end_of_file then
		    return Token.OPEN_SQUARE;
		elif c == ']' then
		    return Token.ARRAY_DEF;
		else
		    prevChar(c);
		    return Token.OPEN_SQUARE;
		fi

            is ']': return Token.CLOSE_SQUARE;

            is '+': return Token.ADD;
            is '-': return Token.SUB;
            is '*': return Token.MUL;
            is '/':
                c = nextChar();
                if c == '/' then
		    buffer = new StringBuffer("//");
                    do
                        c = nextChar();
			if c != '\n' then
			    buffer.append( c );
			fi
			if !( !end_of_file && c != '\n' ) then break; fi;
                    od

		    if buffer.startsWith("///") then
			buffer.append( "\n" );
			if for_comment then
			    // IO.Std.err.println( "from: " + new System.Backtrace() );
			    // IO.Std.err.println( "appending comment: " + buffer );
			    ParseTree.appendLastComment(buffer);
			else
			    ParseTree.LastComment = buffer;
			fi
			return readToken2(true);
		    else
			return readToken2(false);
		    fi
                elif c == '*' then
                    buffer = new StringBuffer("/*");
		    do
			c = nextChar();

			if c == '*' then
			    c = nextChar();
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
			if for_comment then
			    IO.Std.err.println( "from: " + new System.Backtrace() );
			    IO.Std.err.println( "appending comment: " + buffer );
			    ParseTree.appendLastComment(buffer);
			else
			    ParseTree.LastComment = buffer;
			fi
			return readToken2(true);		    
		    else
			return readToken2(false);
		    fi
		else
                    prevChar(c);
                    return Token.DIV;
                fi
	    is '%': return Token.MOD;	    

            is '.': 
		c = nextChar();
		if c == '.' then
		    return Token.RANGE;
		else
		    prevChar(c);
		    return Token.DOT;
		fi

            is ',': return Token.COMMA;
            is ':': return Token.COLON;
            is ';': 
		/*
		if( generic_state == IN_FOR ) {
		    generic_state = IN_OTHER;
		} else if( paren_level == 0 ) {
		    generic_state = MAYBE_IN_TYPE;
		}
		*/
		return Token.END_STATEMENT;

	    is '@':
		return Token.PRAGMA;

	    is '#':
		buffer = new StringBuffer();
		do
		    c = nextChar();
		    if c < '0' || c > '9' then 
			prevChar(c);
			break;
		    fi
		    buffer.append(c);
		od

		current_line = buffer.parseInt();

		return readToken2(false);
            esac
            
            // IO.Std.out.println( "unknown: '" + c + "'" );
            return Token.UNKNOWN;
	si        
    si
si
