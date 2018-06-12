$(function(){
  $.ajax({
    type:'GET',
    url:'/RFM_Classes',
    success: function(obj){
    //customers: $.parseJSON(customers)
    //  $.each(customers, function(i, customer){
    //    $customers.append('<li>'+ customer.Loyals +'</li>')
    //  });
    var divId = document.getElementById("json")
   for(var i=0;i<obj.Loyals.length;i++)
   for(var keys in obj.Loyals[i]){
   console.log(keys +"-->"+obj.Loyals[i][keys]);
   divId.innerHTML = divId.innerHTML + "<br/>"+ keys +"-->"+obj.Loyals[i][keys];
}
    }
  });
});
