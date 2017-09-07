namespace Syntax is namespace Process is
    use Tree;

    class EXPAND_NAMESPACES isa Visitor is
        void init() is
            super.init();
        si

        public void apply(NODE node) is
            node.walk(this);
        si

        void visit(Definition.NAMESPACE namespace_) is
            var names = namespace_.name.parent_names;

            if names.Length > 0 then
                // FIXME: redundant?
                namespace_.name =
                    new Identifier.NODE(
                        namespace_.name.location,
                        namespace_.name.name
                    );

                var body = namespace_.body;

                var current = namespace_;
                
                foreach var n; names do
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