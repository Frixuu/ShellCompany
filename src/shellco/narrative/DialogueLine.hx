// SPDX-License-Identifier: MIT
package shellco.narrative;

import ceramic.Color;

@:structInit
final class DialogueLine {

    public final characterName: String;
    public final text: String;
    public final portrait: String;
    public final nameColor: Color;
    public final callback: Null<() -> Void>;
    
    public function new(
        characterName: String,
        text: String,
        ?portrait: String,
        ?nameColor: Color,
        ?callback: () -> Void
    ) {
        this.characterName = characterName;
        this.text = text;
        this.portrait = portrait ?? characterName;
        this.nameColor = nameColor ?? Color.WHITE;
        this.callback = callback;
    }
}
