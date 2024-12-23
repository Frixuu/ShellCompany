// SPDX-License-Identifier: MIT
package shellco.visual;

import ceramic.System;
import haxe.ds.ObjectMap;

/**
    This system snaps entities to the grid.
**/
@:allow(shellco.visual.SnapTransformComponent)
final class SnapTransformsSystem extends System {

    /**
        Singleton instance.
    **/
    @lazy private static var instance: SnapTransformsSystem = new SnapTransformsSystem();
    
    /**
        Set of known visuals with a marker component.
    **/
    public final knownComponents: ObjectMap<SnapTransformComponent, Bool> = new ObjectMap();
    
    public function new() {
        super();
        this.lateUpdateOrder = 10000;
    }
    
    private override function lateUpdate(delta: Float) {
        for (component in this.knownComponents.keys()) {
            final entity = component.visual;
            final x = entity.x;
            entity.translateX = Math.round(x) - x;
            final y = entity.y;
            entity.translateY = Math.round(y) - y;
        }
    }
}
