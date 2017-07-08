
namespace Lexical is
    use System;
    use Generic;

    class TOKEN_NAMES is
        Dict<TOKEN, String> names;

        private static TOKEN_NAMES _instance;  

        void init() is
            names = new Map<TOKEN, String>();

            names[TOKEN.PLUS] = "+";
            names[TOKEN.AND] = "&";
            names[TOKEN.AND_THEN] = "&&";
            names[TOKEN.ARRAY_DEF] = "[]";
            names[TOKEN.ARROW_FAT] = "=>";
            names[TOKEN.ARROW_THIN] = "->";
            names[TOKEN.ASSERT] = "";
            names[TOKEN.ASSIGN] = "=";
            names[TOKEN.AT] = "@";
            names[TOKEN.BITAND] = "";
            names[TOKEN.BOOL] = "bool";
            names[TOKEN.BREAK] = "break";
            names[TOKEN.BYTE] = "byte";
            names[TOKEN.CASE] = "case";
            names[TOKEN.CAST] = "cast";
            names[TOKEN.CATCH] = "catch";
            names[TOKEN.CHAR] = "char";
            names[TOKEN.CHAR_LITERAL] = "char literal";
            names[TOKEN.CLASS] = "class";
            names[TOKEN.COLON] = ":";
            names[TOKEN.COMMA] = ",";
            names[TOKEN.CONST] = "const";
            names[TOKEN.CONTINUE] = "continue";
            names[TOKEN.CSTRING_LITERAL] = "C string literal";
            names[TOKEN.DEFAULT] = "default";
            names[TOKEN.SLASH] = "/";
            names[TOKEN.DO] = "do";
            names[TOKEN.DOT] = ".";
            names[TOKEN.DOUBLE_LITERAL] = "double literal";
            names[TOKEN.ELIF] = "elif";
            names[TOKEN.ELSE] = "else";
            names[TOKEN.END_OF_INPUT] = "end of input";
            names[TOKEN.ENUM] = "enum";
            names[TOKEN.EQ] = "==";
            names[TOKEN.EQ_OBJ] = "=~";
            names[TOKEN.ESAC] = "esac";
            names[TOKEN.EXTENDS] = "isa";
            names[TOKEN.FALSE] = "false";
            names[TOKEN.FI] = "fi";
            names[TOKEN.FINALLY] = "finally";
            names[TOKEN.FOR] = "for";
            names[TOKEN.FOREACH] = "foreach";
            names[TOKEN.GE] = ">=";
            names[TOKEN.GET] = "get";
            names[TOKEN.GT] = ">";
            names[TOKEN.IDENTIFIER] = "identifier";
            names[TOKEN.IF] = "if";
            names[TOKEN.IMPORT] = "import";
            names[TOKEN.INT] = "int";
            names[TOKEN.INTERFACE] = "interface";
            names[TOKEN.INT_LITERAL] = "int literal";
            names[TOKEN.IS] = "is";
            names[TOKEN.ISA] = "isa";
            names[TOKEN.LE] = "<=";
            names[TOKEN.LET] = "let";
            names[TOKEN.LONG] = "long";
            names[TOKEN.LT] = "<";
            names[TOKEN.PERCENT] = "%";
            names[TOKEN.STAR] = "*";
            names[TOKEN.NAMESPACE] = "namespace";
            names[TOKEN.NATIVE] = "native";
            names[TOKEN.NE] = "!=";
            names[TOKEN.NE_OBJ] = "!~";
            names[TOKEN.NEW] = "new";
            names[TOKEN.NONE] = "none";
            names[TOKEN.NOT] = "not";
            names[TOKEN.NULL] = "null";
            names[TOKEN.OD] = "od";
            names[TOKEN.OPERATOR] = "operator";
            names[TOKEN.OR] = "or";
            names[TOKEN.OR_ELSE] = "||";
            names[TOKEN.PAREN_CLOSE] = ")";
            names[TOKEN.PAREN_OPEN] = "(";
            names[TOKEN.PRAGMA] = "pragma";
            names[TOKEN.PRIVATE] = "private";
            names[TOKEN.PROC] = "proc";
            names[TOKEN.PROTECTED] = "protected";
            names[TOKEN.PTR] = "ptr";
            names[TOKEN.PUBLIC] = "public";
            names[TOKEN.QUESTION] = "?";
            names[TOKEN.RANGE] = "..";
            names[TOKEN.REF] = "ref";
            names[TOKEN.RETURN] = "return";
            names[TOKEN.SEMICOLON] = ";";
            names[TOKEN.SET] = "set";
            names[TOKEN.SHIFT_LEFT] = "<<";
            names[TOKEN.SHIFT_RIGHT] = ">>";
            names[TOKEN.SI] = "si";
            names[TOKEN.SQUARE_CLOSE] = "]";
            names[TOKEN.SQUARE_OPEN] = "[";
            names[TOKEN.STATIC] = "static";
            names[TOKEN.STRING_LITERAL] = "string literal";
            names[TOKEN.STRUCT] = "struct";
            names[TOKEN.MINUS] = "-";
            names[TOKEN.SUPER] = "super";
            names[TOKEN.SWITCH] = "switch";
            names[TOKEN.THEN] = "then";
            names[TOKEN.THIS] = "this";
            names[TOKEN.THROW] = "throw";
            names[TOKEN.TRUE] = "true";
            names[TOKEN.TRY] = "try";
            names[TOKEN.UNKNOWN] = "unknown";
            names[TOKEN.UNTIL] = "until";
            names[TOKEN.USE] = "use";
            names[TOKEN.VAR] = "var";
            names[TOKEN.VECTOR] = "vector";
            names[TOKEN.VOID] = "void";
            names[TOKEN.WHILE] = "while";
            names[TOKEN.WORD] = "word";
            names[TOKEN.XOR] = "xor";
            names[TOKEN.YRT] = "ytr";
        si

        private static get TOKEN_NAMES instance is
            if _instance == null then
                _instance = new TOKEN_NAMES();
            fi

            return _instance;
        si

        public static get String[Lexical.TOKEN token] is
            var result = instance.names[token];

            if result == null then
                result = "unknown-" + cast int(token);
            fi

            return result;
        si

        public static get String[Iterable<Lexical.TOKEN> tokens] is
            var sorted_tokens = new Vector<Lexical.TOKEN>();
            sorted_tokens.add(tokens);
            Sort<Lexical.TOKEN>.sort(sorted_tokens);

            var result = new StringBuffer();

            var seen_any = false;

            foreach var t; sorted_tokens do
                if seen_any then
                    result.append(", ");
                fi

                result.append(TOKEN_NAMES[t]);

                seen_any = true;
            od

            var i = result.lastIndexOf(',');

            if i >= 0 then
                var left = result.substring(0, i);
                var right = result.substring(i + 2);

                result = 
                    new StringBuffer()
                        .append(left)
                        .append(" or ")
                        .append(right);
            fi

            return result;
        si
    si
si