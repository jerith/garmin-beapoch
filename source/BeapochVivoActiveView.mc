using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class BeapochVivoActiveView extends WatchUi.WatchFace {

    hidden var awake = true;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        // We call this here because we need the resources to have been loaded already.
        applySettings(Application.getApp());
    }

    function onUpdate(dc) {
        // System.ClockTime doesn't give us the date. :-(
        var now = Time.now();
        var ginfo = Time.Gregorian.info(now, Time.FORMAT_SHORT);

        if (awake) {
            View.findDrawableById("UnixDisplay").setText(now.value().format("%d"));
        }
        View.findDrawableById("WeekdayDots").setWeekday(ginfo.day_of_week);
        var dateString = Lang.format("$1$-$2$-$3$", [ginfo.year, ginfo.month.format("%02d"), ginfo.day.format("%02d")]);
        View.findDrawableById("DateDisplay").setText(dateString);
        var secs = awake ? ginfo.sec.format("%02d") : "--";
        var timeString = Lang.format("$1$:$2$:$3$", [ginfo.hour.format("%02d"), ginfo.min.format("%02d"), secs]);
        View.findDrawableById("TimeDisplay").setText(timeString);

//        var ainfo = ActivityMonitor.getInfo();
//        View.findDrawableById("StepsDisplay").setText(ainfo.steps.format("%d"));

        View.onUpdate(dc);
    }

    function onExitSleep() {
        awake = true;
        View.findDrawableById("AnalogTime").setDrawSec(true);
        requestUpdate();
    }

    function onEnterSleep() {
        awake = false;
        // Clear displays we don't use while asleep.
        View.findDrawableById("UnixDisplay").setText("");
        View.findDrawableById("AnalogTime").setDrawSec(false);
        requestUpdate();
    }

    function applySettings(app) {
        View.findDrawableById("AnalogTime").setEnabled(app.getProperty("ShowAnalog"));
    }
}
