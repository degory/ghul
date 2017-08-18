namespace Syntax is namespace Tree is namespace Modifier is
    use Generic;

    use Source;

    class LIST isa Tree.NODE is
        public ACCESS_MODIFIER access_modifier;
        public STORAGE_CLASS storage_class;

        void init(
            LOCATION location,
            ACCESS_MODIFIER access_modifier,
            STORAGE_CLASS storage_class
        )
        is
            super.init(location);

            this.access_modifier = access_modifier;
            this.storage_class = storage_class;
        si

        get bool is_empty is
            return access_modifier == null && storage_class == null;
        si

        get bool is_static is
            return storage_class != null && isa STATIC(storage_class);
        si

        get bool is_public is
            return access_modifier != null && isa PUBLIC(access_modifier);
        si

        get bool is_private is
            return access_modifier != null && isa PRIVATE(access_modifier);
        si

        get bool is_explicit_access is
            return access_modifier != null;
        si

        void accept(Visitor visitor) is
            visitor.visit(this);
        si
        
        void walk(Visitor visitor) is
            if !visitor.pre(this) then
                access_modifier.walk(visitor);
                storage_class.walk(visitor);
            fi

            accept(visitor);
        si        
    si
si si si
