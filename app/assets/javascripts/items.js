$(document).ready(function(){
  var list = $("#item-container");
  $(list).sortable({
    placeholder: "ui-item-placeholder",
    cursor: 'move',
    update: function(){
      update_list(list);
    }
  });

  $("#item-container").disableSelection();
});

update_list = function(list) {
	try {
		var json_data = $(list).sortable('serialize');
		$.ajax({
			type: 'POST',
			url: '/items/update_list',
			data: json_data,
			dataType: 'json',
			success: function(data){
				handle_response(data);
			}
		});
	} catch (e) {
		alert(e);
	}
}

handle_response = function(data){
  $("#messages").addClass("success").html(data['message']).fadeIn(function(){
	$("#messages").delay(1000).fadeOut(1000, "linear");		     
  });
}
