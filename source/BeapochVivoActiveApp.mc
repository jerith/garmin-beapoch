using Toybox.Application;

class BeapochVivoActiveApp extends Application.AppBase {

    private var mainView;

    function initialize() {
        AppBase.initialize();
        mainView = new BeapochVivoActiveView();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ mainView ];
    }

    function onSettingsChanged() {
        mainView.applySettings(self);
    }
}