using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class BeapochVivoActiveView extends WatchUi.WatchFace {

    hidden var highpower;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Update the view
    function onUpdate(dc) {
        // System.ClockTime doesn't give us the date. :-(
        var now = Time.now();
        var ginfo = Time.Gregorian.info(now, Time.FORMAT_SHORT);

        if (highpower) {
            View.findDrawableById("UnixDisplay").setText(now.value().format("%d"));
        }

        View.findDrawableById("WeekdayDots").setWeekday(ginfo.day_of_week);
        var dateString = Lang.format("$1$-$2$-$3$", [ginfo.year, ginfo.month.format("%02d"), ginfo.day.format("%02d")]);
        View.findDrawableById("DateDisplay").setText(dateString);
        var secs = "--";
        if (highpower) {
            secs = ginfo.sec.format("%02d");
        }
        var timeString = Lang.format("$1$:$2$:$3$", [ginfo.hour.format("%02d"), ginfo.min.format("%02d"), secs]);
        View.findDrawableById("TimeDisplay").setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
        highpower = true;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        highpower = false;
    }

}
