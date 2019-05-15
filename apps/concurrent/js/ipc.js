let getExpertAwaitable = (application, query, onsuccess, onfailure, onstop, onabort, onerror) => {
    return new Pengine({
        application: application,
        ask: query,
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
        }
    });
}

let getAllSolutions = (application, query, onsuccess, onfailure, onstop, onabort, onerror) => {
    let results = [];
    let pengine;
    let askAgain = () => pengine.next();
    return pengine = getExpertAwaitable(application, query, result => {
        results.push(result.data);
        if (result.more)
            askAgain();
        else{
            onsuccess(results);
        }
    }, onfailure, onstop, onabort, onerror);
}