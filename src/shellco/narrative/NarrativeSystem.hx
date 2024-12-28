// SPDX-License-Identifier: MIT
package shellco.narrative;

import ceramic.Color;
import ceramic.System;
import haxe.ds.List;

final class NarrativeSystem extends System {

    /**
        Singleton instance of this system.
    **/
    @lazy public static var instance: NarrativeSystem = new NarrativeSystem();
    
    private final lineQueue: List<DialogueLine> = new List();
    
    @event public function convoAdvanced(line: Null<DialogueLine>);
    
    public function say(
        name: String,
        message: String,
        nameColor: Color = Color.WHITE,
        mode: SayMode = Queue
    ) {
        final line: DialogueLine = {characterName: name, text: message, nameColor: nameColor};
        final queue = this.lineQueue;
        switch (mode) {
            case Queue:
                queue.add(line);
            case InterruptAsap:
                queue.push(line);
            case Restart:
                queue.clear();
                queue.add(line);
                this.advanceConvo();
        }
    }
    
    public function advanceConvo() {
        this.emitConvoAdvanced(this.lineQueue.pop());
    }
}

enum abstract SayMode(Int) {
    public var Restart;
    public var Queue;
    public var InterruptAsap;
}
