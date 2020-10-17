

//调用APP的函数
function invokePlugin(method, data, callback, seq) {
    var isAndroid = /Android/i.test(navigator.userAgent);
    var isIOS = /iphone|ipad/i.test(navigator.userAgent);

    var callUrl = [];
    // ios
    if (isAndroid) callUrl.push('http://plugin/?');
    else if(isIOS) callUrl.push('plugin://');
    callUrl.push('{"method" : "', method, '",');
    callUrl.push('"data" : ', data ? JSON.stringify(data) : "\"\"", ',');
    callUrl.push('"callback" : "nativeWindow"', ',');
    callUrl.push('"seq" : "', seq || 0, '"}');


    if (isIOS){
        window.location.href = callUrl.join('');
    }else if(isAndroid){
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", callUrl.join(''));
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
    }else{
        return new Promise((resolve, reject) => {
            console.log("noNative");
            reject("noNative");
        });
    }

    return new Promise((resolve, reject) => {
        window.nativeWindow = (type, result) => {
            resolve(result);
        };
    });
}
