import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class MagicBallApp extends Application.AppBase {
    var _answers = [];

    var POSITIVE_ANSWERS = [
        new MagicAnswer("Yes", ANSWER_POSITIVE),
        new MagicAnswer("Definitely", ANSWER_POSITIVE),
        new MagicAnswer("Very likely", ANSWER_POSITIVE),
        new MagicAnswer("The stars say yes", ANSWER_POSITIVE),
        new MagicAnswer("The cosmos approves", ANSWER_POSITIVE),
        new MagicAnswer("The omen is good", ANSWER_POSITIVE),
        new MagicAnswer("Bestie, yes", ANSWER_POSITIVE),
        new MagicAnswer("Do it", ANSWER_POSITIVE),
        new MagicAnswer("You already know", ANSWER_POSITIVE),
        new MagicAnswer("Suspiciously yes", ANSWER_POSITIVE),
        new MagicAnswer("The spreadsheet says yes", ANSWER_POSITIVE),
        new MagicAnswer("42", ANSWER_POSITIVE),
        new MagicAnswer("A gentle yes", ANSWER_POSITIVE)
    ];

    var NEGATIVE_ANSWERS = [
        new MagicAnswer("No", ANSWER_NEGATIVE),
        new MagicAnswer("Definitely not", ANSWER_NEGATIVE),
        new MagicAnswer("Unlikely", ANSWER_NEGATIVE),
        new MagicAnswer("The stars say no", ANSWER_NEGATIVE),
        new MagicAnswer("Mercury says no", ANSWER_NEGATIVE),
        new MagicAnswer("The vibes are off", ANSWER_NEGATIVE),
        new MagicAnswer("Girl... no", ANSWER_NEGATIVE),
        new MagicAnswer("Absolutely not", ANSWER_NEGATIVE),
        new MagicAnswer("That’s a terrible idea", ANSWER_NEGATIVE),
        new MagicAnswer("Do not do it", ANSWER_NEGATIVE),
        new MagicAnswer("Be serious", ANSWER_NEGATIVE),
        new MagicAnswer("Not with that attitude", ANSWER_NEGATIVE),
        new MagicAnswer("Hard no", ANSWER_NEGATIVE),
        new MagicAnswer("The Wi-Fi says no", ANSWER_NEGATIVE),
        new MagicAnswer("In this economy? No", ANSWER_NEGATIVE),
        new MagicAnswer("Not today", ANSWER_NEGATIVE),
        new MagicAnswer("A quiet no", ANSWER_NEGATIVE)
    ];

    var NEUTRAL_ANSWERS = [
        new MagicAnswer("Maybe", ANSWER_NEUTRAL),
        new MagicAnswer("Ask again later", ANSWER_NEUTRAL),
        new MagicAnswer("Try again later", ANSWER_NEUTRAL),
        new MagicAnswer("The moon is unsure", ANSWER_NEUTRAL),
        new MagicAnswer("The universe says wait", ANSWER_NEUTRAL),
        new MagicAnswer("Destiny says maybe", ANSWER_NEUTRAL),
        new MagicAnswer("Ask the cat", ANSWER_NEUTRAL),
        new MagicAnswer("Only if snacks are involved", ANSWER_NEUTRAL),
        new MagicAnswer("Not before coffee", ANSWER_NEUTRAL),
        new MagicAnswer("Chaotic but possible", ANSWER_NEUTRAL),
        new MagicAnswer("Legally... maybe", ANSWER_NEUTRAL),
        new MagicAnswer("Soon", ANSWER_NEUTRAL),
        new MagicAnswer("Be patient", ANSWER_NEUTRAL),
        new MagicAnswer("Trust the timing", ANSWER_NEUTRAL),
        new MagicAnswer("Soft maybe", ANSWER_NEUTRAL)
    ];

    function initialize() {
        AppBase.initialize();

        _answers.addAll(POSITIVE_ANSWERS);
        _answers.addAll(NEGATIVE_ANSWERS);
        _answers.addAll(NEUTRAL_ANSWERS);
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new MagicBallView();
        return [ view, new MagicBallDelegate(view, _answers) ];
    }
}