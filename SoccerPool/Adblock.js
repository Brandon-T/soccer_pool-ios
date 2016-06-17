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
document.getElementById("livefyre-comments").remove()
document.getElementsByClassName("animsition").remove()


/*var arr = document.getElementsByClassName("iframe")

for iframe in arr {
    if !iframe.src.includes("football") {
        iframe.remove()
    }
}*/

webkit.messageHandlers.didGetHTML.postMessage(document.documentElement.outerHTML.toString());