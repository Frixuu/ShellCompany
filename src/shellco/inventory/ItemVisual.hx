// SPDX-License-Identifier: MIT
package shellco.inventory;

import arcade.Body;
import ceramic.App;
import ceramic.Color;
import ceramic.Group;
import ceramic.Quad;
import ceramic.TouchInfo;
import ceramic.Tween;
import ceramic.Visual;
import ceramic.VisualArcadePhysics;
import shellco.ui.SoftwareCursor;

final class ItemVisual extends Quad {

    public var item: Item;
    
    private var startX: Float = 0;
    private var startY: Float = 0;
    private var startParentX: Float = 0;
    private var startParentY: Float = 0;
    private var startPointerX: Float = 0;
    private var startPointerY: Float = 0;
    private var target: Null<Visual> = null;
    
    public function new(item: Item) {
        super();
        this.item = item;
        this.roundTranslation = 1;
        this.color = Color.YELLOW;
        this.anchor(0.0, 0.0);
        this.size(24, 24);
        this.depth = 1;
        this.onPointerOver(this, _ -> SoftwareCursor.instance.animation = "crosshair (dynamic)");
        this.onPointerOut(this, _ -> SoftwareCursor.instance.animation = "crosshair (static)");
        this.onPointerDown(this, this.onClick);
        this.initArcadePhysics();
        
        App.app.group("droppable_on").add(this);
    }
    
    private function onClick(info: TouchInfo) {
        this.color = Color.RED;
        final screen = App.app.screen;
        App.app.onUpdate(this, this.onDrag);
        this.touchable = false;
        this.depth = 2;
        this.startX = this.x;
        this.startY = this.y;
        this.startParentX = this.parent?.x ?? 0;
        this.startParentY = this.parent?.y ?? 0;
        this.startPointerX = screen.pointerX;
        this.startPointerY = screen.pointerY;
        this.oncePointerUp(this, this.onRelease);
    }
    
    private function onDrag(_ignored: Float) {
        final screen = App.app.screen;
        this.pos((screen.pointerX - this.startPointerX)
            - ((this.parent?.x ?? 0) - this.startParentX)
            + this.startX,
            (screen.pointerY - this.startPointerY)
            - ((this.parent?.y ?? 0) - this.startParentY)
            + this.startY);
            
        final app = App.app;
        final group: Group<Visual> = cast app.group("droppable_on");
        final arcade = app.arcade;
        final world = arcade.world;
        
        this.target = null;
        for (groupItem in group.items) {
            if (groupItem != this && groupItem.hits(app.screen.pointerX, app.screen.pointerY)) {
                this.target = groupItem;
                return;
            }
        }
    }
    
    private function whenOverlap(left: Body, right: Body) {
        final leftVisual = (cast left.data: VisualArcadePhysics)?.visual;
        final rightVisual = (cast right.data: VisualArcadePhysics)?.visual;
        if (rightVisual == this && leftVisual != this) {
            this.target = leftVisual;
        } else if (leftVisual == this && rightVisual != this) {
            this.target = rightVisual;
        }
    }
    
    private function onRelease(info: TouchInfo) {
    
        final app = App.app;
        
        this.color = Color.YELLOW;
        final dx = this.x - this.startX;
        final dy = this.y - this.startY;
        this.pos(this.startX, this.startY);
        Tween.eagerStart(this, QUAD_EASE_OUT, 0.3, dx, 0, (v, t) -> this.translateX = v);
        Tween.eagerStart(this, QUAD_EASE_OUT, 0.3, dy, 0, (v, t) -> this.translateY = v);
        this.depth = 1;
        this.touchable = true;
        
        app.offUpdate(this.onDrag);
        
        final target = this.target;
        this.target = null;
        if (target != null) {
            if (target is ItemVisual) {
                final target: ItemVisual = cast target;
                app.logger.info('trying to combine items ${this.item} and ${target.item}');
                final resultItem = this.item.tryCombine(target.item);
                if (resultItem != null) {
                    final inventory = InventorySystem.instance;
                    inventory.removeItem(this.item);
                    inventory.removeItem(target.item);
                    inventory.addItem(resultItem);
                }
            } else if (target is InteractableVisual) {
                final target: InteractableVisual = cast target;
                app.logger.info('trying to use item ${this.item} on interactable $target');
                if (target.tryUseItem(this.item)) {
                    final inventory = InventorySystem.instance;
                    inventory.removeItem(this.item);
                }
            }
        }
    }
}
