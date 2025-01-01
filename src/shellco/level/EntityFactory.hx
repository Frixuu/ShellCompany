// SPDX-License-Identifier: MIT
package shellco.level;

import ceramic.LdtkData.LdtkEntityInstance;
import ceramic.Visual;

using Lambda;

/**
    This factory creates `Visual` entities based on entity definitions
    from the loaded LDtk level.
**/
final class EntityFactory {

    private final rules: Array<Rule>;
    
    public function new() {
        this.rules = [];
    }
    
    /**
        Adds a new subfactory to this `EntityFactory`.
        @param rule A producer with a predicate.
        @return Self.
    **/
    public function addRule(rule: Rule): EntityFactory {
        this.rules.push(rule);
        return this;
    }
    
    /**
        Creates a new Ceramic `Visual`.
        @param entity The loaded entity data.
        @return A `Visual` to be added to the tilemap or `null`, if the entity is unrepresentable.
    **/
    public function createVisualForLdtkEntity(entity: LdtkEntityInstance): Null<Visual> {
    
        final definition = entity.def;
        
        final visual = this.rules.find(rule -> rule.predicate(entity))?.producer(entity);
        if (visual != null) {
            visual.anchor(definition.pivotX, definition.pivotY);
            visual.size(definition.width, definition.height);
            visual.pos(entity.pxX, entity.pxY);
        }
        
        return visual;
    }
}

/**
    A small logic portion that only matches certain entities.
**/
@:struct
@:structInit
final class Rule {

    /**
        For which entities this rule should be applicable?
    **/
    public final predicate: (LdtkEntityInstance) -> Bool;
    
    /**
        The function that creates `Visual`s for matching entities.
    **/
    public final producer: (LdtkEntityInstance) -> Null<Visual>;
}
