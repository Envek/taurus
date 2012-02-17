jQuery(document).ready(function($) {

    // editor/groups/index
    $('#group_name').change(function() {
      $(this).autocomplete('disable'); // These two lines fixes bug with simultaneously
      $(this).autocomplete('enable'); // opening two same auditories at once (on fast clicking)
    });

    $('#group_name').autocomplete({
        disabled: false,
        source: function(request, response) {
            $.getJSON('/editor/groups/groups.json', {
              group: request.term
            },
            function(data) {
                var groups = new Array(0);
                data.each(function(i) {
                    groups.push({ label: i.group.name, value: i.group.id });
                });
                response(groups);
            });
        },
        select: function(event, ui) {
          $.get('/editor/groups/groups/' + ui.item.value);
          return false;
        }
    });

    $('#group_name').focus();

    $('.receiver').live('dblclick', function() {
        $.post('/editor/groups/pairs', {
            container: $(this).attr('id'),
            group_id: $(this).attr('grid_id'),
            week: $(this).attr('week'),
            subgroup: $(this).attr('sub'),
            day_of_the_week: $(this).attr('day_of_the_week'),
            pair_number: $(this).attr('pair_number')
        }, null, "script");
        return false;
    });

    $('.edit').live('click', function() {
      $.get('/editor/groups/pairs/' + $(this).attr('pair_id') + '/edit', {
        group_id: $(this).closest(".group_editor").attr('group_id'),
      }, "script");
      return false;
    });

    $('.destroy').live('click', function() {
      var pair_id = $(this).attr('pair_id');
      $(this).after('<span id="destroy-confirm">Вы уверены в том, что хотите удалить эту пару?</span>');
      $('#destroy-confirm').dialog({
        resizable: false,
        height: 140,
        width: 450,
  			modal: true,
        buttons: {
          "Удалить!": function() {
            $.post('/editor/groups/pairs/' + pair_id, {_method: 'delete'}, null, "script");
            $('#destroy-confirm').dialog( "close" );
            $('#destroy-confirm').remove();
          },
          "Отмена": function() {
  					$('#destroy-confirm').dialog( "close" );
            $('#destroy-confirm').remove();
          }
        }
		  });
    });

    $('.group_editor_close').live('click', function() {
        $.post('/editor/groups/groups/' + $(this).attr('group_id'), {_method: 'delete'}, null, "script");
        return false;
    });
    
    // Добавление ещё одного receiver-блока для создания ещё одной пары в том же временном окне
    $('.receiver_add').live('click', function() {
        var timeslot= $(this).parent().parent();
        var newrcv = $('<div class="receiver">');
        var index = $('.receiver', timeslot).length + $('.timeslot', timeslot).length;
        var grid_id = timeslot.attr('grid_id');
        newrcv.attr("id", timeslot.attr('id')+"_index"+index);
        newrcv.attr("grid_id", grid_id);
        newrcv.attr("day_of_the_week", timeslot.attr('day_of_the_week'));
        newrcv.attr("pair_number", timeslot.attr('pair_number'));
        newrcv.attr("week", timeslot.attr('week'));
        newrcv.attr('index', index);
        newrcv.addClass('receiver_'+grid_id);
        $('.receiver', timeslot).addClass('hidden');
        $('.timeslot', timeslot).addClass('hidden');
        newrcv.droppable({
            accept: '.pair',
            over: function(){ $(this).addClass('hovered_receiver');},
            out: function(){ $(this).removeClass('hovered_receiver');},
            drop: function(event, ui){
                $.post('/editor/groups/pairs/' + ui.draggable.attr('id'), {
                   _method: 'put',
                   group: $(this).attr('grid_id'),
                   week: $(this).attr('week_number'),
                   day_of_the_week: $(this).attr('day_of_the_week'),
                   pair_number: $(this).attr('pair_number'),
                   container: $(this).attr('id'),
                   index: index
                }, null, "script");
                $(this).removeClass('hovered_receiver');
            }
        });
        $(this).parent().before(newrcv);
        var count = $('.receiver', timeslot).length + $('.timeslot', timeslot).length;
        $('.receiver_count', timeslot).text(count+"/"+count);
    });
    // Переключение между receiver'ами
    $('.receiver_prev').live('click', function() {
        var timeslot = $(this).parent().parent();
        var receivers = $.merge($('.receiver', timeslot), $('.timeslot', timeslot));
        var count = receivers.length;
        var current = receivers.not('.hidden');
        if (current.prev().is('.receiver') || current.prev().is('.timeslot')) {
            current.addClass('hidden');
            current.prev().removeClass('hidden');
            var newnum = $.merge(current.prevAll('.receiver'), current.prevAll('.timeslot')).length;
            $('.receiver_count', timeslot).text(newnum+"/"+count);
        }
    });
    $('.receiver_next').live('click', function() {
        var timeslot = $(this).parent().parent();
        var receivers = $.merge($('.receiver', timeslot), $('.timeslot', timeslot));
        var count = receivers.length;
        var current = receivers.not('.hidden');
        if (current.next().is('.receiver') || current.next().is('.timeslot')) {
            current.addClass('hidden');
            current.next().removeClass('hidden');
            var newnum = $.merge(current.prevAll('.receiver'), current.prevAll('.timeslot')).length+2;
            $('.receiver_count', timeslot).text(newnum+"/"+count);
        }
    });
    
});
