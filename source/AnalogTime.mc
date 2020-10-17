using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Math;

class AnalogTime extends Ui.Drawable {
    hidden var cHour, cMin, cSec;
    // Settings
    hidden var drawSec = true;
    hidden var enabled = false;

    private var cx, cy, radius;

    function initialize(params) {
        Drawable.initialize(params);

        cHour = params.get(:cHour);
        cMin = params.get(:cMin);
        cSec = params.get(:cSec);

        var ds = System.getDeviceSettings();
        cx = ds.screenWidth / 2 - 0.5;
        cy = ds.screenHeight / 2 - 0.5;
        radius = ds.screenWidth / 2;
    }

    function draw(dc) {
        if (!enabled) {
            return;
        }

        var time = System.getClockTime();

        var aHour = 30 * time.hour + time.min / 2; 
        var aMin = time.min * 6 + time.sec / 10; 
        var aSec = time.sec * 6;

        dc.setColor(cHour, Graphics.COLOR_TRANSPARENT);
        var p = a2p(aHour, -3);
        dc.fillCircle(p[0], p[1], 2);

        dc.setColor(cMin, Graphics.COLOR_TRANSPARENT);
        drawLine(dc, aMin, 6, 2);

        if (drawSec) {
            dc.setColor(cSec, Graphics.COLOR_TRANSPARENT);
            drawLine(dc, aSec, 8, 1);
        }
    }

    function setDrawSec(value) {
        drawSec = value;
    }

    function setEnabled(value) {
        enabled = value;
    }

    private function a2p(angle, rOffset) {
        angle = Math.toRadians(angle - 90);
        return [
            Math.round(cx + (radius + rOffset) * Math.cos(angle)), 
            Math.round(cy + (radius + rOffset) * Math.sin(angle)),
        ];
    }

    private function drawLine(dc, angle, len, lw) {
        dc.setPenWidth(lw);
        for (var i = -len; i < 1; i++) {
            var lp = a2p(angle, i);
            dc.drawPoint(lp[0], lp[1]);
        }
    }
}
