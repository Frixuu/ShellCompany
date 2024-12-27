// SPDX-License-Identifier: MIT
package shellco.inventory;

import ceramic.ReadOnlyArray;
import ceramic.System;

final class InventorySystem extends System {

    /**
        Singleton instance of this system.
    **/
    @lazy public static var instance: InventorySystem = new InventorySystem();
    
    private final _items: Array<Item> = [];
    
    /**
        Items in this inventory.
    **/
    public var items(get, never): ReadOnlyArray<Item>;
    
    private inline function get_items(): ReadOnlyArray<Item> {
        return this._items;
    }
    
    @event public function itemAdded(item: Item, newCount: Int);
    
    @event public function itemRemoved(item: Item, newCount: Int);
}
