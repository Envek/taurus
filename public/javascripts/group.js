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
          of: '.group_name_input'
        }).width($('.group_name_input').width());
        $('<div>', {
          'class': String(type)+'_notify'
        }).text(text).appendTo(cont);
        cont.slideDown().delay(10000).slideUp();
    };

    $('#group_name_input, #group_name_input_terminal').focus();
    $('#group_name_input, #group_name_input_terminal').autocomplete({
        minLength: 2,
        focus: function(event, ui) {
          return false;
        },
        source: function(request, response) {
            // Pre-query interface preparations
            $('<img />', {
                src: '/images/loading_16.png',
                alt: 'Загрузка...',
                id: 'loading_spinner'
            }).appendTo('body').position({
                my: 'right center',
                at: 'right center',
                of: '.group_name_input'
            });
            $('.notify').dequeue();
            // Querying for group list
            $.ajax({
                url: '/timetable/groups.json',
                data: {group: request.term},
                dataType: 'json',
                timeout: 5000,
                success: function(data, status) {
                    if (data === null)
                        showNotify("Произошла ошибка: не удалось загрузить список групп, попробуйте чуть позже.", 'error');
                     else if (!data.length) {
                        $(".ui-autocomplete").hide();
                        showNotify('Не найдено групп по вашему запросу', 'info');
                    } else {
                    var label_addon = " ← нажать";
                    response($.map( data, function( item ) {
                        return {
                            label: item.group.name + label_addon,
                            value: item.group.id
                        }
                    }));
                    }
                },
                error: function(xhr, status) {
                    showNotify("Произошла ошибка: не удалось загрузить список групп, попробуйте чуть позже.", 'error');
                },
                complete: function(xhr, status) {
                    $('#loading_spinner').remove();
                }
            });
        },
        select: function(event, ui) {
            var suffix = "";
            if ($(this).attr('id') == "group_name_input_terminal") {
              suffix = "?terminal=true";
            }
            window.location.href ='/timetable/groups/' + ui.item.value + suffix;
            return false;
        }
    });

});