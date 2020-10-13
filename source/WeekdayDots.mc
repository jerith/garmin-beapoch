using Toybox.WatchUi as Ui;
using Toybox.System;
using Toybox.Graphics;

class WeekdayDots extends Ui.Drawable {
    hidden var locX, locY, width, height, color, weekday;

    function initialize(params) {
        Drawable.initialize(params);

        var ds = System.getDeviceSettings();

        locX = (params.get(:xPct) * ds.screenWidth) / 100;
        locY = (params.get(:yPct) * ds.screenHeight) / 100;
        width = (params.get(:widthPct) * ds.screenWidth) / 100;
        height = (params.get(:heightPct) * ds.screenHeight) / 100;
        color = params.get(:color);
        weekday = 0;
    }

    function draw(dc) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        var y = locY + height/2;
        var hwidth = width/2;
        var interval = (hwidth - 2) / 3;
        // Calculate x value from middle to keep things balanced.
        var mid = locX + hwidth;
        for (var offset = 0; offset < 7; offset++) {
            var r = 1;
            if (offset == weekday) {
                r = 4;
            }
            dc.fillCircle(mid + (offset-3)*interval, y, r);
        }
    }

    function setWeekday(value) {
        // Translate from Gregorian values (Sunday=1) to offset (Monday=0).
        weekday = (value + 5) % 7;
    }
}
