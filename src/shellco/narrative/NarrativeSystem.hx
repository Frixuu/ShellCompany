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
    
    /**
        Registers a dialogue line.
        @param name The name of the character saying things.
        @param message The thing to say.
        @param nameColor The color of the character name.
        @param mode Queue mode (how soon should the line happen).
        @param startIfNothingToSay If this is the only line, auto-starts a conversation.
    **/
    public function say(
        name: String,
        message: String,
        nameColor: Color = Color.WHITE,
        mode: SayMode = Queue,
        startIfNothingToSay: Bool = true
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
        }
        
        if (startIfNothingToSay && queue.length == 1) {
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
