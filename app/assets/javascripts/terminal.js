jQuery(document).ready(function($){

    if ($('body.terminal').size())
      timer = setTimeout("window.location.reload(true)", 45000);

    $('body.terminal').click (function () {
      clearTimeout(timer);
      timer = setTimeout("window.location.reload(true)", 45000);
    });
    
    $('.number').unbind('click').bind('click', function() {
        $('#group_name_input_terminal').focus();
        character = $(this).attr('id');
        $('#group_name_input_terminal').val($('#group_name_input_terminal').val() + character);
        $('#group_name_input_terminal').change();
        $('#group_name_input_terminal').autocomplete("search");
    });

    $('.clear').click(function(){
        $('#group_name_input_terminal').val('');
        $('#group_name_input_terminal').change();
    });

    $('.backspace').click(function() {
        var input =  $('#group_name_input_terminal');
        var group = input.val();
        input.val(group.slice(0,-1));
        input.change();
        input.focus();
        input.autocomplete("search");
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

    $('.backspace').button({

    })

    $('.daycellcontainer').click(function(){
     var content = $(this).clone();
     content.addClass('pairdialog');
     content.dialog({
        modal: true,
        width: 800,
        buttons: {
        	'Закрыть': function() {
        		$(this).dialog("close");
        	}
        }
    	});
    });
    
    $('#lecturer_name_input_terminal').keyboard({
        layout: 'custom',
        customLayout: {
            'default': [
                '{clear} й ц у к е н г ш щ з х ъ {b}',
                'ф ы в а п р о л д ж э',
                '{shift} я ч с м и т ь б ю . {shift}',
                '{space}'
                ],
            'shift': [
                '{clear} Й Ц У К Е Н Г Ш Щ З Х Ъ {b}',
                'Ф Ы В А П Р О Л Д Ж Э',
                '{shift} Я Ч С М И Т Ь Б Ю , {shift}',
                '{space}'
                ]
        },
        position: {
            of: $("#lecturer_name_terminal_wrapper"), // null = attach to input/textarea; use $(sel) to attach elsewhere
            my: 'right top',
            at: 'right top',
            at2: 'right top', // used when "usePreview" is false
            collision: 'none'
        },
        // true: preview added above keyboard; false: original input/textarea used
        usePreview: false,

        // if true, the keyboard will always be visible
        alwaysOpen: true, 
        
        // *** change keyboard language & look ***
        display: {
            'accept': 'ОК:Принять (Shift-Enter)',
            'b'     : '\u232b:Backspace',
            'clear' : '\u2716:Очистить',
            'cancel': 'Отмена:Отмена (Esc)',
            'shift' : 'Shift:Shift',
            'space' : ' :Пробел'
        },
        
        change: function(e, keyboard, el) {$(el).keydown();},

    });
});
