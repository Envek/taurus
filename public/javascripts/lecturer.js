jQuery(document).ready(function($){
    // makes Rails to know that jQuery Ajax requests should be processed as .js format
    $.ajaxSetup({
        'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
    });

    function showNotify (text, type) {
        var cont = $('<div>', {
          'class': 'notify',
          click: function() {$(this).dequeue();}
        }).appendTo('body')
        .position({
          my: 'left top',
          at: 'left bottom',
          of: '.lecturer_name_input'
        }).width($('.lecturer_name_input').width());
        $('<div>', {
          'class': String(type)+'_notify'
        }).text(text).appendTo(cont);
        cont.slideDown().delay(10000).slideUp();
    };

    var allowedLecturers = new Array();
    function checkButton () {
        var button = $('.lecturer_name button');
        var value = $('.lecturer_name input').val();
        for (var i in allowedLecturers) {
            if (allowedLecturers[i].label == value) {
                button.slideDown();
                return;
            }
        }
        button.slideUp();
    }

    function showTimetable (lecturer) {
        var suffix = "";
        if (location.search.lastIndexOf("terminal") > -1) {
            suffix = "?terminal=true";
        }
        window.location.href ='/timetable/lecturers/' + lecturer + suffix;
        return false;
    }

    $('.lecturer_name input').change(function(){
      $('.lecturer_name button').slideUp();
      $('.notify').dequeue();
    });
    
    $('.lecturer_name button').click(function () {
        var name = $('.lecturer_name input').val();
        for (var i in allowedGroups)
            if (allowedGroups[i].label == name)
                return showTimetable(allowedGroups[i].value);
    });

    $('#lecturer_name_input, #lecturer_name_input_terminal').focus();
    $('#lecturer_name_input, #lecturer_name_input_terminal').autocomplete({
        minLength: 2,
        focus: function(event, ui) {
          return false;
        },
        source: function(request, response) {
            // Pre-query interface preparations
            $('<img />', {
                src: '/images/ajax-loader-big.gif',
                alt: 'Загрузка...',
                id: 'loading_spinner'
            }).appendTo('body').position({
                my: 'right center',
                at: 'right center',
                of: '.lecturer_name_input'
            });
            $('.notify').dequeue();
            $('.group_name button').slideUp();
            // Querying for group list
            $.ajax({
                url: '/timetable/lecturers.json',
                data: {lecturer: request.term},
                dataType: 'json',
                timeout: 5000,
                success: function(data, status) {
                    if (data === null)
                        showNotify("Произошла ошибка: не удалось загрузить список преподавателей, попробуйте чуть позже.", 'error');
                     else if (!data.length) {
                        $(".ui-autocomplete").hide();
                        showNotify('Не найдено преподавателей по вашему запросу', 'info');
                    } else {
                    allowedLecturers = allowedLecturers.concat(
                        $.map( data, function( item ) {
                            return {
                                label: item.lecturer.name,
                                value: item.lecturer.id
                            }
                        })
                    );
                    var label_addon = " ← нажать";
                    response($.map( data, function( item ) {
                        return {
                            label: item.lecturer.name + label_addon,
                            value: item.lecturer.id
                        }
                    }));
                    }
                },
                error: function(xhr, status) {
                    showNotify("Произошла ошибка: не удалось загрузить список преподавателей, попробуйте чуть позже.", 'error');
                },
                complete: function(xhr, status) {
                    $('#loading_spinner').remove();
                }
            });
        },
        select: function(event, ui) {
            return showTimetable(ui.item.value);
        },
        close: function (event, ui) {
          checkButton();
        }
    });

});
