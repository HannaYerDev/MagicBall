import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MagicBallView extends WatchUi.View {
    var _showMessage = false;
    var _message = "Ask me";
    var _isPressed = false;
    var _timer;
    var _animTimer;
    var _returnTimer;
    var _animTick = 0;
    var _messageTick = 0;
    var _messageColor;
    var _currentAnswerKind;

    var COLOR_BG;
    var COLOR_OUTER_RING;
    var COLOR_ORB;
    var COLOR_ORB_PRESSED;
    var COLOR_INNER;
    var COLOR_ACCENT;
    var COLOR_TEXT;

    var COLOR_TEXT_POSITIVE;
    var COLOR_TEXT_NEGATIVE;
    var COLOR_TEXT_MAYBE;

    function initialize() {
        View.initialize();
        _animTimer = new Timer.Timer();
        _returnTimer = new Timer.Timer();
        _animTimer.start(method(:onAnimTick), 100, true);

        // base
        COLOR_BG = Graphics.createColor(255, 6, 8, 20); // deep navy
        COLOR_ORB = Graphics.createColor(255, 38, 36, 80); // dark blue orb
        COLOR_ORB_PRESSED = Graphics.createColor(255, 45, 60, 130);
        COLOR_INNER = Graphics.createColor(255, 10, 12, 28); // almost black
        COLOR_ACCENT = Graphics.createColor(255, 120, 140, 255); // soft blue glow
        COLOR_OUTER_RING = Graphics.createColor(255, 80, 90, 160);
        COLOR_TEXT = Graphics.createColor(255, 230, 235, 255); // soft white
        COLOR_TEXT_POSITIVE = Graphics.createColor(255, 120, 230, 200); // mint
        COLOR_TEXT_NEGATIVE = Graphics.createColor(255, 230, 120, 150); // soft rose
        COLOR_TEXT_MAYBE = Graphics.createColor(255, 170, 140, 240); // violet
    }

    function setPressed(pressed) as Void {
        _isPressed = pressed;
        WatchUi.requestUpdate();
    }

    function showAnswer(answer) as Void {
        _showMessage = true;
        _message = answer.text;
        _currentAnswerKind = answer.kind;
        _messageColor = colorForAnswerKind(answer.kind);

        _messageTick = 0;

        System.println("answer=" + answer.text);
        System.println("kind=" + answer.kind);
        System.println("messageColor=" + _messageColor.toString());

        _returnTimer.stop();
        _returnTimer.start(method(:onReturnToAsk), 5000, false);

        WatchUi.requestUpdate();
    }

    // function glowColorForAnswerKind(kind) {
    //     if (kind == ANSWER_POSITIVE) {
    //         return COLOR_TEXT_POSITIVE;
    //     } else if (kind == ANSWER_NEGATIVE) {
    //         return COLOR_TEXT_NEGATIVE;
    //     }
    //     return COLOR_TEXT_MAYBE;
    // }

    function colorForAnswerKind(kind) {
        if (kind == ANSWER_POSITIVE) {
            System.println("branch POSITIVE");
            return COLOR_TEXT_POSITIVE;
        } else if (kind == ANSWER_NEGATIVE) {
            System.println("branch NEGATIVE");
            return COLOR_TEXT_NEGATIVE;
        }

        System.println("branch NEUTRAL");
        return COLOR_TEXT_MAYBE;
    }

    function onReturnToAsk() as Void {
        showButton();
    }

    function showButton() as Void {
        _showMessage = false;
        _isPressed = false;
        WatchUi.requestUpdate();
    }

    function onTimerDone() as Void {
        showButton();
    }

    function onAnimTick() as Void {
        _animTick += 1;

        if (_showMessage) {
            _messageTick += 1;
        } else {
            _messageTick = 0;
        }

        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        View.onUpdate(dc);

        var w = dc.getWidth();
        var h = dc.getHeight();

        var cx = w / 2;
        var cy = h / 2 + 8;

        var pulse = _animTick % 10;

        var orbOffset = 0;
        if (!_showMessage) {
            if (pulse < 5) {
                orbOffset = pulse;
            } else {
                orbOffset = 10 - pulse;
            }
        }

        var orbR = 96 + orbOffset / 2;
        var innerR = 78;

        var ringR = orbR + 8;
        if (_showMessage) {
            ringR = orbR + 8 + (_messageTick % 4);
        }

        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();

        // main orb
        if (_isPressed) {
            dc.setColor(COLOR_ORB_PRESSED, COLOR_ORB_PRESSED);
        } else {
            dc.setColor(COLOR_ORB, COLOR_ORB);
        }
        dc.fillCircle(cx, cy, orbR);

        // dark center
        dc.setColor(COLOR_INNER, COLOR_INNER);
        dc.fillCircle(cx, cy, innerR);

        // single animated ring
        var ringColor = COLOR_ACCENT;
        if (_showMessage) {
            ringColor = _messageColor;
        }

        dc.setColor(ringColor, ringColor);
        dc.drawCircle(cx, cy, ringR);

        if (_showMessage) {
            drawCenteredMessage(dc, cx, cy, _message);
        } else {
            drawButtonContent(dc, cx, cy);
        }
    }

    function drawButtonContent(
        dc as Graphics.Dc,
        cx as Number,
        cy as Number
    ) as Void {
        dc.setColor(Graphics.COLOR_WHITE, COLOR_INNER);
        dc.drawText(
            cx,
            cy - 26,
            Graphics.FONT_XTINY,
            "Ask",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(Graphics.COLOR_WHITE, COLOR_INNER);
        dc.drawText(
            cx,
            cy + 2,
            Graphics.FONT_XTINY,
            "me!",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    function drawCenteredMessage(
        dc as Graphics.Dc,
        cx as Number,
        cy as Number,
        message as String
    ) as Void {
        dc.setColor(_messageColor, COLOR_INNER);

        var lines = splitMessage(message);

        if (lines.size() == 1) {
            dc.drawText(
                cx,
                cy - 12,
                Graphics.FONT_XTINY,
                lines[0],
                Graphics.TEXT_JUSTIFY_CENTER
            );
        } else if (lines.size() == 2) {
            dc.drawText(
                cx,
                cy - 26,
                Graphics.FONT_XTINY,
                lines[0],
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.drawText(
                cx,
                cy + 2,
                Graphics.FONT_XTINY,
                lines[1],
                Graphics.TEXT_JUSTIFY_CENTER
            );
        } else {
            dc.drawText(
                cx,
                cy - 38,
                Graphics.FONT_XTINY,
                lines[0],
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.drawText(
                cx,
                cy - 12,
                Graphics.FONT_XTINY,
                lines[1],
                Graphics.TEXT_JUSTIFY_CENTER
            );
            dc.drawText(
                cx,
                cy + 14,
                Graphics.FONT_XTINY,
                lines[2],
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
    }

    function splitMessage(message as String) as Array<String> {
        var text = trimSpaces(message);
        var spaces = getSpacePositions(text);
        var spaceCount = spaces.size();

        if (spaceCount == 0) {
            return [text];
        }

        if (spaceCount == 1) {
            var p = spaces[0];
            return [text.substring(0, p), text.substring(p + 1, text.length())];
        }

        if (spaceCount == 2) {
            var p1 = spaces[0];
            var p2 = spaces[1];

            var line1a = text.substring(0, p1);
            var line2a = text.substring(p1 + 1, text.length());

            var line1b = text.substring(0, p2);
            var line2b = text.substring(p2 + 1, text.length());

            var diffA = absValue(line1a.length() - line2a.length());
            var diffB = absValue(line1b.length() - line2b.length());

            if (diffA <= diffB) {
                return [line1a, line2a];
            } else {
                return [line1b, line2b];
            }
        }

        // 3+ spaces -> 3 lines
        var bestLines = null;
        var bestScore = 9999;

        for (var i = 0; i < spaceCount - 1; i += 1) {
            for (var j = i + 1; j < spaceCount; j += 1) {
                var s1 = spaces[i];
                var s2 = spaces[j];

                var line1 = trimSpaces(text.substring(0, s1));
                var line2 = trimSpaces(text.substring(s1 + 1, s2));
                var line3 = trimSpaces(text.substring(s2 + 1, text.length()));

                if (
                    line1.length() == 0 ||
                    line2.length() == 0 ||
                    line3.length() == 0
                ) {
                    continue;
                }

                var maxLen = max3(
                    line1.length(),
                    line2.length(),
                    line3.length()
                );
                var minLen = min3(
                    line1.length(),
                    line2.length(),
                    line3.length()
                );
                var score = maxLen - minLen;

                if (score < bestScore) {
                    bestScore = score;
                    bestLines = [line1, line2, line3];
                }
            }
        }

        if (bestLines != null) {
            return bestLines;
        }

        return [text];
    }

    function getSpacePositions(text as String) as Array<Number> {
        var result = [] as Array<Number>;
        var chars = text.toCharArray();

        for (var i = 0; i < chars.size(); i += 1) {
            var code = chars[i].toNumber();

            // ordinary space + common non-breaking space
            if (code == 32 || code == 160) {
                result.add(i);
            }
        }

        return result;
    }

    function splitWords(text as String) as Array<String> {
        var trimmed = trimSpaces(text);
        var chars = trimmed.toCharArray();
        var result = [] as Array<String>;
        var current = "";

        for (var i = 0; i < chars.size(); i += 1) {
            var ch = chars[i].toString();

            if (ch == " ") {
                if (current.length() > 0) {
                    result.add(current);
                    current = "";
                }
            } else {
                current += ch;
            }
        }

        if (current.length() > 0) {
            result.add(current);
        }

        return result;
    }

    function splitIntoTwoLines(words as Array<String>) as Array<String> {
        var bestLines = null;
        var bestDiff = 9999;

        for (var i = 1; i < words.size(); i += 1) {
            var line1 = joinWords(words, 0, i);
            var line2 = joinWords(words, i, words.size());

            var diff = absValue(line1.length() - line2.length());

            if (diff < bestDiff) {
                bestDiff = diff;
                bestLines = [line1, line2];
            }
        }

        return bestLines;
    }

    function splitIntoThreeLines(words as Array<String>) as Array<String> {
        var bestLines = null;
        var bestScore = 9999;

        for (var i = 1; i < words.size() - 1; i += 1) {
            for (var j = i + 1; j < words.size(); j += 1) {
                var line1 = joinWords(words, 0, i);
                var line2 = joinWords(words, i, j);
                var line3 = joinWords(words, j, words.size());

                var maxLen = max3(
                    line1.length(),
                    line2.length(),
                    line3.length()
                );
                var minLen = min3(
                    line1.length(),
                    line2.length(),
                    line3.length()
                );

                var score = maxLen - minLen;

                if (score < bestScore) {
                    bestScore = score;
                    bestLines = [line1, line2, line3];
                }
            }
        }

        return bestLines;
    }

    function joinWords(
        words as Array<String>,
        start as Number,
        finish as Number
    ) as String {
        var result = "";

        for (var i = start; i < finish; i += 1) {
            if (result.length() > 0) {
                result += " ";
            }
            result += words[i];
        }

        return result;
    }

    function trimSpaces(text as String) as String {
        var start = 0;
        var finish = text.length();

        while (start < finish && text.substring(start, start + 1) == " ") {
            start += 1;
        }

        while (finish > start && text.substring(finish - 1, finish) == " ") {
            finish -= 1;
        }

        return text.substring(start, finish);
    }

    function absValue(value as Number) as Number {
        if (value < 0) {
            return -value;
        }
        return value;
    }

    function max3(a as Number, b as Number, c as Number) as Number {
        var result = a;
        if (b > result) {
            result = b;
        }
        if (c > result) {
            result = c;
        }
        return result;
    }

    function min3(a as Number, b as Number, c as Number) as Number {
        var result = a;
        if (b < result) {
            result = b;
        }
        if (c < result) {
            result = c;
        }
        return result;
    }
}
