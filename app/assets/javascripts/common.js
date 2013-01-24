jQuery(document).ready(function($) {
  $('.semester_change+button').remove();
  $('.semester_change').change(function() {
    $(this).parent().submit();
  });
});

function formatResultedClassroomForSelect2 (result) {
    els = result.text.split(".");
    name = els[0].match(/^[\S^\:\(]+/g)[0]
    res = "<big><strong>"+name+"</strong>"+els[0].substring(name.length)+"</big><br/>";
    res += result.text.substring(els[0].length+1);
    return res;
}

function formatSelectedClassroomForSelect2 (result) {
    return result.text.split(".")[0];
}
