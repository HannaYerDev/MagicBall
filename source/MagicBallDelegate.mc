import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

class MagicBallDelegate extends WatchUi.InputDelegate {

    var _view;
    var _answers;

    function initialize(view, answers) {
        InputDelegate.initialize();
        _view = view;
        _answers = answers;
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Boolean {
        var coords = clickEvent.getCoordinates();
        var x = coords[0];
        var y = coords[1];

        var screen = System.getDeviceSettings();
        var cx = screen.screenWidth / 2;
        var cy = screen.screenHeight / 2 + 8;
        var radius = 88;

        var dx = x - cx;
        var dy = y - cy;

        if ((dx * dx + dy * dy) <= (radius * radius)) {
            _view.setPressed(true);

            var index = Math.rand() % _answers.size();
            var answer = _answers[index];

            _view.showAnswer(answer);

            return true;
        }

        return false;
    }
}