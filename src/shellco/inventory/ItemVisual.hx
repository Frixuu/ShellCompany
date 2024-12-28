// SPDX-License-Identifier: MIT
package shellco.inventory;

import ceramic.App;
import ceramic.Color;
import ceramic.Quad;
import ceramic.TouchInfo;
import shellco.ui.SoftwareCursor;

final class ItemVisual extends Quad {

    public var item: Item;
    
    private var startX: Float = 0;
    private var startY: Float = 0;
    private var startPointerX: Float = 0;
    private var startPointerY: Float = 0;
    
    public function new(item: Item) {
        super();
        this.item = item;
        this.roundTranslation = 1;
        this.color = Color.YELLOW;
        this.anchor(0.0, 0.0);
        this.size(24, 24);
        this.onPointerOver(this, _ -> SoftwareCursor.instance.animation = "crosshair (dynamic)");
        this.onPointerOut(this, _ -> SoftwareCursor.instance.animation = "crosshair (static)");
        this.onPointerDown(this, this.onClick);
    }
    
    private function onClick(info: TouchInfo) {
        this.color = Color.RED;
        final screen = App.app.screen;
        App.app.onUpdate(this, this.onDrag);
        this.startX = this.parent.x;
        this.startY = this.parent.y;
        this.startPointerX = screen.pointerX;
        this.startPointerY = screen.pointerY;
        this.oncePointerUp(this, this.onRelease);
    }
    
    private function onDrag(_ignored: Float) {
        final screen = App.app.screen;
        this.translate((screen.pointerX - this.startPointerX) - (this.parent.x - this.startX),
            (screen.pointerY - this.startPointerY) - (this.parent.y - this.startY));
    }
    
    private function onRelease(info: TouchInfo) {
        this.color = Color.YELLOW;
        this.translate(0, 0);
        App.app.offUpdate(this.onDrag);
    }
}
