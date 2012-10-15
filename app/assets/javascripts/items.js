$(document).ready(function(){
  var list = $("#item-container");
  // we want to make the list sortable, so use jQuery-UI's sortable() on doc ready
  $(list).sortable({
    placeholder: "ui-item-placeholder",
    cursor: 'move',
    update: function(){
      update_list(list);
    }
  });

  $("#item-container").disableSelection();
});

//
// This function issues a post request to the server to update the sortable list
// list = the list that has had sortable() executed on it
//
update_list = function(list) {
  try {
    var json_data = $(list).sortable('serialize');
    $.ajax({
	type: 'POST',
        url: '/items/update_list',
	data: json_data,
	dataType: 'json',
	success: function(data){
	  handle_success_response(data);
	}
    });
  } catch (e) {
    alert(e);
  }
};

//
// Handles the successful response from the update list
// data = the json data returned from the server
//
handle_success_response = function(data){
  $("#messages").addClass("success").html(data['message']).fadeIn(function(){
    $("#messages").delay(1000).fadeOut(1000, "linear");		     
  });
};
