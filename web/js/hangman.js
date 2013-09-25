(function($){
  $.Word = function(arg){
    this.id = arg.id;
    this.word = arg.word;
  };
})(jQuery);

var database = [];

$.extend({init_database:function(words){
  for(var i=0; i<words.length; i++){
    database.push(new $.Word(i, words[i]));
 //   console.log(i + " " + words[i]);
    
  }
}});

//var words =['hello', 'world', 'insert', 'hang', 'relex' ,];
$.init_database(words);
