
$(function () {
    Highcharts.setOptions({
        global: {
            useUTC: false   // Dont apply client local time
        },
        exporting: {
	        enabled: true,
            sourceWidth: 1200,
            sourceHeight: 300,
        },
        /*lang: {
            loading: 'Chargement...',
            months: ['janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'aout', 'septembre', 'octobre', 'novembre', 'décembre'],
            weekdays: ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'],
            shortMonths: ['jan', 'fév', 'mar', 'avr', 'mai', 'juin', 'juil', 'aou', 'sep', 'oct', 'nov', 'déc'],
            exportButtonTitle: "Exporter",
            printButtonTitle: "Imprimer",
            rangeSelectorFrom: "Du",
            rangeSelectorTo: "au",
            rangeSelectorZoom: "Periode",
            downloadPNG: 'Telecharger en PNG',
            downloadJPEG: 'Telecharger en JPEG',
            downloadPDF: 'Telecharger en PDF',
            downloadSVG: 'Telecharger en SVG',
            resetZoom: "Reinitialiser le zoom",
            resetZoomTitle: "Reinitialiser le zoom",
            thousandsSep: " ",
            decimalPoint: ','
        },*/
        lang: {
            loading: 'Loading...',
            months: ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'],
            weekdays: ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'],
            shortMonths: ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'],
            exportButtonTitle: "Export",
            printButtonTitle: "Print",
            rangeSelectorFrom: "From",
            rangeSelectorTo: "to",
            rangeSelectorZoom: "Period",
            downloadPNG: 'Download PNG',
            downloadJPEG: 'Download JPEG',
            downloadPDF: 'Downloadn PDF',
            downloadSVG: 'Download SVG',
            resetZoom: "Unzoom",
            resetZoomTitle: "Unzoom",
            thousandsSep: " ",
            decimalPoint: ','
        },
        title: {
            visible: false,
            text: '',
            x: -20 //center
        },
        subtitle: {
            visible: false,
            text: '',
            x: -20
        },
        plotOptions: {
            series: {
                marker: {
                    enabled: false
                }
            },
        },
        tooltip: {
            shared: true,
            xDateFormat: '%d/%m/%Y, %Hh%M',
        },
        legend: {
            layout: 'horizontal',
            align: 'middle',
            verticalAlign: 'bottom',
            borderWidth: 0
        },
        plotLines: [{
            value: 0,
            width: 1,
        }],
    });
});

// Programmatically-defined buttons
$(".chart-export").each(function () {
    var jThis = $(this),
        chartSelector = jThis.data("chartSelector"),
        chart = $(chartSelector).highcharts();

    $("*[data-type]", this).each(function () {
        var jThis = $(this),
            type = jThis.data("type");
        if (Highcharts.exporting.supports(type)) {
            jThis.click(function () {
                chart.exportChartLocal({ type: type });
            });
        }
        else {
            jThis.attr("disabled", "disabled");
        }
    });
});