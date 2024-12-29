// SPDX-License-Identifier: MIT
package shellco.inventory;

class Cocktail extends Item {

    public function new() {}
    
    public override function tryCombine(other: Item): Null<Item> {
        if (other is Laxatives) {
            return new SpikedCocktail();
        }
        return null;
    }
    
    public function spriteName(): String {
        return "cocktail";
    }
}
