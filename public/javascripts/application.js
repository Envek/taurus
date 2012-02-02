jQuery(document).ready(function($) {

    // Send CSRF token with every request
    $(document).ajaxSend(function(e, xhr, options) {
      var token = $("meta[name='csrf-token']").attr("content");
      xhr.setRequestHeader("X-CSRF-Token", token);
    });
    
    // makes Rails to know that jQuery Ajax requests should be processed as .js format
    $.ajaxSetup({
        'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
    });

    // editor/classrooms/index
    $('#classroom_name').change(function() {
      $(this).autocomplete('disable'); // These two lines fixes bug with simultaneously
      $(this).autocomplete('enable'); // opening two same auditories at once (on fast clicking)
    });

    $('#classroom_name').autocomplete({
        disabled: false,
        source: function(request, response) {
            $.getJSON('/editor/classrooms.json', {
              classroom: request.term
            },
            function(data) {
                var classrooms = new Array(0);
                data.each(function(i) {
                    classrooms.push({ label: i.classroom.name + ' (' + i.classroom.building.name + ')', value: i.classroom.id });
                });
                response(classrooms);
            });
        },
        select: function(event, ui) {
          $.get('/editor/classrooms/' + ui.item.value);
          return false;
        }
    });

    $('#classroom_name').focus();

    $('.receiver').live('dblclick', function() {
        $.post('/editor/pairs/', {
            container: $(this).attr('id'),
            classroom_id: $(this).attr('grid_id'),
            week: $(this).attr('week_number'),
            day_of_the_week: $(this).attr('day_of_the_week'),
            pair_number: $(this).attr('pair_number')
        }, null, "script");
        return false;
    });

    $('.edit').live('click', function() {
      $.get('/editor/pairs/' + $(this).attr('pair_id') + '/edit', null, "script");
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
            $.post('/editor/pairs/' + pair_id, {_method: 'delete'}, null, "script");
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

    $('.grid_close').live('click', function() {
        $.post('/editor/classrooms/' + $(this).attr('grid_id'), {_method: 'delete'}, null, "script");
        return false;
    });

    $('.classroom_row').click(function() {
      window.open('/editor/classrooms?classroom_id=' + $(this).attr('id'));
      return false;
    });

    $('#group_name').autocomplete({
        disabled: false,
        source: function(request, response) {
            $.getJSON('/editor/groups_list.json', {}, function(data) {
                var groups = new Array(0);
                data.each(function(i) {
                    groups.push(i.group.id);
                });
                $.getJSON('/editor/groups.json', {
                    group: request.term,
                    except: groups
                },
                function(data) {
                    var groups = new Array(0);
                    data.each(function(i) {
                        groups.push({ label: i.group.name, value: i.group.id });
                    });
                    response(groups);
                });
            });
        },
        select: function(event, ui) {
            $.post('/editor/groups_list/groups', {id : ui.item.value});
            $('#group_name').val('');
            return false;
        }
    });

    $('.remove').live('click', function() {
        var group_id = $(this).attr('group_id');
        $.post('/editor/groups_list/groups/' + group_id, {_method: 'delete'});
        $('#group_name').focus();
    });

    $('.button').button();
    
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
                $.post('/editor/pairs/' + ui.draggable.attr('id'), {
                   _method: 'put',
                   classroom: $(this).attr('grid_id'),
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

    // Учебные планы у редакторов расписания

    // Поиск группы
    $("#teaching_plans_group_select").click( function () {
        var value = $("#teaching_plans_group_input").val();
        $("#teaching_plans_group_list tbody tr").each( function () {
            if ($("td:first-child", this).text().indexOf(value) < 0) {
                $(this).addClass("hidden");
            } else {
                $(this).removeClass("hidden");
            }
        });
    });
    $("#teaching_plans_group_reset").click( function () {
        $("#teaching_plans_group_input").val('');
        $("#teaching_plans_group_list tbody tr").removeClass("hidden");
    });
});
