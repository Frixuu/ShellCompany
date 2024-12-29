// SPDX-License-Identifier: MIT
package shellco.inventory;

import ceramic.Logger;
import ceramic.ReadOnlyArray;
import ceramic.System;
import haxe.ds.ObjectMap;

using Lambda;

final class InventorySystem extends System {

    /**
        Singleton instance of this system.
    **/
    @lazy public static var instance: InventorySystem = new InventorySystem();
    
    private final _items: ObjectMap<Item, Bool> = new ObjectMap();
    
    /**
        Items in this inventory.
    **/
    public var items(get, never): ReadOnlyArray<Item>;
    
    private final logger: Logger = new Logger();
    
    private inline function get_items(): ReadOnlyArray<Item> {
        return [for (key in this._items.keys()) key];
    }
    
    @event public function itemAdded(item: Item, newCount: Int);
    
    @event public function itemRemoved(item: Item, newCount: Int);
    
    public function addItem(item: Item) {
        if (!this._items.exists(item)) {
            this._items.set(item, true);
            this.logger.info('[INV] Adding item: ${item}');
            this.emitItemAdded(item, this._items.count());
        }
    }
    
    public function removeItem(item: Item) {
        if (this._items.remove(item)) {
            this.logger.info('[INV] Removing item: ${item}');
            this.emitItemRemoved(item, this._items.count());
        }
    }
}
