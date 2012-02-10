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
        $.post('/editor/groups/pairs/', {
            container: $(this).attr('id'),
            group_id: $(this).attr('grid_id'),
            week: $(this).attr('week_number'),
            day_of_the_week: $(this).attr('day_of_the_week'),
            pair_number: $(this).attr('pair_number')
        }, null, "script");
        return false;
    });

    $('.edit').live('click', function() {
      $.get('/editor/groups/pairs/' + $(this).attr('pair_id') + '/edit', null, "script");
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
        var grid_context = $(this).parent().parent();
        var newrcv = $('.receiver', grid_context).first().clone().empty();
        var rcvid = newrcv.attr('id');
        var index = $('.receiver', grid_context).length;
        rcvid = rcvid.substring(0, rcvid.lastIndexOf('_index')) + '_index' + index;
        newrcv.attr('id', rcvid);
        newrcv.attr('index', index);
        newrcv.removeClass('hidden_receiver');
        $('.receiver', grid_context).addClass('hidden_receiver');
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
        var count = $('.receiver', grid_context).length;
        $('.receiver_count', grid_context).text(count+"/"+count);
    });
    // Переключение между receiver'ами
    $('.receiver_prev').live('click', function() {
        var grid_context = $(this).parent().parent();
        var receivers = $('.receiver', grid_context);
        var count = receivers.length;
        var current = receivers.not('.hidden_receiver');
        if (current.prev().is('.receiver')) {
            current.addClass('hidden_receiver');
            current.prev().removeClass('hidden_receiver');
            var newnum = current.prevAll('.receiver').length; 
            $('.receiver_count', grid_context).text(newnum+"/"+count);
        }
    });
    $('.receiver_next').live('click', function() {
        var grid_context = $(this).parent().parent();
        var receivers = $('.receiver', grid_context);
        var count = receivers.length;
        var current = receivers.not('.hidden_receiver');
        if (current.next().is('.receiver')) {
            current.addClass('hidden_receiver');
            current.next().removeClass('hidden_receiver');
            var newnum = current.prevAll('.receiver').length; 
            $('.receiver_count', grid_context).text((newnum+2)+"/"+count);
        }
    });
    
});
