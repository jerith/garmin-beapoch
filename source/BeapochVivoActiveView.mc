using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.ActivityMonitor;

const DURATION_MINUTE = new Time.Duration(60);

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
            View.findDrawableById("AnalogTime").setDrawSec(true);
        } else {
            View.findDrawableById("UnixDisplay").setText("");
            View.findDrawableById("AnalogTime").setDrawSec(false);
        }
        View.findDrawableById("WeekdayDots").setWeekday(ginfo.day_of_week);
        var dateString = Lang.format("$1$-$2$-$3$", [ginfo.year, ginfo.month.format("%02d"), ginfo.day.format("%02d")]);
        View.findDrawableById("DateDisplay").setText(dateString);
        var secs = awake ? ginfo.sec.format("%02d") : "--";
        var timeString = Lang.format("$1$:$2$:$3$", [ginfo.hour.format("%02d"), ginfo.min.format("%02d"), secs]);
        View.findDrawableById("TimeDisplay").setText(timeString);

        var amInfo = ActivityMonitor.getInfo();
        View.findDrawableById("StepsDisplay").setText(Lang.format("s $1$", [amInfo.steps.format("%d")]));
        var hrText = getRecentHeartRate(now.subtract(DURATION_MINUTE));
        View.findDrawableById("HRDisplay").setText(hrText);

        View.onUpdate(dc);
    }

    function onExitSleep() {
        awake = true;
        requestUpdate();
    }

    function onEnterSleep() {
        awake = false;
        requestUpdate();
    }

    function applySettings(app) {
        View.findDrawableById("AnalogTime").setEnabled(app.getProperty("ShowAnalog"));
    }
}

function getRecentHeartRate(earliest) {
    // Make sure we get a recent, valid heart rate value.
    var hrIter = ActivityMonitor.getHeartRateHistory(5, true);
    var hrSample = hrIter.next();
    while (hrSample != null && hrSample.when.greaterThan(earliest)) {
        if (hrSample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
            return Lang.format("h $1$", [hrSample.heartRate.format("%d")]);
        }
        hrSample = hrIter.next();
    }
    return "h - -";
}