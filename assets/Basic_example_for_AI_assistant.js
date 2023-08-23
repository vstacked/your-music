// {Name: Basic_example_for_AI_assistant}
// {Description: Learn how to create a dialog script with voice/text commands and text corpus for question answering}

// Use this sample to create your own voice/text commands
intent('hello world', p => {
    p.play('(hello|hi there)');
});

intent('play $(TITLE* (.*)) song', p => {
    try {
        p.play({ 'command': 'play_specific', 'title': p.TITLE.value });
        p.play('(playing now|On it)');
    } catch (error) {
        console.log("Can't play");
        p.play('I could not find this music');
    }
});


intent('play', p => {
    p.play({ "command": "play" });
    p.play("(Playing Now|on it|Doing it)");
});

intent('resume', p => {
    p.play({ "command": "resume" });
    p.play("(Resume Now|on it|Doing it)");
});

intent('stop (it|)', 'stop (the|) song', 'pause (it|)', 'pause (the|) song', p => {
    p.play({ "command": "stop" });
    p.play("(Stopping Now|on it|Doing it)");
});

intent('(play|) next', p => {
    p.play({ "command": "next" });
    p.play("(on it|Doing it|sure)");
});

intent('(play|) previous', p => {
    p.play({ "command": "prev" });
    p.play("(on it|Doing it|sure)");
});

intent('about (apps|)', p => {
    p.play("This is just a music application.");
});



// Give your AI assistant some knowledge about the world
corpus(`
    Hello, I'm Alan.
    This is a demo application.
    You can learn how to teach Alan useful skills.
    I can teach you how to write Alan Scripts.
    I can help you. I can do a lot of things. I can answer questions. I can do tasks.
    But they should be relevant to this application.
    I can help with this application.
    I'm Alan. I'm a virtual assistant. I'm here to help you with applications.
    This is a demo script. It shows how to use Alan.
    You can create dialogs and teach me.
    For example: I can help navigate this application.
`);
