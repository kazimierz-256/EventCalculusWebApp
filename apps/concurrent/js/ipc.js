let getPengineAwaitable = (application, query, oncreate, onsuccess, onfailure, onstop, onabort, onerror, onoutput) => {
    return new Pengine({
        application: application,
        ask: query,
        oncreate: function () {
            if (oncreate)
                oncreate(this);
        },
        onsuccess: function () {
            if (onsuccess)
                onsuccess(this);
            else {
                console.log(this.data);
                if (this.more) {
                    console.log("more solutions?");
                } else {
                    console.log("No more solutions");
                }
            }
        },
        onfailure: function () {
            if (onfailure)
                onfailure(this);
            else {
                console.error("Failure");
            }
        },
        onstop: function () {
            if (onstop)
                onstop(this);
            else {
                console.log("Stopped");
            }
        },
        onabort: function () {
            if (onabort)
                onabort(this);
            else {
                console.warn("Aborted");
            }
        },
        onerror: function () {
            if (onerror)
                onerror(this);
            else {
                console.error("Error: " + this.data);
            }
        },
        onoutput: function () {
            if (onoutput)
                onoutput(this);
            else {
                console.log(this.data);
            }
        }
    });
}

let getAllSolutions = (application, query, oncreate, onsuccess, onfailure, onstop, onabort, onerror, onoutput) => {
    let results = [];
    let pengine;
    let askAgain = () => pengine.next();
    return pengine = getPengineAwaitable(application, query, oncreate, result => {
        results.push(result.data);
        if (result.more)
            askAgain();
        else {
            onsuccess(results);
        }
    }, onfailure, onstop, onabort, onerror, onoutput);
}