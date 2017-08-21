namespace Syntax is namespace Process is
    use Tree;

    class EXPAND_NAMESPACES isa Visitor is
        void init() is
            super.init();
        si

        void visit(Definition.NAMESPACE namespace_) is
            IO.Std.err.println("namespace: " + namespace_.name);

            var names = namespace_.name.parent_names;

            if names.Length > 0 then
                IO.Std.err.println("namespace requires expansion: " + namespace_.name + " " + names);

                // FIXME: redundant?
                namespace_.name =
                    new Identifier.NODE(
                        namespace_.name.location,
                        namespace_.name.name
                    );

                var body = namespace_.body;

                var current = namespace_;
                
                foreach var n; names do
                    IO.Std.err.println("wrap with " + n);

                    current.body = 
                        new Definition.LIST(
                            current.location,
                            Definition.NODE{
                                new Definition.NAMESPACE(
                                    current.location,
                                    current.name,
                                    current.body
                                )
                            }
                        );

                    current.name =
                        new Identifier.NODE(
                            namespace_.name.location,
                            n
                        );
                od
            fi
        si
    si
si si