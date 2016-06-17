Element.prototype.remove = function() {
    this.parentElement.removeChild(this);
}

NodeList.prototype.remove = HTMLCollection.prototype.remove = function() {
    for(var i = this.length - 1; i >= 0; i--) {
        if(this[i] && this[i].parentElement) {
            this[i].parentElement.removeChild(this[i]);
        }
    }
}

document.getElementsByClassName("cd-overlay").remove();
document.getElementById("cd-nav").remove();
document.getElementById("livefyre-comments").remove();
document.getElementsByClassName("animsition").remove();
document.getElementById("mydiv").remove();
//document.getElementById("notifySnack-nhk9shk-pusher").remove()
//document.getElementById("notifySnack-nhk9shk").remove()
document.getElementsByClassName("section section-padding-top-bottom-small black-background").remove()
document.getElementsByClassName("section footer white-background").remove()


var divs = document.getElementsByTagName("div");

for (var div in divs) {
    if (div.className != null && div.className.indexOf("notify") > -1) {
        div.remove();
    }
}


var frames = document.getElementsByClassName("iframe");

for (var iframe in frames) {
    if (iframe.src != null && iframe.src.indexOf("football") <= -1 && iframe.src.indexOf("stream") <= -1) {
        iframe.remove();
    }
}

webkit.messageHandlers.didFinishLoading.postMessage(document.documentElement.outerHTML.toString());