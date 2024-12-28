// SPDX-License-Identifier: MIT
package shellco.narrative;

import ceramic.Color;

@:structInit
final class DialogueLine {

    public final characterName: String;
    public final text: String;
    public final portrait: String;
    public final nameColor: Color;
    
    public function new(characterName: String, text: String, ?portrait: String, ?nameColor: Color) {
        this.characterName = characterName;
        this.text = text;
        this.portrait = portrait ?? characterName;
        this.nameColor = nameColor ?? Color.WHITE;
    }
}
