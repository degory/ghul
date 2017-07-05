import args;

import gsort;

import system_coalesce;

import logger;

import lexical_token;
import lexical_token_names;
import lexical_tokenizer;

import syntax_location;

import syntax_parser_context;

import syntax_parser;

import syntax_parser_type;
import syntax_parser_definition;
import syntax_parser_identifier;
import syntax_parser_definition;
import syntax_parser_expression;

import syntax_tree;
import syntax_tree_type;
import syntax_tree_definition;
import syntax_tree_expression;

import syntax_tree_visitor;
import syntax_tree_transformer;

import process_printer;

namespace Main is
    use System;
    use Logging;
    
    class Main is
        void init() is
            try 
                var args = Arguments.ProgramArguments.Iterator;

                args.nextElement();

                foreach var s; args do
                    var tokenizer = new Lexical.TOKENIZER(
                        s,
                        IO.File.openRead(s)
                    );

                    var logger = new LOGGER();                    

                    var context = new Syntax.Parser.CONTEXT(
                        tokenizer,
                        logger
                    );

                    for var done = false; !done; do
                        var type = context.parse_type();

                        if type != null then
                            IO.Std.err.println("%: %" % Object{type.location, type});
                        else
                            done = true;
                        fi
                    od
                od
            catch Exception e
                IO.Std.err.println(e);                
            yrt
        si
    si
si

