// SPDX-License-Identifier: MIT
package shellco.inventory;

abstract class Item {

    public abstract function spriteName(): String;
    
    public function tryCombine(other: Item): Null<Item> {
        return null;
    }
}
