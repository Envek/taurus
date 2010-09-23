jQuery(document).ready(function($){
    $.getJSON('/timetable/groups.json', function(data) {
        var groups = new Array(0);
        data.each(function(i) {
            groups.push({ label: i.group.name + ' (Нажать)', value: i.group.id });
        });

        $('#group_name_input_terminal').autocomplete({
            source: groups,
            select: function(event, ui) {
                window.location.replace('/timetable/groups/' + ui.item.value + '?terminal=true');
                return false;
            }
        });
        
        $('.number').click(function() {
            $('#group_name_input_terminal').focus();
            character = $(this).attr('id');
            $('#group_name_input_terminal').val($('#group_name_input_terminal').val() + character);
            $('#group_name_input_terminal').autocomplete("search");
        });
    });      

    $('.clear').click(function(){
        $('#group_name_input_terminal').val('');
    });

    $('.back_terminal').button({
        label: 'Назад'
    });

    $(".back_terminal").click(function() {
        window.location.replace('/timetable/groups?terminal=true');
        return false;
    });

    $('.number').button({
       
    })

    $('.clear').button({

    })
});


