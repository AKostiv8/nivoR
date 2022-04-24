$(document).on("shiny:connected", function() {
  $('#widgetOutput').click(function() {
    setTimeout(function(){
                    let getDataLocaleStorage = JSON.parse(localStorage.getItem('shinyStore-ex2\\areabump_clicked'));
                    Shiny.setInputValue("foo", getDataLocaleStorage);
                }, 100);
  })
});
