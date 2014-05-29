function getStyleRuleValue(selector, style) {
    var sheets = document.styleSheets;
    for (var i = 0; i < sheets.length; i++) {
        var sheet = sheets[i];
        if( !sheet.cssRules ) { continue; }
        for (var j = 0, k = sheet.cssRules.length; j < k; j++) {
            var rule = sheet.cssRules[j];
            if (rule.selectorText && rule.selectorText.split(',').indexOf(selector) !== -1) {
//                rule.style[style] = "0px"
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
//        console.log(sheet)
        if( !sheet.cssRules ) { continue; }
//        console.log(123321)
        for (var j = 0, k = sheet.cssRules.length; j < k; j++) {
            var rule = sheet.cssRules[j];
//            console.log(rule)
            if (rule.selectorText && rule.selectorText.split(',').indexOf(selector) !== -1) {
                rule.style[style] = value;
//                console.log("success")
                return;
            }
        }
    }
//    console.log("selector or style not found")
    return null;
}



/*
function getStyleRuleValue(style, selector, sheet) {
    var sheets = typeof sheet !== 'undefined' ? [sheet] : document.styleSheets;
    for (var i = 0; i < sheets.length; i++) {
        var sheet = sheets[i];
        console.log(sheet);
        console.log(sheet.rules);
        if( !sheet.cssRules ) { continue; }
        console.log(123321);
        for (var j = 0, k = sheet.cssRules.length; j < k; j++) {
            var rule = sheet.cssRules[j];
            if (rule.selectorText && rule.selectorText.split(',').indexOf(selector) !== -1) {
                rule.style[style] = "0px"
                return rule.style[style];
            }
        }
    }
    return null;
}

*/