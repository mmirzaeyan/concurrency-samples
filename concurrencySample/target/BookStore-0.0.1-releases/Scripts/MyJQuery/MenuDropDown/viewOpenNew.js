// open new menu Form

$(function(){
    var button = $('#openNewButton');
    var box = $('#openBox');
    var form = $('#openNewForm');
    button.removeAttr('href');
    button.mouseup(function(menuDropDown) {
        box.toggle();
        button.toggleClass('active');
    });
    form.mouseup(function() { 
        return false;
    });
    $(this).mouseup(function(menuDropDown) {
        if(!($(menuDropDown.target).parent('#openNewButton').length > 0)) {
            button.removeClass('active');
            box.hide();
        }
    });
});

