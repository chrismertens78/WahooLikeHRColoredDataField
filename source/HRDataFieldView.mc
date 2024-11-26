import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.UserProfile;
import Toybox.System;

class HRDataFieldView extends WatchUi.DataField {

    hidden var mValue as Numeric;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
    }

    // The layout function that positions the label and value views
    function onLayout(dc as Dc) as Void {
        View.setLayout(Rez.Layouts.MainLayout(dc));
        var screenWidth = dc.getWidth();  // Get the screen width
        var apeVersion = System.getDeviceSettings().monkeyVersion; // Get the MonkeyC Version to determine between devices
        if ((apeVersion[0] == 3 && apeVersion[1] == 3 && apeVersion[2] == 1) && (screenWidth == 122 || screenWidth == 246)) {  // For Edge 830
            var labelView = View.findDrawableById("label") as Text;
            labelView.locY = labelView.locY - 24;
            var valueView = View.findDrawableById("value") as Text;
            valueView.locY = valueView.locY + 12;
        } else if ((apeVersion[0] == 3 && apeVersion[1] == 3 && apeVersion[2] == 1) && (screenWidth == 140 || screenWidth == 282)) {  // For Edge 1030
            var labelView = View.findDrawableById("label") as Text;
            labelView.locY = labelView.locY - 30;
            var valueView = View.findDrawableById("value") as Text;
            valueView.locY = valueView.locY + 12;
        } else if ((apeVersion[0] == 5 && apeVersion[1] == 0 && apeVersion[2] == 0) && (screenWidth == 239 || screenWidth == 480)) {  // For Edge 1050
            var labelView = View.findDrawableById("label") as Text;
            labelView.locY = labelView.locY - 40;
            var valueView = View.findDrawableById("value") as Text;
            valueView.locY = valueView.locY + 12;
        } else if ((apeVersion[0] == 5 && apeVersion[1] == 0 && apeVersion[2] == 0) && (screenWidth == 140 || screenWidth == 282)) {  // For Edge 1040
            var labelView = View.findDrawableById("label") as Text;
            labelView.locY = labelView.locY - 20;
            var valueView = View.findDrawableById("value") as Text;
            valueView.locY = valueView.locY + 12;
        } else {  // For Edge 840
            var labelView = View.findDrawableById("label") as Text;
            labelView.locY = labelView.locY - 15;
            var valueView = View.findDrawableById("value") as Text;
            valueView.locY = valueView.locY + 12;
        }

        (View.findDrawableById("label") as Text).setText(Rez.Strings.label);  // Set the text for label
    }

    // Get the activity heart rate
    function compute(info as Activity.Info) as Void {
        if (info has :currentHeartRate) {
            if (info.currentHeartRate != null) {
                mValue = info.currentHeartRate as Number;
            } else {
                mValue = 0.0f;
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        var hinter = View.findDrawableById("Background") as Text;
        var hrz = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC) as Array;

        if (mValue > hrz[4]) {
            hinter.setColor(Graphics.COLOR_RED);
        } else if (mValue > hrz[3]) {
            hinter.setColor(Graphics.COLOR_YELLOW);
        } else if (mValue > hrz[2]) {
            hinter.setColor(Graphics.COLOR_GREEN);
        } else if (mValue > hrz[1]) {
            hinter.setColor(Graphics.COLOR_BLUE);
        } else if (mValue >= hrz[0]) {
            hinter.setColor(Graphics.COLOR_DK_GRAY);
        } else {
            hinter.setColor(getBackgroundColor());
        }

        var value = View.findDrawableById("value") as Text;
        if (mValue >= hrz[0]) {
            value.setColor(Graphics.COLOR_WHITE);
            (View.findDrawableById("label") as Text).setColor(Graphics.COLOR_WHITE);
        } else if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
            (View.findDrawableById("label") as Text).setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
            (View.findDrawableById("label") as Text).setColor(Graphics.COLOR_BLACK);
        }
        value.setText(mValue.format("%.0f"));

        View.onUpdate(dc);
    }
}

