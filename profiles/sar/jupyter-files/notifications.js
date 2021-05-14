
require.config({paths: {toastr: "https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.1.4/toastr.min"}});

require([
    'jquery', 
    'toastr'
], function ($, toastr) {

    toastr.options = {
        "closeButton": true,
        "newestOnTop": true,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "preventDuplicates": true,
        "onclick": null,
        "showDuration": "30",
        "hideDuration": "10",
        "timeOut": "0",
        "extendedTimeOut": "0",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    }

    $.ajax({
        url: 'files/.notifications.json',
        method: 'GET',
        success: function (data) {
            console.log(data);

            let last_server_start = new Date( data['last_server_start'] || Date() )

            for (entry of data['notifications']) {
                console.log(entry)

                let date_expires = new Date(entry['date_expires'])

                if (date_expires >= last_server_start) {
                    toastr[entry['type']](entry['message'], "");
                }
            }
        },
        error: function(e) {
            console.log("Error with notifications.")
            console.log(e)
        }
    });
});
