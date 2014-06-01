function getStyleRuleValue(selector, style) {
    var sheets = document.styleSheets;
    for (var i = 0; i < sheets.length; i++) {
        var sheet = sheets[i];
        if( !sheet.cssRules ) { continue; }
        for (var j = 0, k = sheet.cssRules.length; j < k; j++) {
            var rule = sheet.cssRules[j];
            if (rule.selectorText && rule.selectorText.split(',').indexOf(selector) !== -1) {
                return rule.style[style];
            }
        }
    }
    return null;
}


function setStyleRuleValue(selector, style, value) {
    var sheets = document.styleSheets;
    for (var i = 0; i < sheets.length; i++) {
        var sheet = sheets[i];
        if( !sheet.cssRules ) { continue; }
        for (var j = 0, k = sheet.cssRules.length; j < k; j++) {
            var rule = sheet.cssRules[j];
            if (rule.selectorText && rule.selectorText.split(',').indexOf(selector) !== -1) {
                rule.style[style] = value;
                return;
            }
        }
    }
    return null;
}


