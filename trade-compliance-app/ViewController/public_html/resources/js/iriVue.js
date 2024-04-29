var VueContentClone = {
};

function handleError(event) {
    console.log('handleError: ' + event.target.href);
}

function handleLoad(event) {
    console.log('handleLoad: ' + event.target.href);
    console.log('userAgent: ' +  navigator.userAgent);    
    console.log('browser: ' +  getBrowser());    
    //WebComponentsReady
    //HTMLImportsLoaded
    document.addEventListener('HTMLImportsLoaded', function (e) {
        console.log('HTMLImportsLoaded');
        
        // VUE
        var doc = document.getElementById("uploadImport").import;
        /* Grab DOM from imported document - all content of the DIV elelement with ID = content*/
        var div = doc.querySelector('#content');
        VueContentClone = div.cloneNode(true);
        
        if (getBrowser() != "Edge" && getBrowser() != "unknown") {
            var targetContainer = document.getElementById('app').appendChild(VueContentClone);    
        }        

        console.log("initDropzone");
        console.log("pageFlowId: " + pageFlowId);

        // DROPZONE
        Dropzone.autoDiscover = false;
        var min = 1000;
        var max = 9999;
        var randomNumber = Math.floor(Math.random() * (max - min + 1)) + min;
        var totalsize = 0.0;

        // Get the template HTML and remove it from the documents template HTML and remove it from the doument
        var previewNode = document.querySelector("#template");
        //console.log("previewNode: " + previewNode.id);
        previewNode.id = "";
        var previewTemplate = previewNode.parentNode.innerHTML;
        //console.log("previewTemplate: " + previewTemplate);
        previewNode.parentNode.removeChild(previewNode);

        var myDropzone = new Dropzone(document.body, 
        {
            // Make the whole body a dropzone
            url : "upload?id=" + randomNumber + "&pageFlowId=" + pageFlowId, // Set the url
            maxFiles : 10, maxFilesize : 25, parallelUploads : 10, timeout : 615000, // Set for 9.5 minutes.  Weblogic is set to 600 second timeout (10 minutes).  If less the WL, will the xhr will Cancel with no error to the Client.
            uploadMultiple : true, createImageThumbnails : false, previewTemplate : previewTemplate, autoQueue : false, // Make sure the files aren't queued until manually added
            previewsContainer : "#previews", // Define the container to display the previews
            clickable : ".fileinput-button", // Define the element that should be used as click trigger to select files.
            accept : function (file, done) {
                if (totalsize >= 25) {
                    file.status = Dropzone.CANCELED;
                    this._errorProcessing([file], "Total File Size limit is 25MB", null);
                }
                else {
                    done();
                }
            },
            init : function () {
                this.on("addedfile", function (file) {
                    totalsize += parseFloat((file.size / (1024 * 1024)).toFixed(2));
                    randomNumber++;
                    console.log("totalsize: " + totalsize);
                    console.log("randomNumber: " + randomNumber);
                });
                this.on("removedfile", function (file) {
                    if (file.upload.progress != 0) {
                        totalsize -= parseFloat((file.size / (1024 * 1024)).toFixed(2));
                        //console.log("totalsize: "+totalsize);
                    }
                });
                this.on("error", function (file) {
                    totalsize -= parseFloat((file.size / (1024 * 1024)).toFixed(2));
                    //console.log("totalsize: "+totalsize);
                });
            }
        });

        myDropzone.on("addedfile", function (file, xhr, formData) {
            // Hookup the start button
            file.previewElement.querySelector(".start").onclick = function () {
                myDropzone.enqueueFile(file);
            };
        });

        // Update the total progress bar
        myDropzone.on("totaluploadprogress", function (progress) {
            document.querySelector("#total-progress .progress-bar").style.width = progress + "%";
        });

        myDropzone.on("sending", function (file, xhr, formData) {
            // Show the total progress bar when upload starts        
            document.querySelector("#total-progress").style.opacity = "1";
            // And disable the start button
            file.previewElement.querySelector(".start").setAttribute("disabled", "disabled");
        });

        myDropzone.on("error", function (file, response) {
            // Show the total progress bar when upload starts
            file.previewElement.classList.add("dz-error");
        });

        // Hide the total progress bar when nothing's uploading anymore
        myDropzone.on("queuecomplete", function (progress) {
            document.querySelector("#total-progress").style.opacity = "0";
        });

        // Setup the buttons for all transfers
        // The "add files" button doesn't need to be setup because the config
        // `clickable` has already been specified.
        document.querySelector("#actions .start").onclick = function () {
            myDropzone.enqueueFiles(myDropzone.getFilesWithStatus(Dropzone.ADDED));
        };

        document.querySelector("#actions .cancel").onclick = function () {
            myDropzone.removeAllFiles(true);
        };

    });

}

function getBrowser() {
    if (navigator.userAgent.indexOf("Edge") !=  - 1) {
        return "Edge";
    }
    else if (navigator.userAgent.indexOf("MSIE") !=  - 1) {
        return "IE";
    }
    else if (navigator.userAgent.indexOf("Opera") !=  - 1) {
        return "Opera";
    }
    else if (navigator.userAgent.indexOf("Firefox") !=  - 1) {
        return "Firefox";
    }
    else if (navigator.userAgent.indexOf("Chrome") !=  - 1) {
        return "Chrome";
    }
    else {
        return "unknown";
    }
}